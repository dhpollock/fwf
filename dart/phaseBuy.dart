part of fwf;


class Buy{
  Fleet fleetA;
  Fleet fleetB;
  
  Buy(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    //ctx.fillRect(0, 0, width, height);
    ctx.fillText("BUY STUFF: ", 100, 50);
  }
}