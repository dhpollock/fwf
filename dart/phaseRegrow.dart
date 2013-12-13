part of fwf;


class Regrow extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  AgentManager ecosystem;
  
  TouchManager tmanager = new TouchManager();
  bool active;
  
  num timerCount;
  num phaseDuration;

  Regrow(Fleet A, Fleet B, AgentManager newEcosystem){
  
    fleetA = A;
    fleetB = B;
    ecosystem = newEcosystem;
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
    
    phaseDuration = 15;
    active = false;
    
    const countdown = const Duration(seconds : 1);
    new Timer.periodic(countdown, (timer) => updateTimer());
    
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.fillText("REGROW ALL THE FISHES ", 100, 50);
    ecosystem.draw(ctx);
    if (!game.debugTransition && active){
      ctx.fillStyle = 'black';
      ctx.fillRect(100, 100, (phaseDuration - timerCount) * 10, 50);
    }
    
  }
  
  void animate(){
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