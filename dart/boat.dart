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
  var speed = 3.0;
  var boatType;
  var fleetType;
  
  var initPos;
  
  List<Point> boatPath;

/**
 * Default constructor
 */
  Boat(this.x, this.y, var newBoatType, [var myfleetType]){
    boatmenu.initPopovers();
    fleetType = myfleetType;
    boatPath = new List<Point>();
    boatPath.add(new Point(x, y));
    initPos = new Point(x,y);
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
    if(fleetType == 'A' || fleetType =='B'){
      if(boatPath.length > 1){
        var dist = sqrt(pow((boatPath[1].x - boatPath[0].x), 2) + pow((boatPath[1].y - boatPath[0].y), 2));
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
  }

  
  num get iwidth => img.width;
  
  num get iheight => img.height;
  
  
  void draw(CanvasRenderingContext2D ctx, num width, num height) {
    ctx.save();
    {
      ctx.translate(x, y);
      ctx.rotate(heading + 3.1415/2);
      ctx.drawImage(img, -img.width/2, -img.height/2);
      if(fleetType == 'A' || fleetType == 'B'){
        ctx.lineWidth = 5;
        ctx. strokeStyle = 000;
        ctx.translate(0,0);
        ctx.rotate(-(heading + 3.1415/2));
        ctx.beginPath();
        for(int i = 0; i < boatPath.length; i++){
          ctx.lineTo(boatPath[i].x - boatPath.first.x, boatPath[i].y - boatPath.first.y);
        }
        ctx.stroke();
        ctx.closePath();
      }
     
    }    
    ctx.restore();
  }
  
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
    
    repaint();
  }
  
    
  void touchSlide(Contact c) { }  
 
  
}



class ForSaleBoat extends Boat {
  
  Buy buyPhase;
  num x = 0.0;
  num y = 0.0;
  num returnVel = 30.0;
  num error = .1;
  
  
  
  ForSaleBoat(Buy phase, num newX, num newY, var newBoatType) : super(newX, newY, newBoatType) {
    x = newX;
    y = newY;
    buyPhase = phase;
  }
  
  void animate(){
    if(_dragging == false){
      if(inBuySpace()){
        if((x > buyPhase.tunaWellX + error || x < buyPhase.tunaWellX - error) && (y > buyPhase.tunaWellY + error || y < buyPhase.tunaWellY - error)){
          num dist = sqrt(pow(x - buyPhase.tunaWellX, 2) + pow(y - buyPhase.tunaWellY, 2));
          if(dist > returnVel){
            move((buyPhase.tunaWellX - x)/dist*returnVel, (buyPhase.tunaWellY - y)/dist*returnVel);
          }
          else{
            move((buyPhase.tunaWellX - x)/dist*dist, (buyPhase.tunaWellY - y)/dist*dist);
          }
        }
      }
    }
  }
  
  bool inBuySpace(){
    num bx = buyPhase.buySquareX;
    num by = buyPhase.buySquareY;
    if(x >= bx && y >= by && x <= bx + buyPhase.buySquareWidth && y <= by + buyPhase.buySquareHeight){
      return true;
    }
    else{
      return false;
    }
  }
  
  bool touchDown(Contact c) {
    print("clicked on!");
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
    if(!inBuySpace()){
      buyPhase.deleteBoat(this);
    }
    
  }
  
    
  void touchSlide(Contact c) { }  
}