/*
 * Dart Sample Game
 */
/*hiii harmon*/

part of fwf;

class Point {
  num x, y;
  Point(this.x, this.y);
  Point.zero() : x = 0, y = 0;
}


class Boat implements Touchable {

  /* coordinates in world space */
  num x = 0.0, y = 0.0;
  
  /* heading in radians */
  num heading = 0.0;
  
  /* bitmap image */
  ImageElement img = new ImageElement();
  
  /* random number generator */
  static Random rand = new Random();
  
  /* width and height of the bitmap */
  num _width = 0.0, _height = 0.0;

  /* used for mouse / touch interaction */  
  double _targetX, _targetY;
  
  /* is this boat being touched now? */
  bool _dragging = false;
  
  var boatmenu = new Menu();
  
  num menunum;
  
  //speed of path follow 
  var speed = 5.0;
  
  var boatType;
  var fleetType;
  num fishCount;
  
  var initPos;
  
  List<Point> boatPath;

/**
 * Default constructor
 */
  Boat(this.x, this.y, var newBoatType, [var myfleetType]){
    //intializes the menu for net selection
    boatmenu.initPopovers();
    fleetType = myfleetType;
    
    fishCount = 0;
    
    //intialize path drawing coordinate list, add starting position to list
    boatPath = new List<Point>();
    boatPath.add(new Point(x, y));
    
    //save starting position for coordinate reference frame 
    initPos = new Point(x,y);
    
    //loads boat image dependant on type and fleet 
    if(newBoatType == 'sardine' || newBoatType == 'tuna' || newBoatType == 'shark'){
      boatType = newBoatType;

      if(fleetType == null){
        img.src = "images/boat${boatType}.png";
      }
      else{
        img.src = "images/boat${boatType}${fleetType}.png";
        menunum = 1;
      }
    }
    else{
      print("error, wrong type of boat");
    }
  }
  
  
  void move(num dx, num dy) {
    x += dx;
    y += dy;
  }

  
  void forward(num distance) {
    x += cos(heading) * distance;
    y += sin(heading) * distance;
  }
  
     
  void backward(num distance) {
    forward(-distance);
  }
  
  
  void left(num degrees) {
    heading -= (degrees / 180.0) * PI;   
  }
  
  
  void right(num degrees) {
    left(-degrees);
  }
  
  
  void animate() {
    //animates boat moving along boatPath 
    if(fleetType == 'A' || fleetType =='B'){
      if(boatPath.length > 1){
        var dist = sqrt(pow((boatPath[1].x - boatPath[0].x), 2) + pow((boatPath[1].y - boatPath[0].y), 2));
        
        //if statement prevents boat from overshooting target given a velocity 
        if(dist > speed){
          heading = atan2((boatPath[1].y - boatPath[0].y), (boatPath[1].x - boatPath[0].x));
          forward(speed);
          boatPath[0].x = x;
          boatPath[0].y = y;
        }
        else{
          heading = atan2((boatPath[1].y - boatPath[0].y) , (boatPath[1].x - boatPath[0].x));
          forward(dist);
          boatPath.removeAt(0);
        }
      }
    }
    else{

    }
    game.ecosystem.catchCheck(this);
  }
  
  bool animateGoTo(num goToX, num goToY){
    clearPath();
    var dist = sqrt(pow((goToX - x), 2) + pow((goToY - y), 2));
    if(dist > speed){
      heading = atan2((goToY - y), (goToX - x));
      forward(speed);
      return false;
    }
    else{
      heading = atan2((goToY - y) , (goToX - x));
      forward(dist);
      return true;   
    }
  }
  
  
  num textSize = 1;
  var textString = null;
  num textX= 0.0, textY = 0.0, textHeading = 0.0;
  num textSpeed = .25;
  bool animateBoatText(var string, num goToX, num goToY){
    textString = string;
    var dist = sqrt(pow((goToX - textX), 2) + pow((goToY - textY), 2));
    if(dist > textSpeed){
      textHeading = atan2((goToY - textY), (goToX - textX));
      textX += cos(textHeading) * textSpeed;
      textY += sin(textHeading) * textSpeed;
      textSize += 3;
      return false;
    }
    else{
      textHeading = atan2((goToY - textY) , (goToX - textX));
      textX += cos(textHeading) * dist;
      textY += sin(textHeading) * dist;
      textSize += 5;
      return true;   
    }
  }
  
