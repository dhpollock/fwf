part of fwf;


class Sell{
  Fleet fleetA;
  Fleet fleetB;
  
  Sell(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.fillText("SELL STUFF: ", 100, 50);
    fleetA.hide();
    fleetB.hide();
  }
}