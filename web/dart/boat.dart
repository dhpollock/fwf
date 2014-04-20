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
  static const scale =1;
  
  stagexl.Bitmap boatImg;
  stagexl.Sprite boatSprite;
  Game _game;  
  Net myNet;
  
  bool hitRecovery;

/**
 * Default constructor
 */
  Boat(this._resourceManager, this._juggler, this._game,num inX,num inY, this.boatType, this.fleetType){

    boatSprite = new stagexl.Sprite();
    addChild(boatSprite);
    boatImg = new stagexl.Bitmap(_resourceManager.getBitmapData("${boatString(boatType, fleetType)}"));
    boatSprite.addChild(boatImg);
    
    
    
    this.scaleX = scale;
    this.scaleY = scale;
    pivotX = boatImg.width/2;
    pivotY = boatImg.height/2;
    x = inX;
    y = inY;
    _goalX = x;
    _goalY = y;
    fishCount = 0;
    capacity = 1000;
    
    hitRecovery = false;
    
    myNet = new Net(_resourceManager, this);
    
  }
  
  void forward(num distance) {
    x += cos(rotation) * distance;
    y += sin(rotation) * distance;
  }
  
  void backward(num distance) {
    x -= cos(rotation) * distance;
    y -= sin(rotation) * distance;
  }
  
  bool advanceTime(num time){
    
    if(_dragging && !hitRecovery){
      for(Boat boat in _game.fleetA._boats){
        if(boat != this && collided(boat)){
          _dragging = false;
          rotation = -atan2((boat.y - y) , (boat.x - x));
          hitRecovery = true;
          backward(2*SPEED);
        }
      }
      for(Boat boat in _game.fleetB._boats){
        if(boat != this && collided(boat)){
          _dragging = false;
          backward(2*SPEED);
          hitRecovery = true;
        }
      }
    }
    
    if(_dragging && hitRecovery){
      new Timer(const Duration(seconds : 1), recoverFunc);
    }
    
    num oldRotation = rotation;
    if(_dragging && (_goalX != x || _goalY !=y)){
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

    myNet.skewX = 5*(oldRotation - rotation);
     
    
    if(fishCount < capacity){
      _game.ecosystem.catchCheck(this);
    }
    

    
    return true;
  }
  
  void recoverFunc(){
    hitRecovery = false;
  }
  
  bool collided(Boat boat){
    var dist = pow((boat.x - x), 2) + pow((boat.y - y), 2);
    var rad = boat.boatImg.height;
    if(dist < pow(rad, 2)){
      return true;
    }
    else{
      return false;
    }
  }
  
  bool containsTouch(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = x - boatImg.width/2*scale;
    num by = y - boatImg.height/2*scale;
    bool contain = (tx >= bx && ty >= by && tx <= bx + boatImg.width && ty <= by + boatImg.height);
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
  
  String boatString(num boatType, num fleetType){
    String name;
    String fleet;
    String type;
    if(fleetType == TEAMA) fleet = "A";
    if(fleetType == TEAMB) fleet = "B";
    
    if(boatType == SARDINE) type = "Sardine";
    if(boatType == TUNA) type = "Tuna";
    if(boatType == SHARK) type = "Shark";
        
    name = "boat${type}${fleet}";
    return name;
  }
  
  void collide(Boat boatHit){
    _dragging = false;
    rotation = -atan2((boatHit.y - y) , (boatHit.x - x));
    forward(SPEED/2);
  }
  
}



class Net extends stagexl.Sprite implements stagexl.Animatable{
  
  static const scale = 0.2;
  
  static const EMPTY = 0;
  static const SLIGHT = 1;
  static const HALF = 2;
  static const FULL = 3;
  
  num xAdjust;
  num yAdjust;
  
  stagexl.ResourceManager _resourceManager;
  
  Boat boat;
  stagexl.Sprite netSprite;
  stagexl.Bitmap netBitmapEmpty;
  stagexl.Bitmap netBitmapSlight;
  stagexl.Bitmap netBitmapHalf;
  stagexl.Bitmap netBitmapFull;
  
  int curNet;
  int oldNet;
  
  Net(this._resourceManager, Boat this.boat){
    
    netSprite = new stagexl.Sprite();
    netBitmapEmpty = new stagexl.Bitmap(_resourceManager.getBitmapData("netEmpty"));
    netBitmapSlight = new stagexl.Bitmap(_resourceManager.getBitmapData("netSlight"));
    netBitmapHalf = new stagexl.Bitmap(_resourceManager.getBitmapData("netHalf"));
    netBitmapFull = new stagexl.Bitmap(_resourceManager.getBitmapData("netFull"));
    
    addChild(netSprite);
    netSprite.addChild(netBitmapEmpty);
    
    netBitmapEmpty.scaleX = scale;
    netBitmapEmpty.scaleY = scale;
    
    netBitmapSlight.scaleX = scale;
    netBitmapSlight.scaleY = scale;
        
    netBitmapHalf.scaleX = scale;
    netBitmapHalf.scaleY = scale;
          
    netBitmapFull.scaleX = scale;
    netBitmapFull.scaleY = scale;
    
    yAdjust = boat.width-30;
    xAdjust = -height/2;
    
    curNet = EMPTY;

  }
  
  bool advanceTime(num time){
    
    this.rotation = boat.rotation+PI/2;  
    
    this.x = boat.x+xAdjust*cos(rotation) + yAdjust*cos(rotation+PI/2);
    this.y = boat.y+xAdjust*sin(rotation) + yAdjust*sin(rotation+PI/2);
   
    if(boat.fishCount <= 0){
      curNet = EMPTY;
    }
    else if(boat.fishCount >0 && boat.fishCount <= boat.capacity/2){
      curNet = SLIGHT;
    }
    else if(boat.fishCount > boat.capacity/2 && boat.fishCount < boat.capacity){
      curNet = HALF;
    }
    else{
      curNet = FULL;
    }
    
    
    if(curNet != oldNet){
      if(oldNet == EMPTY){
        netSprite.removeChild(netBitmapEmpty);
      }
      if(oldNet == SLIGHT){
        netSprite.removeChild(netBitmapSlight);
      }
      if(oldNet == HALF){
        netSprite.removeChild(netBitmapHalf);
      }
      if(oldNet == FULL){
        netSprite.removeChild(netBitmapFull);
      }
      
      
      if(curNet == EMPTY){
        netSprite.addChild(netBitmapEmpty);
      }
      if(curNet == SLIGHT){
        netSprite.addChild(netBitmapSlight);
      }
      if(curNet == HALF){
        netSprite.addChild(netBitmapHalf);
      }
      if(curNet == FULL){
        netSprite.addChild(netBitmapFull);
      }
      
    }

        
    return true;
  }
  
  
  
}