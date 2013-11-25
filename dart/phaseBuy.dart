part of fwf;


class Buy extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  
  buyObject buySardine;
  Boat buyTuna;
  Boat buyShark;
  
  num buySquareWidth = 700;
  num buySquareHeight = 500;
  num buySquareX = 200;
  num buySquareY = 200;
  
  
  num tunaWellX, tunaWellY;
  
  TouchManager tmanager = new TouchManager();
  
  List<Boat> buyingTuna = new List<Boat>();
  
  Buy(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
    
    tunaWellX = 550.0;
    tunaWellY = 450.0;
    
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
    
    //buySardine = new buyObject(450, 450, 'sardine', touchables);
    Boat newTuna = new ForSaleBoat(this, tunaWellX, tunaWellY, 'tuna');
    buyingTuna.add(newTuna);
    //buyShark = new Boat(650, 450, 'shark', 0);
    
    touchables.add(newTuna);
  }
  
  void boatTouched(ForSaleBoat boat) {
    Boat newTuna = new ForSaleBoat(this, tunaWellX, tunaWellY, 'tuna');
    buyingTuna.add(newTuna);
    touchables.add(newTuna);
    print("One of my boats was purchased!");
  }

  var selectSardine = new Boat(450, 450, 'sardine', 0);
  var selectTuna = new Boat(550, 450, 'tuna', 0);
  var selectShark = new Boat(650, 450, 'shark', 0);
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.fillText("BUY STUFF: ", 100, 50);
    //buy box?
    ctx.fillStyle = 'grey';
    ctx.fillRect(buySquareX, buySquareY, buySquareWidth, buySquareHeight);
    ctx.fillStyle = 'white';
    ctx.fillText("Select Boats: ", 450, 250);
    
    //draw boats
    //buySardine.draw(ctx, width, height);
    
    if(buyingTuna.length > -1){
      for(Boat boat in buyingTuna){
       boat.draw(ctx, width, height);
      }
    }
    
    //buyTuna.draw(ctx, width, height);
    //buyShark.draw(ctx, width, height);
    fleetA.draw(ctx, width, height);
    fleetB.draw(ctx, width, height);
    
    //selectSardine.draw(ctx, width, height);
    //selectTuna.draw(ctx, width, height);
    //selectShark.draw(ctx, width, height);
  }
  
  void deleteBoat(ForSaleBoat boat){
    if(buyingTuna.remove(boat)){
      repaint();
      return;
    }
  }
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
  void animate() {
    if(buyingTuna.length > -1){
      for(Boat boat in buyingTuna){
       boat.animate();
      }
    }
    //buyTuna.animate();
    //buyShark.animate();
  }

}

class buyObject implements Touchable{
  ImageElement img = new ImageElement();
  num x, y;
  var type;
  List<Boat> dragBoats = new List<Boat>();
  List touchables;
  
  buyObject(num newX, num newY, var myType, List myTouchables){
    x = newX;
    y = newY;
    type = myType;
    touchables = myTouchables;
    if(type == 'sardine' || type == 'tuna' || type == 'shark'){
      img.src = "images/boat${type}.png";
    }
    Boat tempBoat = new Boat(x, y, type);
    dragBoats.add(tempBoat);
    touchables.insert(0,tempBoat);
  }
  
  void draw(CanvasRenderingContext2D ctx, num width, num height) {
    ctx.save();
    {
      ctx.translate(x, y);
      ctx.rotate(0 + 3.1415/2);
      ctx.drawImage(img, -img.width/2, -img.height/2);
    }    
    ctx.restore();
  }
  
  List<Boat> getDragged(){
    return dragBoats;
  }
  
  bool containsTouch(Contact c) {
    return true;
  }
  
  bool touchDown(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = x - img.width/2;
    num by = y - img.height/2;
    if(tx >= bx && ty >= by && tx <= bx + img.width && ty <= by + img.height){
      print(type);
      Boat tempBoat = new Boat(x, y, type);
      dragBoats.add(tempBoat);
      touchables.add(tempBoat);
      return true;
    }
    else{
      return false;
    }
  }

  
  void touchUp(Contact c) {

  }
  
  
  void touchDrag(Contact c) {

  }
  
    
  void touchSlide(Contact c) { }  
 
}