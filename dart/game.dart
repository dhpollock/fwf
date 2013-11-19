/*
 * Dart Game Sample Code
 */
part of fwf;


class Game extends TouchLayer {
   
  // this is the HTML canvas element
  CanvasElement canvas;
  
  // this object is what you use to draw on the canvas
  CanvasRenderingContext2D ctx;

  // this is for multi-touch or mouse event handling  
  TouchManager tmanager = new TouchManager();

  // width and height of the canvas
  int width, height;
  
  // list of the boats that people can touch
  List<Fleet> fleets = new List<Fleet>();
  var phase;
  var myButton = new Button();
  Fleet fleetA;
  Fleet fleetB;
  
  Buy buy;
  Fish fish;
  Sell sell;
  Regrow regrow;
   
  Game() {
    canvas = document.query("#game");
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    
    phase = 'BUY'; // PHASES CAN BE 'BUY', 'FISH', 'SELL', 'GROWTH'
    
    myButton.initButton(transition);
    myButton.showButton("phaseButton", 50, 50);
    
//    tmanager.registerEvents(document.documentElement);
//    tmanager.addTouchLayer(this);
    
    // create a few boats
    
    fleetA = new Fleet(1, 0, 0, 100, 'A');
    fleetB = new Fleet(1, 0, 0, 100, 'B');
    
    
    buy = new Buy(fleetA, fleetB);
    fish = new Fish(fleetA, fleetB);
    sell = new Sell(fleetA, fleetB);
    regrow = new Regrow(fleetA, fleetB);

    // redraw the canvas every 40 milliseconds
    new Timer.periodic(const Duration(milliseconds : 40), (timer) => animate());
  }
  

  


/**
 * Animate all of the game objects 
 */
  void animate() {
    
    if(phase == 'FISH'){
      fleetA.animate();
      fleetB.animate();
      draw();
    }
  }
  

/**
 * Draws programming blocks
 */
  void draw() {
    
    switch(phase){
      case 'BUY':
        buy.draw(ctx, width, height);
        break;
      case 'FISH':
        // erase the screen
        fish.draw(ctx, width, height);
        break;
      case 'SELL':
        sell.draw(ctx, width, height);
        break;
      case 'REGROW':
        regrow.draw(ctx, width, height);
        break;
      default:
       break;       
    }
  }

  void transition() {
    switch(phase){
      case 'BUY':
        phase = 'FISH';
        repaint();
        print(phase);
        break;
      case 'FISH':
        phase = 'SELL';
        repaint();
        print(phase);
        break;
      case 'SELL':
        phase = 'REGROW';
        repaint();
        print(phase);
        break;
      case 'REGROW':
        phase = 'BUY';
        repaint();
        print(phase);
        break;
    }
  }
}