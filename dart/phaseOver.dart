part of fwf;


class GameOver extends TouchLayer{
  
  TouchManager tmanager = new TouchManager();
  GameOverTouch myGameOver = new GameOverTouch();
  
  Title(){
   
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.enable();
    
    touchables.add(myGameOver);
  }
  
  
  void draw(CanvasRenderingContext2D ctx,num width,num height){
    myGameOver.draw(ctx, width, height);
  }
  void animate(){
    
  }
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
}

class GameOverTouch implements Touchable{
  ImageElement img = new ImageElement();
  
  GameOverTouch(){
    img.src = "images/gameover.jpg";
  }
  
  void draw(CanvasRenderingContext2D ctx,num width,num height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.drawImage(img, 0, 0);
  }
  
  bool containsTouch(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = img.width;
    num by = img.height;
    return (tx >= 0 && ty >= 0 && tx <= bx && ty <= by);
  }
  
  
  bool touchDown(Contact c) {

    return true;
  }
  void touchUp(Contact c) {
    if(!game.debugTransition){
        game.transition();
    }
  }
  void touchDrag(Contact c) {  }
  void touchSlide(Contact c) { }  
}