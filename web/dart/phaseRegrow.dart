part of fwf;

class Regrow extends stagexl.Sprite implements stagexl.Animatable{
  
  TouchManager tmanager;
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  stagexl.Bitmap background;
  
  Game _game;
  Boat testBoat;
  
  Fleet fleetA;
  Fleet fleetB;
  
  Regrow(stagexl.ResourceManager this._resourceManager,stagexl.Juggler this._juggler, Game this._game){
    background = new stagexl.Bitmap(_resourceManager.getBitmapData("background"));
    fleetA = _game.fleetA;
    fleetB = _game.fleetB;
  }
  
  bool advanceTime(num time){
    
    return true;
  }

  void draw(){
    addChild(background);
    _game.ecosystem.updateSpeed(1.5);
  }
  
  void unDraw(){
    removeChild(background);
  }
  
  
}