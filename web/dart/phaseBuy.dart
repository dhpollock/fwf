part of fwf;

class Buy extends stagexl.Sprite implements stagexl.Animatable{
  
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  TouchManager tmanager;
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  stagexl.Bitmap background;
  
  Game _game;
  Boat testBoat;
  
  Fleet fleetA;
  Fleet fleetB;
  
  CornerBuyUI teamACircle;
  CornerBuyUI teamBCircle;
  
  Buy(this._resourceManager,stagexl.Juggler this._juggler, Game this._game){
    background = new stagexl.Bitmap(_resourceManager.getBitmapData("buyCenterDock"));
    fleetA = _game.fleetA;
    fleetB = _game.fleetB;
    
    background.x = _game.width/2 - background.width/2;
    background.y = _game.height/2 - background.height/2;
    
    teamACircle = new CornerBuyUI(_resourceManager, _juggler, _game, TEAMA);
    teamBCircle = new CornerBuyUI(_resourceManager, _juggler, _game, TEAMB);
        
  }
  
  bool advanceTime(num time){
    
    return true;
  }

  void draw(){
    
    addChild(background);
    
    fleetA.harborArrange();
    fleetB.harborArrange();
    
    addChild(teamACircle);
    addChild(teamBCircle);
    teamACircle.draw();
    teamBCircle.draw();
    
    _game.tlayer.touchables.add(teamACircle);
    _game.tlayer.touchables.add(teamBCircle);
    
    for(Boat boat in game.fleetA._boats){
      boat.removeNet();
    }
    for(Boat boat in game.fleetB._boats){
      boat.removeNet();
    }
    
  }
  
  void unDraw(){
    removeChild(background);
    teamACircle.unDraw();
    teamBCircle.unDraw();
    
    removeChild(teamACircle);
    removeChild(teamBCircle);
    
    _game.tlayer.touchables.remove(teamACircle);
    _game.tlayer.touchables.remove(teamBCircle);
    
    for(Boat boat in game.fleetA._boats){
      boat.addNet();
    }
    for(Boat boat in game.fleetB._boats){
      boat.addNet();
    }
    
  }
  
  
}

class CornerBuyUI extends stagexl.Sprite implements stagexl.Animatable, Touchable{
  
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  stagexl.ResourceManager _resourceManager;
  Game _game;
  
  
  stagexl.Bitmap teamCircle;
  stagexl.Bitmap circleButton;
  stagexl.Sprite uiSprite;
  
  int teamType;
  
  static const SPEED_UPGRADE = 0;
  static const CAP_UPGRADE = 1;
  static const SARDINE_BOAT = 2;
  static const TUNA_BOAT = 3;
  static const SHARK_BOAT = 4;
  
  BuyItem speedUpgrade;
  BuyItem capUpgrade;
  BuyItem sardineBoat;
  BuyItem tunaBoat;
  BuyItem sharkBoat;
  
  stagexl.Juggler _juggler;
  
  CornerBuyUI(this._resourceManager, this._juggler, this._game, this.teamType){
    
    uiSprite = new stagexl.Sprite();
    addChild(uiSprite);

    if(teamType == TEAMA){
      teamCircle = new stagexl.Bitmap(_resourceManager.getBitmapData("teamACircle"));
      circleButton = new stagexl.Bitmap(_resourceManager.getBitmapData("circleUIButton"));
      uiSprite.x = 100;
      uiSprite.y = 100;
    }
    else if(teamType == TEAMB){
      uiSprite.rotation = PI;
      teamCircle = new stagexl.Bitmap(_resourceManager.getBitmapData("teamBCircle"));
      circleButton = new stagexl.Bitmap(_resourceManager.getBitmapData("circleUIButton"));
      uiSprite.x = _game.width - 100;
      uiSprite.y = _game.height - 100;

      
 
    }

    teamCircle.pivotX =teamCircle.width/2;
    teamCircle.pivotY =teamCircle.height/2;
    
    circleButton.pivotX = circleButton.width/2;
    circleButton.pivotY = circleButton.height/2;
   
    speedUpgrade = new BuyItem(_resourceManager, _juggler, this, SPEED_UPGRADE);
    capUpgrade = new BuyItem(_resourceManager, _juggler, this, CAP_UPGRADE);
    sardineBoat = new BuyItem(_resourceManager, _juggler, this, SARDINE_BOAT);
    tunaBoat = new BuyItem(_resourceManager, _juggler, this, TUNA_BOAT);
    sharkBoat = new BuyItem(_resourceManager, _juggler, this, SHARK_BOAT);
    
//    uiSprite.addChild(teamCircle);
//    uiSprite.addChild(circleButton);
    
    uiSprite.addChild(speedUpgrade);
    uiSprite.addChild(capUpgrade);
    uiSprite.addChild(sardineBoat);
    uiSprite.addChild(tunaBoat);
    uiSprite.addChild(sharkBoat);
    
    _game.tlayer.touchables.add(speedUpgrade);
    _game.tlayer.touchables.add(capUpgrade);
    _game.tlayer.touchables.add(sardineBoat);
    _game.tlayer.touchables.add(tunaBoat);
    _game.tlayer.touchables.add(sharkBoat);

  }
  
  void draw(){
    uiSprite.addChild(teamCircle);
    uiSprite.addChild(circleButton);
  }
  