  bool flashSellSign = false;
  bool sold = false;
  
  bool animateSellFish(num price){
    if(!flashSellSign){
      forward(10); 
      textSize = 1;
      textString = null;
      textX= 0.0; textY = 0.0; textHeading = 0.0;
      flashSellSign = true;
    }
    if(animateBoatText("${price*fishCount}", 5, 5)){
      backward(10);
      flashSellSign = false;
      sold = true;
      return true;
    }
    return false;

    
  }

  void clearPath(){
    boatPath.clear();
    boatPath.add(new Point(x, y));
  }
  
  void collide(Boat boatHit){
    clearPath();
    num temp = heading;
    heading = -atan2((boatHit.y - y) , (boatHit.x - x));
    forward(speed/2);
    heading = temp;
  }
  
  
  num get iwidth => img.width;
  
  num get iheight => img.height;
  
  num radarHeading = 0;
  void draw(CanvasRenderingContext2D ctx, num width, num height) {
    ctx.save();
    {
      ctx.translate(x, y);
      ctx.rotate(heading + PI/2);
      ctx.drawImage(img, -img.width/2, -img.height/2);
      
      //draws boatPath on canvas
      if(fleetType == 'A' || fleetType == 'B'){
        ctx.lineWidth = 2;
        ctx. strokeStyle = 000;
        ctx.translate(0,0);
        ctx.rotate(-(heading + PI/2));
        ctx.beginPath();
        for(int i = 0; i < boatPath.length; i++){
          ctx.lineTo(boatPath[i].x - boatPath.first.x, boatPath[i].y - boatPath.first.y);
        }
        ctx.stroke();
        ctx.closePath();
      }
     
    }
    
    if(_dragging && boatPath.length > 1){
      num r = 50;
      ctx.beginPath();
      ctx.arc(boatPath.last.x- boatPath.first.x, boatPath.last.y- boatPath.first.y, r, 0, 2*PI, false);
      ctx.stroke();
      ctx.closePath();
      
      ctx.beginPath();
      ctx.lineTo(boatPath.last.x- boatPath.first.x, boatPath.last.y- boatPath.first.y);
      ctx.lineTo(boatPath.last.x + r * cos(radarHeading) - boatPath.first.x,boatPath.last.y + r* sin(radarHeading) - boatPath.first.y);
      ctx.stroke();
      ctx.closePath();
      radarHeading += PI/60;
      Point adjustedCenter = new Point(0,0);
      adjustedCenter.x = boatPath.last.x- boatPath.first.x;
      adjustedCenter.y =  boatPath.last.y- boatPath.first.y;
      ctx.translate(-x, -y);
      game.fish.ecosystem.drawPortal(ctx, boatPath.last, r);
      
    }
    
    if(flashSellSign){
      ctx.fillStyle = 'white';
      ctx.font = '${textSize}px sans-serif';
      ctx.textAlign = 'left';
      ctx.textBaseline = 'center';
      ctx.fillText(textString, textX, textY);
    }
    ctx.restore();
  }
  
  bool dragging(){
    if(_dragging && boatPath.length > 1){
      return true;
    }
    else{
      return false;
    }
  }
  
