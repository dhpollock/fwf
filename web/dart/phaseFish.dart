part of fwf;

class Fish extends stagexl.Sprite{
  
  TouchManager tmanager;
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  stagexl.Bitmap background;
  
  Game _game;
  Boat testBoat;
  
  Fleet fleetA;
  Fleet fleetB;
  
  Fish(stagexl.ResourceManager this._resourceManager,stagexl.Juggler this._juggler, Game this._game){
    background = new stagexl.Bitmap(_resourceManager.getBitmapData("background"));
    fleetA = _game.fleetA;
    fleetB = _game.fleetB;
  }

  void draw(){
    
    fleetA.enableFishing();
    fleetB.enableFishing();
    _game.ecosystem.updateSpeed(2);
 
    addChild(background);
    addChild(_game.ecosystem);
    _juggler.add(_game.ecosystem);
    addChild(fleetA);
    addChild(fleetB);
  }
}