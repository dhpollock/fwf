part of fwf;


class Buy extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  
  //intial well for sale boats  
  Boat buySardine;
  Boat buyTuna;
  Boat buyShark;
  
  //dimensions of buy box 
  num buySquareWidth = 400;
  num buySquareHeight = 200;
  num buySquareX = 300;
  num buySquareY = 300;
  
  //dimensions of fleet boxes for fleet A and B purchasing 
  num fleetABuySquareX = 0;
  num fleetABuySquareY = 110;
  num fleetAbuySquareWidth = 235;
  num fleetAbuySquareHeight = 600;
  
  num fleetBBuySquareX = 765;
  num fleetBBuySquareY = 110;
  num fleetBbuySquareWidth = 235;
  num fleetBbuySquareHeight = 600;
  
  //prices of boats 
  num sardinePrice = 100;
  num tunaPrice = 200;
  num sharkPrice = 300;
  
  //images for harbor and buy box 
  ImageElement harborOverlay = new ImageElement();
  ImageElement buyOverlay = new ImageElement();
  
  //coordinates for well boats 
  num tunaWellX, tunaWellY;
  num sardineWellX, sardineWellY;
  num sharkWellX, sharkWellY;
  
  TouchManager tmanager = new TouchManager();
  
  //list of all well boats 
  List<Boat> buyingSardine = new List<Boat>();
  List<Boat> buyingTuna = new List<Boat>();
  List<Boat> buyingShark = new List<Boat>();
  
  Buy(Fleet A, Fleet B){    
    fleetA = A;
    fleetB = B;

    sardineWellX = 350.0;
    sardineWellY = 400.0;
    
    tunaWellX = 500.0;
    tunaWellY = 400.0;
    
    sharkWellX = 650.0;
    sharkWellY = 400.0;
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
    
    //create new ForSaleBoats in well locations 
    Boat newSardine = new ForSaleBoat(this, sardineWellX, sardineWellY, 'sardine', sardinePrice);
    newSardine.heading = -PI/2;
    buyingSardine.add(newSardine);
    touchables.add(newSardine);
    
    Boat newTuna = new ForSaleBoat(this, tunaWellX, tunaWellY, 'tuna', tunaPrice);
    newTuna.heading = -PI/2;
    buyingTuna.add(newTuna);
    touchables.add(newTuna);
    
    Boat newShark = new ForSaleBoat(this, sharkWellX, sharkWellY, 'shark', sharkPrice);
    newShark.heading = -PI/2;
    buyingShark.add(newShark);
    touchables.add(newShark);
    
    
    harborOverlay.src = "images/harborOverlay.png";
    buyOverlay.src = "images/buyOverlay.png";
    
  }
  
  //keeps the well full 
  void boatTouched(ForSaleBoat boat) {
    if(boat.boatType == 'sardine'){
      Boat newSardine = new ForSaleBoat(this, sardineWellX, sardineWellY, 'sardine', sardinePrice);
      buyingSardine.add(newSardine);
      touchables.add(newSardine);
    }
    if(boat.boatType == 'tuna'){
      Boat newTuna = new ForSaleBoat(this, tunaWellX, tunaWellY, 'tuna', tunaPrice);
      buyingTuna.add(newTuna);
      touchables.add(newTuna);
    }
    if(boat.boatType == 'shark'){
      Boat newShark = new ForSaleBoat(this, sharkWellX, sharkWellY, 'shark', sharkPrice);
      buyingShark.add(newShark);
      touchables.add(newShark);
    }
  }

  
  
  void draw(CanvasRenderingContext2D ctx, num width, num height){
    ctx.clearRect(0, 0, width, height);
    ctx.drawImage(harborOverlay, 0, 0);
    ctx.drawImage(buyOverlay, 0, 0);
    ctx.fillStyle = 'black';
    ctx.font = '30px sans-serif';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'center';
    ctx.fillText("BUY STUFF: ", 100, 50);
    //buy box?
    ctx.fillStyle = 'grey';
    ctx.fillRect(buySquareX, buySquareY, buySquareWidth, buySquareHeight);
    //ctx.fillRect(fleetABuySquareX, fleetABuySquareY, fleetAbuySquareWidth, fleetAbuySquareHeight);
    //ctx.fillRect(fleetBBuySquareX, fleetBBuySquareY, fleetBbuySquareWidth, fleetBbuySquareHeight);
    ctx.fillStyle = 'white';
    
    ctx.fillText("Select Boats: ", 450, 250);
    ctx.fillText("${sardinePrice}", sardineWellX - 25, 350);
    ctx.fillText("${tunaPrice}", tunaWellX - 25, 350);
    ctx.fillText("${sharkPrice}", sharkWellX -25, 350);
    
    ctx.fillText("${fleetA.coin}", 50, 700);
    ctx.fillText("${fleetB.coin}", 900, 700);
    
    //draw boats
    
    if(buyingSardine.length > -1){
      for(Boat boat in buyingSardine){
       boat.draw(ctx, width, height);
      }
    }
    if(buyingTuna.length > -1){
      for(Boat boat in buyingTuna){
       boat.draw(ctx, width, height);
      }
    }
    if(buyingShark.length > -1){
      for(Boat boat in buyingShark){
       boat.draw(ctx, width, height);
      }
    }
    

    fleetA.draw(ctx, width, height);
    fleetB.draw(ctx, width, height);
    
  }
  
  void deleteBoat(ForSaleBoat boat){
    if(buyingSardine.remove(boat)){
      repaint();
      return;
    }
    else if(buyingTuna.remove(boat)){
      repaint();
      return;
    }
    else if(buyingShark.remove(boat)){
      repaint();
      return;
    }
  }
  
  void show(){
    tmanager.enable();
//    fleetA.show();
//    fleetB.show();
  }
  
  void hide(){
    tmanager.disable();
//    fleetA.hide();
//    fleetB.hide();
  }
  
  //animates boats sliding back to well 
  void animate() {
    if(buyingSardine.length > 0){
      for(Boat boat in buyingSardine){
       boat.animate();
      }
    }
    if(buyingTuna.length > 0){
      for(Boat boat in buyingTuna){
       boat.animate();
      }
    }
    if(buyingShark.length > 0){
      for(Boat boat in buyingShark){
       boat.animate();
      }
    }
  }

}
