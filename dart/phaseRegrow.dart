part of fwf;


class Regrow extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  AgentManager ecosystem;
  
  TouchManager tmanager = new TouchManager();
  
  Regrow(Fleet A, Fleet B, AgentManager newEcosystem){
    fleetA = A;
    fleetB = B;
    ecosystem = newEcosystem;
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.fillText("REGROW ALL THE FISHES ", 100, 50);
    ecosystem.draw(ctx);
  }
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
  
  void animate(){
    ecosystem.animate();
    //ecosystem.sardines[0].draw(ctx);
  }
}