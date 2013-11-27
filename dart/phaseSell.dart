part of fwf;


class Sell extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  
  TouchManager tmanager = new TouchManager();
  
  Sell(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.font = '30px sans-serif';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'center';
    ctx.fillText("SELL STUFF: ", 100, 50);
    //fleetA.hide();
    //fleetB.hide();
  }
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
}