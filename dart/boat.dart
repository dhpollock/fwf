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
<<<<<<< HEAD
      img.src = "images/boat${boatType}${fleetType}.png";
      menunum = 1;
=======
      if(fleetType == 0){
        img.src = "images/boat${boatType}.png";
      }
      else{
        img.src = "images/boat${boatType}${fleetType}.png";
        menunum = 1;
      }
>>>>>>> buyPhase
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

  
  num get iwidth => img.width;
  
  num get iheight => img.height;
  
  
  void draw(CanvasRenderingContext2D ctx, height, width) {
    ctx.save();
    {
      ctx.translate(x, y);
      ctx.rotate(heading + 3.1415/2);
      ctx.drawImage(img, -iwidth/2, -iheight/2);
      ctx.lineWidth = 5;
      ctx. strokeStyle = 000;
      ctx.translate(0,0);
      ctx.rotate(-(heading + 3.1415/2));
      ctx.beginPath();
      for(int i = 0; i < boatPath.length; i++){
        ctx.lineTo(boatPath[i].x - boatPath.first.x, boatPath[i].y - boatPath.first.y);
      }
      ctx.stroke();
      //ctx.closePath();
     
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
    //move(c.touchX - _targetX, c.touchY - _targetY);
    boatPath.add(new Point(c.touchX,c.touchY));
    _targetX = c.touchX;
    _targetY = c.touchY;
    
    repaint();
  }
  
    
  void touchSlide(Contact c) { }  
 
  
}