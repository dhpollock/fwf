part of fwf;

class Fish extends stagexl.Sprite{
  
  TouchManager tmanager;
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  stagexl.Bitmap background;
  
  Game _game;
  Boat testBoat;
  
  Fish(stagexl.ResourceManager this._resourceManager,stagexl.Juggler this._juggler, Game this._game){
    background = new stagexl.Bitmap(_resourceManager.getBitmapData("background"));
    
    testBoat = new Boat(_resourceManager, _juggler, 500, 500, 0 ,0);
    
  }

  void draw(){
    
    addChild(background);
    addChild(testBoat);
    _game.tlayer.touchables.add(testBoat);
  }
}