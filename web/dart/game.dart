/*
 * Dart Game Sample Code
 */
part of fwf;


//class Game extends TouchLayer {
class Game extends stagexl.Sprite implements stagexl.Animatable{
  
  //turn off annoying transitions 0 = on; 1 = off
  bool debugTransition = true;


  // width and height of the canvas
  int width, height;
  
  // list of the boats that people can touch
//  List<Fleet> fleets = new List<Fleet>();
  int phase;
  static const TITLE = 0;
  static const FISHING = 1;
  static const REGROWTH = 2;
  static const BUY = 3;
  static const GAMEOVER = 4;
  static const TRANSITION = 5;
  
  var debugPhaseButton = new Button();
  
  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();
  
  stagexl.ResourceManager _resourceManager; 
  stagexl.Juggler _juggler;
  
  num roundNum = 0;

  Fish fish;
  Title title;

  
  Game(stagexl.ResourceManager this._resourceManager, this.width, this.height) {

    
    phase = TITLE; // PHASES CAN BE 'BUY', 'FISH', 'SELL', 'GROWTH'
    
    if(debugTransition){
      debugPhaseButton.initButton(transition);
      debugPhaseButton.showButton("phaseButton", 500, 500);
    }
    fish = new Fish(_resourceManager, _juggler, this);

    title = new Title(_resourceManager, tmanager);

    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(tlayer);
    
    addChild(title);
    tlayer.touchables.add(title);
    title.draw();
  }
  
  void timer(var input) {
    return input();
  }
  
  
  bool advanceTime(num time) {
    return true;
  }

/**
 * Animate all of the game objects makes things movie without an event 
 */
  void animate() {

  }
  
  var phasenum = 0;
  
  //function that allows transition between phases 
  void transition() {
    switch(phase){
      case TITLE:
        phase = FISHING;

//        //enable/disable touch manager for the phase
        removeChild(title);
        addChild(fish);
        fish.draw();
        
        break;

    }
  }
  

}

