part of fwf;

class Point {
  num x, y;
  Point(this.x, this.y);
  Point.zero() : x = 0, y = 0;
}


class Boat extends stagexl.Sprite implements Touchable, stagexl.Animatable {

  static const TITLE = 0;
  static const FISHING = 1;
  static const REGROWTH = 2;
  static const BUY = 3;
  static const GAMEOVER = 4;
  static const TRANSITION = 5;
  
  static const SARDINE = 0;
  static const TUNA = 1;
  static const SHARK = 2;
  
  static const TEAMA = 0;
  static const TEAMB = 1;
    
  
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  stagexl.Tween _boatMove;
  stagexl.Tween _boatRotate;
  
  /* coordinates in world space */
  num x = 0.0, y = 0.0;
  
  /* heading in radians */
  num heading = 0.0;
  
  /* random number generator */
  static Random rand = new Random();
  
  /* width and height of the bitmap */
  num _width = 0.0, _height = 0.0;

  /* used for mouse / touch interaction */  
  double _targetX, _targetY;
  
  /* is this boat being touched now? */
  bool _dragging = false;
  
//  var boatmenu = new Menu();
  
  num menunum;
  
  //BUY Phase parameters
  num returnVel = 30.0;
  num error = .1;
  
  //speed of path follow 
  var speed = 5.0;
  
  var boatType;
  var fleetType;
  num fishCount;
  num oldfishCount;
  num capacity;
  
  var initPos;
  
  List<Point> boatPath;
  
  stagexl.Bitmap boatImg;
  stagexl.Sprite boatSprite;

/**
 * Default constructor
 */
  Boat(this._resourceManager, this._juggler, this.x, this.y, this.boatType, [this.fleetType]){
    //intializes the menu for net selection
//    boatmenu.initPopovers();
    
    boatSprite = new stagexl.Sprite();
    addChild(boatSprite);
    boatImg = new stagexl.Bitmap(_resourceManager.getBitmapData("boatsardineA"));
    boatSprite.addChild(boatImg);
//    tmanager.add(boatImg);
  }
  
  
  bool advanceTime(num time){
    return true;
  }
  
  bool containsTouch(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = x - boatImg.width/2;
    num by = y - boatImg.height/2;
    return (tx >= bx && ty >= by && tx <= bx + boatImg.width && ty <= by + boatImg.height);
  }
  
  
  bool touchDown(Contact c) {
    _targetX = c.touchX;
    _targetY = c.touchY;
    _dragging = true;
    print("touched");
    return true;
  }

  
  void touchUp(Contact c) {
    _dragging = false;
    print("touch up");
  }
  void touchSlide(Contact c) {  }
  
  
  void touchDrag(Contact c) {
    if((fleetType == TEAMA || fleetType ==TEAMB) && game.phase == FISHING){
//     Movement.boatGoTo(c.touchX, c.touchY, _juggler, _boatMove, _boatRotation);
    }
    else if((fleetType == TEAMA || fleetType ==TEAMB) && game.phase == FISHING){
      x = c.touchX;
      y = c.touchY;
    }
    _targetX = c.touchX;
    _targetY = c.touchY;
  }
  
}