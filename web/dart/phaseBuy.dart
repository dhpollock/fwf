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
    
    teamACircle = new CornerBuyUI(_resourceManager, _game, TEAMA);
    teamBCircle = new CornerBuyUI(_resourceManager, _game, TEAMB);
        
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
    
  }
  
  void unDraw(){
    removeChild(background);
    teamACircle.unDraw();
    teamBCircle.unDraw();
    
    removeChild(teamACircle);
    removeChild(teamBCircle);
    
    _game.tlayer.touchables.remove(teamACircle);
    _game.tlayer.touchables.remove(teamBCircle);
    
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
  
  CornerBuyUI(this._resourceManager, this._game, this.teamType){
    
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
   
    speedUpgrade = new BuyItem(_resourceManager, this, SPEED_UPGRADE);
    capUpgrade = new BuyItem(_resourceManager, this, CAP_UPGRADE);
    sardineBoat = new BuyItem(_resourceManager, this, SARDINE_BOAT);
    tunaBoat = new BuyItem(_resourceManager, this, TUNA_BOAT);
    sharkBoat = new BuyItem(_resourceManager, this, SHARK_BOAT);
    
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

class BuyItem extends stagexl.Sprite implements Touchable{
  
  static const SPEED_UPGRADE = 0;
  static const CAP_UPGRADE = 1;
  static const SARDINE_BOAT = 2;
  static const TUNA_BOAT = 3;
  static const SHARK_BOAT = 4;
  
  static const iconRadius = 375;
  
  stagexl.ResourceManager _resourceManager;
  stagexl.Bitmap itemBitmap;
  CornerBuyUI myCorner;
  int itemType;
  
  num angle;
  num sign;
  
  BuyItem(this._resourceManager, this.myCorner, this.itemType){
    

    
    
    switch (itemType){
      case SPEED_UPGRADE:
        itemBitmap = new stagexl.Bitmap(_resourceManager.getBitmapData("speedUpgradeIcon"));
        
        angle = PI/6 + PI;
        sign = -1;

        break;
      case CAP_UPGRADE:
        itemBitmap = new stagexl.Bitmap(_resourceManager.getBitmapData("capUpgradeIcon"));
        
        angle = 2*PI/6 + PI;
        sign = -1;
        
        break;
      case SARDINE_BOAT:
        itemBitmap = new stagexl.Bitmap(_resourceManager.getBitmapData("sardineBoatIcon"));
        
        angle = PI/8;
        sign = 1;
        
        break;
      case TUNA_BOAT:
        itemBitmap = new stagexl.Bitmap(_resourceManager.getBitmapData("tunaBoatIcon"));
        
        angle = 2*PI/8;
        sign = 1;
        
        break;
      case SHARK_BOAT:
        itemBitmap = new stagexl.Bitmap(_resourceManager.getBitmapData("sharkBoatIcon"));
        
        angle = 3*PI/8;
        sign = 1;
        
        break;
      default:
        break;
    }
    
//    itemBitmap.pivotX = ;
//    itemBitmap.pivotY = ;
    
    itemBitmap.pivotX = myCorner.x + itemBitmap.width/2;
    itemBitmap.pivotY = myCorner.y + itemBitmap.height/2;

    
    itemBitmap.x = iconRadius * cos(angle);
    itemBitmap.y = iconRadius * sin(angle);
    
    
    addChild(itemBitmap);
    
}
  
  bool containsTouch(Contact c) {
    
    
    num curX = (itemBitmap.x) * cos(myCorner.uiSprite.rotation + PI/4) + (itemBitmap.y) * cos(myCorner.uiSprite.rotation + PI/4);
    num curY = (itemBitmap.x) * sin(myCorner.uiSprite.rotation + PI/4) + (itemBitmap.y) * sin(myCorner.uiSprite.rotation + PI/4);
    num dist = sqrt(pow((c.touchX - curX), 2) + pow((c.touchY - curY), 2));
//    
//    num dist = sqrt(pow((c.touchX - itemBitmap.parent.x), 2) + pow((c.touchY - itemBitmap.parent.y), 2));
    if(dist < itemBitmap.width/2){
      return true;
    }
    return false;
    
//    num tx = c.touchX;
//    num ty = c.touchY;
//    num bx = itemBitmap.pivotX + itemBitmap.x;
//    num by = itemBitmap.pivotY + itemBitmap.y;
//    bool contain = (tx >= bx && ty >= by && tx <= bx + itemBitmap.width && ty <= by + itemBitmap.height);
//    return contain;
  }
  
  bool touchDown(Contact c) {
    print("touched buy object ${itemType}");
    return true;
  }
  
  void touchUp(Contact c) {    }
  void touchSlide(Contact c) {  }
  void touchDrag(Contact c) {  }
}