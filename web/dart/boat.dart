part of fwf;

class Point {
  num x, y;
  Point(this.x, this.y);
  Point.zero() : x = 0, y = 0;
}

class Boat extends stagexl.Bitmap implements Touchable, stagexl.Animatable {

  static const TITLE = 0;
  static const FISHING = 1;
  static const REGROWTH = 2;
  static const BUY = 3;
  static const GAMEOVER = 4;
  static const TRANSITION = 5;
  
  static const SARDINE = 1;
  static const TUNA = 2;
  static const SHARK = 3;
  
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  static const SPEED = 5.0;
  
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  stagexl.Tween boatMovement;
  stagexl.Tween _boatRotate;
  
  /* coordinates in world space */
  num _goalX,_goalY = 0.0;
  
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
  
  var boatType;
  var fleetType;
  num fishCount;
  num oldfishCount;
  num capacity;
  static const scale = 0.15;
  
  stagexl.Bitmap boatImg;
  stagexl.Sprite boatSprite;
  Game _game;
  stagexl.BitmapData bitmapData;

/**
 * Default constructor
 */
  Boat(stagexl.BitmapData bdata,this._resourceManager, this._juggler, this._game,num inX,num inY, this.boatType, [this.fleetType]):super(bdata){

    
    bitmapData = bdata;
    this.scaleX = scale;
    this.scaleY = scale;
    pivotX = bitmapData.width/2;
    pivotY = bitmapData.height/2;
    x = inX;
    y = inY;
    _goalX = x;
    _goalY = y;
    fishCount = 0;
    capacity = 1000;
  }
  
  void forward(num distance) {
    x += cos(rotation) * distance;
    y += sin(rotation) * distance;
  }
  
  bool advanceTime(num time){
    if(_goalX != x || _goalY !=y){
      rotation = atan2(_goalY - y, _goalX - x);
      num curSpeed;
      num dist = sqrt(pow((_goalX - x), 2) + pow((_goalY - y), 2)); 
      if(dist.abs() < SPEED){
        curSpeed = dist;
      }
      else{
        curSpeed = SPEED;
      }
    forward(curSpeed);
    }
    
    if(fishCount < capacity){
      _game.ecosystem.catchCheck(this);
    }
    return true;
  }
  
  bool containsTouch(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = x - bitmapData.width/2*scale;
    num by = y - bitmapData.height/2*scale;
    bool contain = (tx >= bx && ty >= by && tx <= bx + bitmapData.width && ty <= by + bitmapData.height);
    return contain;
  }
  
  
  bool touchDown(Contact c) {
    _goalX = c.touchX;
    _goalY = c.touchY;
    _dragging = true;
    return true;
  }

  
  void touchUp(Contact c) {
    _goalX = x;
    _goalY = y;
    _dragging = false;
  }
  void touchSlide(Contact c) {  }
  
  
  void touchDrag(Contact c) {
      _goalX = c.touchX;
      _goalY = c.touchY;
  }
  
}