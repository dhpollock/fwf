part of fwf;


class Title extends TouchLayer{
  
  TouchManager tmanager = new TouchManager();
  IntroTouch myIntro = new IntroTouch();
  
  Title(){
   
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.enable();
    
    touchables.add(myIntro);
  }
  
  
  void draw(CanvasRenderingContext2D ctx,num width,num height){
    myIntro.draw(ctx, width, height);
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

class IntroTouch implements Touchable{
  ImageElement img = new ImageElement();
  
  IntroTouch(){
    img.src = "images/title.png";
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