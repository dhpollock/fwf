/*
 * Dart Game Sample Code
 */
part of fwf;


//class Game extends TouchLayer {
class Game extends stagexl.Sprite implements stagexl.Animatable{
  
  //turn off annoying transitions 0 = on; 1 = off
  bool debugTransition = true;
   
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
  var debugPhaseButton = new Button();
  var intro = new Instruction();
  var finish = new finishButton();
  Fleet fleetA;
  Fleet fleetB;
  
  TouchManager tmanager = new TouchManager();
  stagexl.ResourceManager _resourceManager; 
  
  num roundNum = 0;
  //declaring phase objects 
  Buy buy;
  Fish fish;
//  Sell sell;
  Regrow regrow;
  Title title;
  GameOver gameOver;
  
  AgentManager ecosystem;
  
  Game(stagexl.ResourceManager this._resourceManager) {
    stagexl.Bitmap background = new stagexl.Bitmap(_resourceManager.getBitmapData("background"));
    addChild(background);
    //canvas = document.querySelector("#game");
    //ctx = canvas.getContext('2d');
   // width = canvas.width;
    //height = canvas.height;
    
    phase = 'TITLE'; // PHASES CAN BE 'BUY', 'FISH', 'SELL', 'GROWTH'
    
    if(debugTransition){
      debugPhaseButton.initButton(transition);
      debugPhaseButton.showButton("phaseButton", 500, 500);
    }
    else{
      intro.initInstructions();
      finish.initfinishButton(transition);
    }
    
    // create a few boats
    
    fleetA = new Fleet(1, 0, 0, 1000, 'A');
    fleetB = new Fleet(1, 0, 0, 1000, 'B');
    
    //intializing each phase 
    ecosystem = new AgentManager(200, 80, 40, 20, width, height);

    buy = new Buy(fleetA, fleetB);
    fish = new Fish(fleetA, fleetB, ecosystem);
    regrow = new Regrow(fleetA, fleetB, ecosystem);
    title = new Title();
    gameOver = new GameOver();

    // redraw the canvas every 40 milliseconds runs animate function every 40 milliseconds 
    new Timer.periodic(const Duration(milliseconds : 40), (timer) => animate());
  }
  
  void timer(var input) {
    return input();
  }
  

/**
 * Animate all of the game objects makes things movie without an event 
 */
  void animate() {
    switch(phase){
      case 'TITLE':
        draw();
        break;
      case 'BUY':
        buy.animate();
        fleetA.animate();
        fleetB.animate();
        draw();
        break;
      case 'FISH':
        fish.animate();
        fleetA.animate();
        fleetB.animate();
        draw();
        break;
      case 'REGROW':
        regrow.animate();
        draw();
        break;
      case 'GAMEOVER':
        draw();
        break;
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
        drawEcosystemStatus();
        break;
      case 'FISH':
        fish.draw(ctx, width, height);
        drawEcosystemStatus();
        break;
      case 'REGROW':
        regrow.draw(ctx, width, height);
        drawEcosystemStatus();
        //ecosystem.draw(ctx);
        break;
      case 'GAMEOVER':
        gameOver.draw(ctx,width, height);
        break;
      default:
       break;       
    }
  }
  
