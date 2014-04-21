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
  
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  var debugPhaseButton = new Button();
  
  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();
  
  stagexl.ResourceManager _resourceManager; 
  stagexl.Juggler _juggler;
  
  Fleet fleetA;
  Fleet fleetB;
  
  num roundNum = 0;

  AgentManager ecosystem;
  
  Fish fish;
  Regrow regrow;
  Buy buy;
  Title title;

  Random random = new Random();
  
  stagexl.Shape planktonGraph = new stagexl.Shape();
  stagexl.Shape sardineGraph = new stagexl.Shape();
  stagexl.Shape tunaGraph = new stagexl.Shape();
  stagexl.Shape sharkGraph = new stagexl.Shape();
  
  
  Game(this._resourceManager,this._juggler, this.width, this.height) {

    fleetA = new Fleet(_resourceManager, _juggler, this, 1, 1, 1,1000, TEAMA);
    fleetB = new Fleet(_resourceManager, _juggler, this, 1, 1, 1,1000, TEAMB);
    
    ecosystem = new AgentManager(_resourceManager, _juggler, 400, 200, 50, 5, width, height);
    
    phase = TITLE; // PHASES CAN BE 'BUY', 'FISH', 'SELL', 'GROWTH'
    
    if(debugTransition){
      debugPhaseButton.initButton(transition);
      debugPhaseButton.showButton("phaseButton", 500, 500);
    }
    fish = new Fish(_resourceManager, _juggler, this);
    regrow = new Regrow(_resourceManager, _juggler, this);
    buy = new Buy(_resourceManager, _juggler, this);

    title = new Title(_resourceManager, tmanager);


    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(tlayer);
    
    addChild(title);
    tlayer.touchables.add(title);
    title.draw();
    
    
    planktonGraph.graphics.rect(0, 0, 100, 10);
    planktonGraph.x = width/2;
    planktonGraph.y = height-110;
    planktonGraph.graphics.fillColor(stagexl.Color.Black);
    addChild(planktonGraph);
    
    sardineGraph.graphics.rect(0, 0, 100, 10);
    sardineGraph.x = width/2;
    sardineGraph.y = height-100;
    sardineGraph.graphics.fillColor(stagexl.Color.Green);
    addChild(sardineGraph);
    
    tunaGraph.graphics.rect(0, 0, 100, 10);
    tunaGraph.x = width/2;
    tunaGraph.y = height-90;
    tunaGraph.graphics.fillColor(stagexl.Color.Red);
    addChild(tunaGraph);
    
    sharkGraph.graphics.rect(0, 0, 100, 10);
    sharkGraph.x = width/2;
    sharkGraph.y = height-80;
    sharkGraph.graphics.fillColor(stagexl.Color.Blue);
    addChild(sharkGraph);
    
  }
  
  void timer(var input) {
    return input();
  }
  
  
  bool advanceTime(num time) {
    planktonGraph.width = ecosystem.fishCount[0];
    sardineGraph.width = ecosystem.fishCount[1]; 
    tunaGraph.width = ecosystem.fishCount[2]; 
    sharkGraph.width = ecosystem.fishCount[3]; 
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
        tlayer.touchables.remove(title);
        
        

        fish.draw();
        addChild(fish);
        
        
        addChild(ecosystem);
        _juggler.add(ecosystem);
        
        fleetA.enableFishing();
        fleetB.enableFishing();

        addChild(fleetA);
        addChild(fleetB);

        addChild(planktonGraph);
        addChild(sardineGraph);
        addChild(tunaGraph);
        addChild(sharkGraph);
        
        
        
        break;
      case FISHING:
        phase = REGROWTH;
        
        fish.unDraw();
        removeChild(fish);
        
        
        removeChild(ecosystem);
        fleetA.disableFishing();
        fleetB.disableFishing();
        removeChild(fleetA);
        removeChild(fleetB);
        
        
        addChild(regrow);
        regrow.draw();
        
        addChild(ecosystem);
        
        break;
        
      case REGROWTH:
        phase = BUY;

        regrow.unDraw();
        removeChild(regrow);
        
        
        removeChild(ecosystem);
        _juggler.remove(ecosystem);
        
        removeChild(planktonGraph);
        removeChild(sardineGraph);
        removeChild(tunaGraph);
        removeChild(sharkGraph);
        
        buy.draw();
        addChild(buy);
        
        
        addChild(fleetA);
        addChild(fleetB);
        
      break;
      
      case BUY:
        phase = FISHING;
        buy.unDraw();
        removeChild(buy);
        
        
        removeChild(fleetA);
        removeChild(fleetB);
        
        fish.draw();
        addChild(fish);
        
        
        addChild(ecosystem);
        _juggler.add(ecosystem);

        addChild(fleetA);
        addChild(fleetB);

        addChild(planktonGraph);
        addChild(sardineGraph);
        addChild(tunaGraph);
        addChild(sharkGraph);
        
    }
    

    
  }
  

}

