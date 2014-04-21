part of fwf;

class Buy extends stagexl.Sprite implements stagexl.Animatable{
  
  TouchManager tmanager;
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  stagexl.Bitmap background;
  
  Game _game;
  Boat testBoat;
  
  Fleet fleetA;
  Fleet fleetB;
  
  Buy(stagexl.ResourceManager this._resourceManager,stagexl.Juggler this._juggler, Game this._game){
    background = new stagexl.Bitmap(_resourceManager.getBitmapData("buyCenterDock"));
    fleetA = _game.fleetA;
    fleetB = _game.fleetB;
    
    background.x = _game.width/2 - background.width/2;
    background.y = _game.height/2 - background.height/2;
        
  }
  
  bool advanceTime(num time){
    
    return true;
  }

  void draw(){
    
    addChild(background);
    
    fleetA.harborArrange();
    fleetB.harborArrange();
  }
  
  void unDraw(){
    removeChild(background);
  }
  
  
}