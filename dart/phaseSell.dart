part of fwf;


class Sell extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  num sardinePrice = 10.0, tunaPrice = 10.0, sharkPrice = 10.0;
  
  num marketX = 0.0, marketY = 0.0, marketSpeed = 0.0, heading = 0.0;
  ImageElement marketImg = new ImageElement();
  
  TouchManager tmanager = new TouchManager();
  
  bool setupPhase = true;
  bool unloadPhase = false;
  bool firstInstructions = false;
  
  Sell(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
    
    marketImg.src = "images/market.png";
    marketX = 500;
    marketY = 1000;
    marketSpeed = 15.0;
    
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
  }
  
  
  void draw(CanvasRenderingContext2D ctx, num width, num height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.font = '30px sans-serif';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'center';
    ctx.fillText("SELL STUFF: ", 100, 50);

    ctx.save();
    {
    ctx.translate(marketX, marketY);
    ctx.drawImage(marketImg, -marketImg.width/2, -marketImg.height/2);
    }
    ctx.restore();
    
    fleetA.draw(ctx, width, height);
    fleetB.draw(ctx, width, height);
    
    
    ctx.translate(0, 0);



  }
  
  void animate(){
    if(firstInstructions){
      if(setupPhase){
        bool animA = fleetA.animateSellPhase();
        bool animB = fleetB.animateSellPhase();
        bool animM = animateMarket(500, 400);
        if(animA && animB && animM){
          setupPhase = false;
          unloadPhase = true;
        }
      }
      if(unloadPhase){
        bool animA = fleetA.animateSellPhaseUnload(sardinePrice, tunaPrice, sharkPrice);
        bool animB = fleetB.animateSellPhaseUnload(sardinePrice, tunaPrice, sharkPrice);
        if(animA && animB){
          unloadPhase = false;
          if(!game.debugTransition){
            game.transition();
          }
        }
      
      }
    }
  }
  
  void animateSell(){

  }
  
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
    marketY = 1000;
    setupPhase = true;
    unloadPhase = false;
  }
  
  bool animateMarket(num goToX, num goToY){
    var dist = sqrt(pow((goToX - marketX), 2) + pow((goToY - marketY), 2));
    heading = atan2((goToY - marketY), (goToX - marketX));
    if(dist > marketSpeed){
      marketForward(marketSpeed);
      return false;
    }
    else{
      marketForward(dist);
      return true;   
    }
    
  }
  
  void marketForward(num distance) {
    marketX += cos(heading) * distance;
    marketY += sin(heading) * distance;
  }
  
}