  //keep track of how many phases encountered 
  var phasenum = 0;
  //function that allows transition between phases 
  void transition() {
    switch(phase){
      case 'TITLE':
        phase = 'FISH';
        phasenum++;
        
        fleetA.harborArrage();
        fleetB.harborArrage();
          
        fleetA.show();
        fleetB.show();
          
        //enable/disable touch manager for the phase
        title.hide();
        buy.hide();
        fish.show();
        regrow.hide();
        
        ecosystem.updateSpeed(.5);
        if (phasenum == 1 && !debugTransition){
          intro.showInstructions("instructionFish", 130, 130);
          //hide fleets to prevent clicking, after click in instruction class fleets are touchable
          fleetA.hide();
          fleetB.hide();
          repaint();
        }
        if (!debugTransition && phasenum > 4){
          transitionActions();
        }
        repaint();
        print(phase);
        print(phasenum);
        break;
      case 'BUY':
        phase = 'FISH';
        phasenum++;
        
        fleetA.harborArrage();
        fleetB.harborArrage();
          
        fleetA.show();
        fleetB.show();
          
        //enable/disable touch manager for the phase 
        buy.hide();
        fish.show();
        regrow.hide();
        
        ecosystem.updateSpeed(.5);
        if (!debugTransition && phasenum > 3){
          transitionActions();
        }
        repaint();
        print(phase);
        print(phasenum);
        break;

      case 'FISH':
          phase = 'REGROW';
          phasenum++; 
          fleetA.harborArrage();
          fleetB.harborArrage();
          
          fleetA.hide();
          fleetB.hide();
          
          //enable/disable touch manager for the phase 
          buy.hide();
          fish.hide();
          regrow.show();
          ecosystem.updateSpeed(5);
  
          repaint();
          print(phase);
  
          if (phasenum == 2 && !debugTransition){
            intro.showInstructions("instructionRegrow", 130, 130);
            fleetA.hide();
            fleetB.hide();
            }
          print(phasenum);
          if (!debugTransition && phasenum>2){
            transitionActions();
          }
        break;
        case 'REGROW':
          if(ecosystem.returnCount('sardine') <= 0 || ecosystem.returnCount('tuna') <= 0 || ecosystem.returnCount('shark') <= 0 || roundNum > 7){
            phase = 'GAMEOVER';
          }
          else{
          phase = 'BUY';
          phasenum++; 
          
          fleetA.show();
          fleetB.show();
          
          //enable/disable touch manager for the phase 
          buy.show();
          fish.hide();
//          sell.hide();
          regrow.hide();
          if (phasenum == 3 && !debugTransition){
            intro.showInstructions("instructionBuy", 130, 130);
            //hide fleets to prevent clicking, after click in instruction class fleets are touchable
            fleetA.hide();
            fleetB.hide();
            repaint();
          }
          repaint();
          if (!debugTransition && phasenum >4){
            transitionActions();
          }
          print(phase);
  
          print(phasenum);
          }
          roundNum ++;
        break;
        
    }
  }
  
  void transitionActions(){
    switch(phase){
      case "BUY":
        //print("hello");
        new Timer(const Duration(seconds : 3), () {
          finish.showfinishButton("finishButton1", 10, 780);
          finish.showfinishButton("finishButton2", 650, 780);
        });
        fleetA.show();
        fleetB.show();
        break;
      case "FISH":
        fish.startTimer();
        fleetA.show();
        fleetB.show();
        break;
      case "REGROW":
        regrow.startTimer();
        break;
    }
  }
  
  void drawEcosystemStatus(){
    num boxX = width - 150;
    num boxY = height - 85;
    
    ctx.fillStyle = 'grey';
    ctx.fillRect(boxX, boxY, 25, 75);
    ctx.fillStyle = 'white';
    ctx.font = '15px sans-serif';
    ctx.textAlign = 'right';
    ctx.textBaseline = 'center';
    ctx.fillText("Sa: ", boxX+28, boxY+15);
    ctx.fillText("T: ", boxX+28, boxY+40);
    ctx.fillText("Sh: ", boxX+28, boxY+65);
    //buy box?
    ctx.fillStyle = 'green';
    ctx.fillRect(boxX+25, boxY, ecosystem.returnCount('sardine'), 25);
    ctx.fillStyle = 'red';
    ctx.fillRect(boxX+25, boxY + 25, ecosystem.returnCount('tuna'), 25);
    ctx.fillStyle = 'blue';
    ctx.fillRect(boxX+25, boxY + 50, ecosystem.returnCount('shark'), 25);
    
  }

}

