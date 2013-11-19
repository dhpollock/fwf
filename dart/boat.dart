/*
 * Dart Sample Game
 */
/*hiii harmon*/

part of fwf;


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
  
  var boatType;
  var fleetType;

/**
 * Default constructor
 */
  Boat(this.x, this.y, var newBoatType, [var myfleetType]){
    boatmenu.initPopovers();
    fleetType = myfleetType;
    if(newBoatType == 'sardine' || newBoatType == 'tuna' || newBoatType == 'shark'){
      boatType = newBoatType;
      if(fleetType == 0){
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
    x += sin(heading) * distance;
    y -= cos(heading) * distance;
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
  }

  
  num get width => img.width;
  
  num get height => img.height;
  
  
  void draw(CanvasRenderingContext2D ctx) {
    ctx.save();
    {
      ctx.translate(x, y);
      ctx.rotate(heading);
      ctx.drawImage(img, -width/2, -height/2);
    }    
    ctx.restore();
  }
  
  void hide(){
    boatmenu.hidePopover("fishing-menu${menunum}");
  }
  
  
  bool containsTouch(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = x - width/2;
    num by = y - height/2;
    return (tx >= bx && ty >= by && tx <= bx + width && ty <= by + height);
  }
  
  
  bool touchDown(Contact c) {
    _targetX = c.touchX;
    _targetY = c.touchY;
    _dragging = true;
    Sounds.playSound("tick");
    return true;
  }

  
  void touchUp(Contact c) {
    _dragging = false;
    boatmenu.showPopover("fishing-menu${menunum}", x, y);
  }
  
  
  void touchDrag(Contact c) {
    move(c.touchX - _targetX, c.touchY - _targetY);
    _targetX = c.touchX;
    _targetY = c.touchY;
    repaint();
  }
  
    
  void touchSlide(Contact c) { }  
 
  
}