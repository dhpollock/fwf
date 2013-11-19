part of fwf;


class Fish{
  Fleet fleetA;
  Fleet fleetB;
  
  Fish(Fleet A, Fleet B){
    fleetA = A;
    fleetB = B;
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
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
    fleetA.draw(ctx, height, width);
    fleetB.draw(ctx, height, width);
  }
}