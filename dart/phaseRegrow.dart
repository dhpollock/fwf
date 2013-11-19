part of fwf;


class Regrow{
  Fleet fleetA;
  Fleet fleetB;
  
  Regrow(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.fillText("REGROW ALL THE FISHES ", 100, 50);
  }
}