part of fwf;


class Regrow extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  
  TouchManager tmanager = new TouchManager();
  
  Regrow(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.fillText("REGROW ALL THE FISHES ", 100, 50);
  }
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
}