  void unDraw(){
    if(teamCircle.parent != null){
    teamCircle.parent.removeChild(teamCircle);
    }
    if(circleButton.parent != null){
      circleButton.parent.removeChild(circleButton);
    }
  }
  
  bool advanceTime(num time){
    return true;
  }
  
  bool containsTouch(Contact c) {
    num dist = sqrt(pow((c.touchX - uiSprite.x), 2) + pow((c.touchY - uiSprite.y), 2));
    if(dist < circleButton.width/2){
      return true;
    }
    return false;
  }
  
  bool touchDown(Contact c) {
    circleButton.bitmapData = (_resourceManager.getBitmapData("circleUIButtonDown"));
    
    return true;
  }
  
  void touchUp(Contact c) {
    circleButton.bitmapData = (_resourceManager.getBitmapData("circleUIButton"));
    stagexl.Tween rotateCircle = new stagexl.Tween(uiSprite, .5, stagexl.TransitionFunction.easeInOutElastic);
    rotateCircle.animate.rotation.by(PI);

    _game._juggler.add(rotateCircle);
  }
  void touchSlide(Contact c) {  }
  void touchDrag(Contact c) {  }
  
  
}

class BuyItem extends stagexl.Sprite implements Touchable, stagexl.Animatable{
  
  static const SPEED_UPGRADE = 0;
  static const CAP_UPGRADE = 1;
  static const SARDINE_BOAT = 2;
  static const TUNA_BOAT = 3;
  static const SHARK_BOAT = 4;
  
  static const iconRadius = 375;
  
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  stagexl.Bitmap itemBitmap;
  stagexl.BitmapData itemBitmapData;
  CornerBuyUI myCorner;
  int itemType;
  
  stagexl.Sprite grabbedIcon;
  stagexl.Bitmap grabbedIconBitmap;
    
  num angle;
  num sign;
  
  BuyItem(this._resourceManager, this._juggler, this.myCorner, this.itemType){
        
    switch (itemType){
      case SPEED_UPGRADE:
        itemBitmapData = _resourceManager.getBitmapData("speedUpgradeIcon");
        angle = PI/6 + PI;
        break;
      case CAP_UPGRADE:
        itemBitmapData = _resourceManager.getBitmapData("capUpgradeIcon");
        angle = 2*PI/6 + PI;
        break;
      case SARDINE_BOAT:
        itemBitmapData = _resourceManager.getBitmapData("sardineBoatIcon");
        angle = PI/8;
        break;
      case TUNA_BOAT:
        itemBitmapData = _resourceManager.getBitmapData("tunaBoatIcon");
        angle = 2*PI/8;
        break;
      case SHARK_BOAT:
        itemBitmapData = _resourceManager.getBitmapData("sharkBoatIcon"); 
        angle = 3*PI/8;
        break;
      default:
        break;
    }
    
    itemBitmap = new stagexl.Bitmap(itemBitmapData);
//    itemBitmap.pivotX = ;
//    itemBitmap.pivotY = ;
    
    itemBitmap.pivotX = myCorner.x + itemBitmap.width/2;
    itemBitmap.pivotY = myCorner.y + itemBitmap.height/2;

    
    itemBitmap.x = iconRadius * cos(angle);
    itemBitmap.y = iconRadius * sin(angle);
    
    
    addChild(itemBitmap);
    
}
  
  bool advanceTime(num time){
    return true;
  }
  
  bool containsTouch(Contact c) {
    
    if(itemBitmap.mouseX < itemBitmap.width && itemBitmap.mouseX > 0 && itemBitmap.mouseY < itemBitmap.height && itemBitmap.mouseY > 0){
      return true;
    }
    return false;
  }
  
  bool touchDown(Contact c) {
    print("touched buy object ${itemType}");
    
    grabbedIcon = new stagexl.Sprite();
    grabbedIconBitmap = new stagexl.Bitmap(itemBitmapData);
    grabbedIcon.addChild(grabbedIconBitmap);

    grabbedIconBitmap.pivotX = grabbedIconBitmap.width/2;
    grabbedIconBitmap.pivotY = grabbedIconBitmap.height/2;
        

    grabbedIcon.x = c.touchX - grabbedIconBitmap.width + this.parent.x;
    grabbedIcon.y = c.touchY - grabbedIconBitmap.height+ this.parent.y;

    addChild(grabbedIcon);
    
    return true;
  }
  
  void touchUp(Contact c) {
    if(false){
      
    }
    else{
      stagexl.Tween returnIcon = new stagexl.Tween(grabbedIcon, .5, stagexl.TransitionFunction.easeInOutQuadratic);
      returnIcon.animate.x.to(itemBitmap.x);
      returnIcon.animate.y.to(itemBitmap.y);
      _juggler.add(returnIcon);
      returnIcon.onComplete = () =>animationCleanUp();
    }
    
  }
  
  void animationCleanUp(){
//    removeChild(grabbedIcon);
//    grabbedIcon.removeChild(grabbedIconBitmap);
    grabbedIcon = null;
    
  }
  
  void touchSlide(Contact c) {  }
  void touchDrag(Contact c) {
    grabbedIcon.x = c.touchX - grabbedIconBitmap.width;
    grabbedIcon.y = c.touchY - grabbedIconBitmap.height;
  }
}