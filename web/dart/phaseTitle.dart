part of fwf;


class Title extends stagexl.Sprite implements Touchable{
  
  TouchManager tmanager;
  stagexl.ResourceManager _resourceManager;
  stagexl.Bitmap title;
  
  Title(stagexl.ResourceManager this._resourceManager, TouchManager this.tmanager){
   
    title = new stagexl.Bitmap(_resourceManager.getBitmapData("title"));
  }
  
  
  void draw(){
    addChild(title);
  }
  void animate(){
    
  }
  
  void show(){
    tmanager.enable();
  }
  
  void hide(){
    tmanager.disable();
  }
  bool containsTouch(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = title.width;
    num by = title.height;
    return (tx >= 0 && ty >= 0 && tx <= bx && ty <= by);
  }
  
  
  bool touchDown(Contact c) {

    return true;
  }
  void touchUp(Contact c) {
        game.transition();
  }
  void touchDrag(Contact c) {  }
  void touchSlide(Contact c) { }  
}
