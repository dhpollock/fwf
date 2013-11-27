part of fwf;


class Title extends TouchLayer{
  
  ImageElement img = new ImageElement();
  
  TouchManager tmanager = new TouchManager();
  
  Title(){
    img.src = "images/title.png";
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.enable();
  }
  
  
  void draw(CanvasRenderingContext2D ctx, width, height){
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'black';
    ctx.drawImage(img, 0, 0);
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
