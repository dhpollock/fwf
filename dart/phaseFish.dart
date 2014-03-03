part of fwf;


class Fish extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  TouchManager tmanager = new TouchManager();
  
  AgentManager ecosystem;
  
  bool active;
  
  num timerCount;
  num phaseDuration;
  
  Fish(Fleet A, Fleet B, AgentManager newEcosystem){
    fleetA = A;
    fleetB = B;

    ecosystem = newEcosystem;
    
    phaseDuration = 15;
    active = false;
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
    
    
    const countdown = const Duration(seconds : 1);
    new Timer.periodic(countdown, (timer) => updateTimer());

  }
  
  
  void draw(CanvasRenderingContext2D ctx, num width, num height){
    ctx.clearRect(0, 0, width, height);
//    ecosystem.draw(ctx);
    // draw some text
    ctx.fillStyle = 'black';
    ctx.font = '30px sans-serif';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'center';
    ctx.fillText("Player 1: ", 100, 50);
    
    ctx.fillStyle = 'black';
    ctx.font = '30px sans-serif';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'center';
    ctx.fillText("Player 2: ", 700, 50);
    
    ctx.fillText("${fleetA.coin}", 50, 700);
    ctx.fillText("${fleetB.coin}", 900, 700);
    
    if (!game.debugTransition && active){
      ctx.fillRect(100, 100, (phaseDuration - timerCount) * 10, 50);
    }
    
    // draw the boats
    fleetA.draw(ctx, width, height);
    fleetB.draw(ctx, width, height);
  }
  
  void animate(){
    if(game.debugTransition){
      ecosystem.animate();
    }
    if(active){
      ecosystem.animate();
      if(timerCount >= phaseDuration){
        stopTimer();
        if (!game.debugTransition){
          game.transition();
        }
      }
   }
    collisionDetect(fleetA);
    collisionDetect(fleetB);
    
    var prices = {
      'sardines' : 10,
      'sharks' : 30,
      'tuna' : 20
    };
    
    fleetA.animateFishPhaseUnload(prices);
    fleetB.animateFishPhaseUnload(prices);
  }
  
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
  
  void startTimer(){
    timerCount = 0;
    active = true;
  }
  
  void updateTimer(){
    if(active){
      timerCount++;
    }
  }
  
  void stopTimer(){
    active = false;
    timerCount = 0;
  }
  
  void collisionDetect(Fleet fleet) {
    for(Boat boat in fleet.boats) {
      collideChecker(boat);
    }
  }
  
  
  void collideChecker(Boat boat){
    Boat boatHit = fleetA.collided(boat);
    num dif = PI/12;
    if(boatHit != null) {
      boatHit.collide(boat);
      boat.collide(boatHit);
    }
    boatHit = fleetB.collided(boat);
    if(boatHit != null) {
      boatHit.collide(boat);
      boat.collide(boatHit);
    }
  }
}