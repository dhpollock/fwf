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
    ecosystem.draw(ctx);
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
  
}