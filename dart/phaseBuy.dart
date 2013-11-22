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
  
 
  var buySardine = new Boat(450, 450, 'sardine', 0);
  var buyTuna = new Boat(550, 450, 'tuna', 0);
  var buyShark = new Boat(650, 450, 'shark', 0);
  
  var selectSardine = new Boat(450, 450, 'sardine', 0);
  var selectTuna = new Boat(550, 450, 'tuna', 0);
  var selectShark = new Boat(650, 450, 'shark', 0);
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.fillText("BUY STUFF: ", 100, 50);
    //buy box?
    ctx.fillStyle = 'grey';
    ctx.fillRect(200, 200, 700, 500);
    ctx.fillStyle = 'white';
    ctx.fillText("Select Boats: ", 450, 250);
    
    //draw boats
    buySardine.draw(ctx);
    buyTuna.draw(ctx);
    buyShark.draw(ctx);
    
    selectSardine.draw(ctx);
    selectTuna.draw(ctx);
    selectShark.draw(ctx);
  }
  
<<<<<<< HEAD
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
=======
  void animate() {
    selectSardine.animate();
    selectTuna.animate();
    selectShark.animate();
  }

>>>>>>> buyPhase
}