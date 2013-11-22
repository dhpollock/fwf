part of fwf;


class Buy extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  
  Boat buySardine;
  Boat buyTuna;
  Boat buyShark;
  
  TouchManager tmanager = new TouchManager();
  
  Buy(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
    
    buySardine = new Boat()
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
    
    
    
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    //ctx.fillRect(0, 0, width, height);
    ctx.fillText("BUY STUFF: ", 100, 50);
  }
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
}