  //hides menus for net selection
  void hide(){
    boatmenu.hidePopover("fishing-menu${menunum}");
  }
  
  
  bool containsTouch(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = x - iwidth/2;
    num by = y - iheight/2;
    return (tx >= bx && ty >= by && tx <= bx + iwidth && ty <= by + iheight);
  }
  
  
  bool touchDown(Contact c) {
    _targetX = c.touchX;
    _targetY = c.touchY;
    _dragging = true;
    boatPath.clear();
    Sounds.playSound("tick");
    return true;
  }

  
  void touchUp(Contact c) {
    _dragging = false;
   // boatmenu.showPopover("fishing-menu${menunum}", x, y);
  }
  
  
  void touchDrag(Contact c) {
    if(fleetType == 'A' || fleetType =='B'){
      boatPath.add(new Point(c.touchX,c.touchY));
    }
//    else{
//      move(c.touchX - _targetX, c.touchY - _targetY);
//    }
    _targetX = c.touchX;
    _targetY = c.touchY;
    
    //repaint();
  }
  
    
  void touchSlide(Contact c) { }  
 
  
}



class ForSaleBoat extends Boat {
  
  Buy buyPhase;
  num x = 0.0;
  num y = 0.0;
  num returnVel = 30.0;
  num error = .1;
  num price;
  num fleetMax = 3;
  
  
  
  ForSaleBoat(Buy phase, num newX, num newY, var newBoatType, num  newPrice) : super(newX, newY, newBoatType) {
    x = newX;
    y = newY;
    buyPhase = phase;
    price = newPrice;
    heading = -PI/2;
  }
  
  void animate(){
    num wellX, wellY;
    //slide back to well animiation 
    
    if(_dragging == false){
      if(!canBuy()){
        
        if(boatType == 'sardine'){
          wellX = buyPhase.sardineWellX;
          wellY = buyPhase.sardineWellY;
        }
        else if(boatType == 'tuna'){
          wellX = buyPhase.tunaWellX;
          wellY = buyPhase.tunaWellY;
        }
        else if(boatType == 'shark'){
          wellX = buyPhase.sharkWellX;
          wellY = buyPhase.sharkWellY;
        }
        
        if((x > wellX + error || x < wellX - error) && (y > wellY + error || y < wellY - error)){
          num dist = sqrt(pow(x - wellX, 2) + pow(y - wellY, 2));
          if(dist > returnVel){
            move((wellX - x)/dist*returnVel, (wellY - y)/dist*returnVel);
          }
          else{
            move((wellX - x)/dist*dist, (wellY - y)/dist*dist);
          }
        }
      }
    }
  }
  
  bool canBuy(){
    num abx = buyPhase.fleetABuySquareX;
    num aby = buyPhase.fleetABuySquareY;
    num bbx = buyPhase.fleetBBuySquareX;
    num bby = buyPhase.fleetBBuySquareY;
    
    //if boat is within the buy box for fleet A 
    if(x >= abx && y >= aby && x <= abx + buyPhase.fleetAbuySquareWidth && y <= aby + buyPhase.fleetAbuySquareHeight){
      //if player has enough money to buy boat and less than fleetMax amount of boats 
      if(buyPhase.fleetA.coin >= price && buyPhase.fleetA.boatCount < fleetMax){
        buyPhase.fleetA.addBoat(boatType);
        buyPhase.fleetA.coin -= price;
        return true;
      }
      else{
        return false;
      }
    }
    
    //same for fleet B
    else if(x >= bbx && y >= bby && x <= bbx + buyPhase.fleetBbuySquareWidth && y <= bby + buyPhase.fleetBbuySquareHeight){
      if(buyPhase.fleetB.coin >= price && buyPhase.fleetB.boatCount < fleetMax){
        buyPhase.fleetB.addBoat(boatType);
        buyPhase.fleetB.coin -= price;
        return true;
      }
      else{
        return false;
      }
    }
    else{
      return false;
    }
  }
  
  bool touchDown(Contact c) {
    buyPhase.boatTouched(this);
    _dragging = true;
    return true;
  }
  
  void touchDrag(Contact c) {
    move(c.touchX - x, c.touchY - y);
    _targetX = c.touchX;
    _targetY = c.touchY;    
    repaint();
  }
  
  void touchUp(Contact c) {
    _dragging = false;
    if(canBuy()){
      buyPhase.deleteBoat(this);
    }
    
  }
  
    
  void touchSlide(Contact c) { }  
}