/*
 * Dart Game Sample Code
 */
part of fwf;


//class Game extends TouchLayer {
class Game {
   
  // this is the HTML canvas element
  CanvasElement canvas;
  
  // this object is what you use to draw on the canvas
  CanvasRenderingContext2D ctx;

  // this is for multi-touch or mouse event handling  
  //TouchManager tmanager = new TouchManager();

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
  Title title;
   
  Game() {
    canvas = document.query("#game");
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    
    phase = 'TITLE'; // PHASES CAN BE 'BUY', 'FISH', 'SELL', 'GROWTH'
    
    myButton.initButton(transition);
    myButton.showButton("phaseButton", 50, 50);
    
//    tmanager.registerEvents(document.documentElement);
//    tmanager.addTouchLayer(this);
    
    // create a few boats
    
    fleetA = new Fleet(1, 1, 1, 3000, 'A');
    fleetB = new Fleet(1, 1, 1, 100, 'B');
    
    
    buy = new Buy(fleetA, fleetB);
    fish = new Fish(fleetA, fleetB);
    sell = new Sell(fleetA, fleetB);
    regrow = new Regrow(fleetA, fleetB);
    title = new Title();

    // redraw the canvas every 40 milliseconds
    new Timer.periodic(const Duration(milliseconds : 40), (timer) => animate());
  }
  

  


/**
 * Animate all of the game objects 
 */
  void animate() {
    if(phase == 'TITLE'){
      draw();
    }
    if(phase == 'FISH'){
      fleetA.animate();
      fleetB.animate();
      draw();
    }
    if(phase == 'BUY'){
      //fleetA.animate();
      buy.animate();
      draw();
    }
  }
  

/**
 * Draws programming blocks
 */
  void draw() {
    
    switch(phase){
      case 'TITLE':
        title.draw(ctx, width, height);
        break;
      case 'BUY':
        buy.draw(ctx, width, height);
        break;
      case 'FISH':
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
      case 'TITLE':
        phase = 'BUY';

        fleetA.harborArrage();
        fleetB.harborArrage();
        
        fleetA.show();
        fleetB.show();
        
        buy.show();
        fish.hide();
        sell.hide();
        regrow.hide();
        
        repaint();
        print(phase);
        break;
      case 'BUY':
        phase = 'FISH';

        fleetA.harborArrage();
        fleetB.harborArrage();
        
        fleetA.show();
        fleetB.show();
        
        buy.hide();
        fish.show();
        sell.hide();
        regrow.hide();
        
        repaint();
        print(phase);
        break;
      case 'FISH':
        phase = 'SELL';
        fleetA.hide();
        fleetB.hide();
        
        buy.hide();
        fish.hide();
        sell.show();
        regrow.hide();
        
        repaint();
        print(phase);
        break;
      case 'SELL':
        phase = 'REGROW';
        
        fleetA.harborArrage();
        fleetB.harborArrage();
        
        fleetA.hide();
        fleetB.hide();
        
        buy.hide();
        fish.hide();
        sell.hide();
        regrow.show();

        repaint();
        print(phase);
        break;
      case 'REGROW':
        phase = 'BUY';
        
        fleetA.hide();
        fleetB.hide();
        
        buy.show();
        fish.hide();
        sell.hide();
        regrow.hide();

        repaint();
        print(phase);
        break;
    }
  }
}