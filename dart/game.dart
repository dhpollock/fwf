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
  List<Boat> boats = new List<Boat>();
  
  var phase;
  var myButton = new Button();

   
  Game() {
    canvas = document.query("#game");
    ctx = canvas.getContext('2d');
    width = canvas.width;
    height = canvas.height;
    
    phase = 'BUY'; // PHASES CAN BE 'BUY', 'FISH', 'SELL', 'GROWTH'
    //canvas.onClick.listen((event)=>phase = 'FISH');
    myButton.initButton(transition);
    myButton.showButton("phaseButton", 50, 50);
    //myButton.onClick.listen((event)=>phase = 'FISH');
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    
    // create a few boats
    addBoat(new Boat(900, 600, 0));
    addBoat(new Boat(900, 700, 0));
    
    addBoat(new Boat(100, 600, 1));
    addBoat(new Boat(100, 700, 1));


    // redraw the canvas every 40 milliseconds
    new Timer.periodic(const Duration(milliseconds : 40), (timer) => animate());
  }
  

  
  void addBoat(Boat boat) {
    boats.add(boat);
    touchables.add(boat);
  }
  


/**
 * Animate all of the game objects 
 */
  void animate() {
    
    if(phase == 'FISH'){
      for (Boat boat in boats) {
        boat.animate();
      }
      
      draw();
    }
  }
  

/**
 * Draws programming blocks
 */
  void draw() {
    
    switch(phase){
      case 'BUY':
        ctx.clearRect(0, 0, width, height);
        ctx.fillStyle = 'black';
        //ctx.fillRect(0, 0, width, height);
        ctx.fillText("BUY STUFF: ", 100, 50);
        break;
      case 'FISH':
        // erase the screen
        ctx.clearRect(0, 0, width, height);
        
        // draw some text
        ctx.fillStyle = 'black';
        ctx.font = '30px sans-serif';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'center';
        ctx.fillText("Player 1: ", 100, 50);
        
        ctx.fillStyle = 'black';
        ctx.font = '30px sans-serif';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'center';
        ctx.fillText("Player 2: ", 700, 50);
        
        // draw the boats
        for (Boat boat in boats) {
          boat.draw(ctx);
        }
        break;
      case 'SELL':
        ctx.clearRect(0, 0, width, height);
        ctx.fillStyle = 'black';
        ctx.fillText("SELL STUFF: ", 100, 50);
        
        break;
      case 'REGROW':
        ctx.clearRect(0, 0, width, height);
        ctx.fillStyle = 'black';
        ctx.fillText("REGROW ALL THE FISHES ", 100, 50);
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