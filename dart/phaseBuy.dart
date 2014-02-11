part of fwf;


class Buy extends TouchLayer{
  Fleet fleetA;
  Fleet fleetB;
  
  //intial well for sale boats  
  Boat buySardine;
  Boat buyTuna;
  Boat buyShark;
  
  //dimensions of buy box 
  num buySquareWidth = 400;
  num buySquareHeight = 400;
  num buySquareX = 300;
  num buySquareY = 300;
  
  //dimensions of fleet boxes for fleet A and B purchasing 
  num fleetABuySquareX = 0;
  num fleetABuySquareY = 110;
  num fleetAbuySquareWidth = 235;
  num fleetAbuySquareHeight = 600;
  
  num fleetBBuySquareX = 765;
  num fleetBBuySquareY = 110;
  num fleetBbuySquareWidth = 235;
  num fleetBbuySquareHeight = 600;
  
  //prices of boats 
  num sardinePrice = 100;
  num tunaPrice = 200;
  num sharkPrice = 300;
  
  //images for harbor and buy box 
  ImageElement harborOverlay = new ImageElement();
  ImageElement buyOverlay = new ImageElement();
  
  //coordinates for well boats 
  num tunaWellX, tunaWellY;
  num sardineWellX, sardineWellY;
  num sharkWellX, sharkWellY;
  num speedWellX, speedWellY;
  num capacityWellX, capacityWellY;
  num rewardWellX, rewardWellY;
  
  TouchManager tmanager = new TouchManager();
  
  //list of all well boats 
  List<Boat> buyingSardine = new List<Boat>();
  List<Boat> buyingTuna = new List<Boat>();
  List<Boat> buyingShark = new List<Boat>();
  List<Upgrade> buyingSpeed = new List<Upgrade>();
  List<Upgrade> buyingCapacity = new List<Upgrade>();
  List<Upgrade> buyingReward = new List<Upgrade>();
  
  Buy(Fleet A, Fleet B){    
    fleetA = A;
    fleetB = B;

    sardineWellX = 350.0;
    sardineWellY = 400.0;
    
    tunaWellX = 500.0;
    tunaWellY = 400.0;
    
    sharkWellX = 650.0;
    sharkWellY = 400.0;
    
    speedWellX = 350.0;
    speedWellY = 550.0;
    
    capacityWellX = 500.0;
    capacityWellY = 550.0;
    
    rewardWellX = 650.0;
    rewardWellY = 550.0;
    
    tmanager.registerEvents(document.documentElement);
    tmanager.addTouchLayer(this);
    tmanager.disable();
    
    //create new ForSaleBoats in well locations 
    Boat newSardine = new ForSaleBoat(this, sardineWellX, sardineWellY, 'sardine', sardinePrice);
    newSardine.heading = -PI/2;
    buyingSardine.add(newSardine);
    touchables.add(newSardine);
    
    Boat newTuna = new ForSaleBoat(this, tunaWellX, tunaWellY, 'tuna', tunaPrice);
    newTuna.heading = -PI/2;
    buyingTuna.add(newTuna);
    touchables.add(newTuna);
    
    Boat newShark = new ForSaleBoat(this, sharkWellX, sharkWellY, 'shark', sharkPrice);
    newShark.heading = -PI/2;
    buyingShark.add(newShark);
    touchables.add(newShark);
    
    Upgrade newSpeed = new Upgrade(this, speedWellX, speedWellY, 'speed');
    buyingSpeed.add(newSpeed);
    touchables.add(newSpeed);
    
    Upgrade newCapacity = new Upgrade(this, capacityWellX, capacityWellY, 'capacity');
    buyingSpeed.add(newCapacity);
    touchables.add(newCapacity);
    
    Upgrade newReward = new Upgrade(this, rewardWellX, rewardWellY, 'reward');
    buyingReward.add(newReward);
    touchables.add(newReward);
    
    harborOverlay.src = "images/harborOverlay.png";
    buyOverlay.src = "images/buyOverlay.png";
    
  }
  
  //keeps the well full 
  void boatTouched(ForSaleBoat boat) {
    if(boat.boatType == 'sardine'){
      Boat newSardine = new ForSaleBoat(this, sardineWellX, sardineWellY, 'sardine', sardinePrice);
      buyingSardine.add(newSardine);
      touchables.add(newSardine);
    }
    if(boat.boatType == 'tuna'){
      Boat newTuna = new ForSaleBoat(this, tunaWellX, tunaWellY, 'tuna', tunaPrice);
      buyingTuna.add(newTuna);
      touchables.add(newTuna);
    }
    if(boat.boatType == 'shark'){
      Boat newShark = new ForSaleBoat(this, sharkWellX, sharkWellY, 'shark', sharkPrice);
      buyingShark.add(newShark);
      touchables.add(newShark);
    }
  }

    void upgradeTouched(Upgrade upgrade){
      if(upgrade.upgrade == 'speed'){
        Upgrade newUpgrade = new Upgrade(this, speedWellX, speedWellY, 'speed');
        buyingSpeed.add(newUpgrade);
        touchables.add(newUpgrade);
      }
      if(upgrade.upgrade == 'capacity'){
        Upgrade newUpgrade = new Upgrade(this, capacityWellX, capacityWellY, 'capacity');
        buyingCapacity.add(newUpgrade);
        touchables.add(newUpgrade);
      }
      if(upgrade.upgrade == 'reward'){
        Upgrade newUpgrade = new Upgrade(this, rewardWellX, rewardWellY, 'reward');
        buyingCapacity.add(newUpgrade);
        touchables.add(newUpgrade);
      }
    }
  
  void draw(CanvasRenderingContext2D ctx, num width, num height){
    ctx.clearRect(0, 0, width, height);
    ctx.drawImage(harborOverlay, 0, 0);
    ctx.drawImage(buyOverlay, 0, 0);
    ctx.fillStyle = 'black';
    ctx.font = '30px sans-serif';
    ctx.textAlign = 'left';
    ctx.textBaseline = 'center';
    ctx.fillText("BUY STUFF: ", 100, 50);
    //buy box?
    ctx.fillStyle = 'grey';
    ctx.fillRect(buySquareX, buySquareY, buySquareWidth, buySquareHeight);
    //ctx.fillRect(fleetABuySquareX, fleetABuySquareY, fleetAbuySquareWidth, fleetAbuySquareHeight);
    //ctx.fillRect(fleetBBuySquareX, fleetBBuySquareY, fleetBbuySquareWidth, fleetBbuySquareHeight);
    ctx.fillStyle = 'white';
    
    ctx.fillText("Select Boats: ", 450, 250);
    ctx.fillText("${sardinePrice}", sardineWellX - 25, 350);
    ctx.fillText("${tunaPrice}", tunaWellX - 25, 350);
    ctx.fillText("${sharkPrice}", sharkWellX -25, 350);
    
    ctx.fillText("${fleetA.coin}", 50, 700);
    ctx.fillText("${fleetB.coin}", 900, 700);
    
    ctx.fillText("100", speedWellX - 25, 475);
    ctx.fillText("100", capacityWellX - 25, 475);
    
    ctx.fillText("10,000", rewardWellX - 25, 475);
    
    //draw boats
    
    if(buyingSardine.length > -1){
      for(Boat boat in buyingSardine){
       boat.draw(ctx, width, height);
      }
    }
    if(buyingTuna.length > -1){
      for(Boat boat in buyingTuna){
       boat.draw(ctx, width, height);
      }
    }
    if(buyingShark.length > -1){
      for(Boat boat in buyingShark){
       boat.draw(ctx, width, height);
      }
    }
    if(buyingSpeed.length > -1){
      for(Upgrade upgrade in buyingSpeed){
        upgrade.draw(ctx, width, height);
      }
    }
    if(buyingCapacity.length > -1){
      for(Upgrade upgrade in buyingCapacity){
        upgrade.draw(ctx, width, height);
      }
    }
    if(buyingReward.length > -1){
      for(Upgrade upgrade in buyingReward){
        upgrade.draw(ctx, width, height);
      }
    }

    fleetA.draw(ctx, width, height);
    fleetB.draw(ctx, width, height);
    
  }
  
  void deleteBoat(ForSaleBoat boat){
    if(buyingSardine.remove(boat)){
      repaint();
      return;
    }
    else if(buyingTuna.remove(boat)){
      repaint();
      return;
    }
    else if(buyingShark.remove(boat)){
      repaint();
      return;
    }
  }
  
  void deleteUpgrade(Upgrade upgrade){
    if(buyingSpeed.remove(upgrade)){
      repaint();
      return;
    }
    else if(buyingCapacity.remove(upgrade)){
      repaint();
      return;
    }
    else if(buyingReward.remove(upgrade)){
      repaint();
      return;
    }
    
  }
  
  void show(){
    tmanager.enable();
//    fleetA.show();
//    fleetB.show();
  }
  
  void hide(){
    tmanager.disable();
//    fleetA.hide();
//    fleetB.hide();
  }
  
  //animates boats sliding back to well 
  void animate() {
    if(buyingSardine.length > 0){
      for(Boat boat in buyingSardine){
       boat.animate();
      }
    }
    if(buyingTuna.length > 0){
      for(Boat boat in buyingTuna){
       boat.animate();
      }
    }
    if(buyingShark.length > 0){
      for(Boat boat in buyingShark){
       boat.animate();
      }
    }
    if(buyingSpeed.length > 0){
      for(Upgrade upgrade in buyingSpeed){
        upgrade.animate();
      }
    }
    if(buyingCapacity.length > 0){
      for(Upgrade upgrade in buyingCapacity){
        upgrade.animate();
      }
    }
    if(buyingReward.length > 0){
      for(Upgrade upgrade in buyingReward){
        upgrade.animate();
      }
    }
  }

}



class Upgrade implements Touchable {
  
  Buy buyPhase;
  var upgradeType;
  var upgrade;
  num x,y, wellX, wellY, upgradeVal;
  num heading = 0.0;
  num returnVel = 30.0;
  num error = .1;
  num price;
  
  ImageElement img = new ImageElement();
  
  /* used for mouse / touch interaction */  
  double _targetX, _targetY;
  
  /* is this boat being touched now? */
  bool _dragging = false;
  
  Upgrade(Buy phase, num newX, num newY, var newUpgrade){
    x = newX;
    y = newY;
    wellX = newX;
    wellY = newY;
    buyPhase = phase;
    
    upgrade = newUpgrade;
    
    if(newUpgrade == 'speed'){
      price = 100;
      upgradeType = 'fleet';
      upgrade = 'speed';
      upgradeVal = 10;
      img.src = 'images/speed.png';
      
    }
    else if(newUpgrade == 'capacity'){
      price = 100;
      upgradeType = 'fleet';
      upgrade = 'capacity';
      upgradeVal = 10;
      img.src = 'images/capacity.png';
      
    }
    else if(newUpgrade == 'reward'){
      price = 10000;
      upgradeType = 'fleet';
      upgrade = 'reward';
      upgradeVal = 10;
      img.src = 'images/reward.png';
      
    }
    
    heading = -PI/2;


    
  }
  
  void move(num dx, num dy) {
    x += dx;
    y += dy;
  }
  
  
  bool canBuy(){

    if(upgradeType == 'fleet'){
      num abx = buyPhase.fleetABuySquareX;
      num aby = buyPhase.fleetABuySquareY;
      num bbx = buyPhase.fleetBBuySquareX;
      num bby = buyPhase.fleetBBuySquareY;
      
      //if boat is within the buy box for fleet A 
      if(x >= abx && y >= aby && x <= abx + buyPhase.fleetAbuySquareWidth && y <= aby + buyPhase.fleetAbuySquareHeight){
        //if player has enough money to buy boat and less than fleetMax amount of boats 
        if(buyPhase.fleetA.coin >= price){
          buyPhase.fleetA.upgrade(upgrade, upgradeVal);
          buyPhase.fleetA.coin -= price;
          return true;
        }
        else{
          return false;
        }
      }
      
      //same for fleet B
      else if(x >= bbx && y >= bby && x <= bbx + buyPhase.fleetBbuySquareWidth && y <= bby + buyPhase.fleetBbuySquareHeight){
        if(buyPhase.fleetB.coin >= price){
          buyPhase.fleetB.upgrade(upgrade, upgradeVal);
          buyPhase.fleetB.coin -= price;
          return true;
        }
        else{
          return false;
        }
      }
      else{
        return false;
      }
    }
  }
  
  void animate(){
    //slide back to well animiation 
    
    if(_dragging == false){
      if(!canBuy()){
        
        if(upgradeType == 'speed'){
          wellX = buyPhase.speedWellX;
          wellY = buyPhase.speedWellY;
        }
        else if(upgradeType == 'capacity'){
          wellX = buyPhase.capacityWellX;
          wellY = buyPhase.capacityWellY;
        }

        if((x > wellX + error || x < wellX - error) && (y > wellY + error || y < wellY - error)){
          num dist = sqrt(pow(x - wellX, 2) + pow(y - wellY, 2));
          if(dist > returnVel){
            move((wellX - x)/dist*returnVel, (wellY - y)/dist*returnVel);
          }
          else{
            move((wellX - x)/dist*dist, (wellY - y)/dist*dist);
          }
        }
      }
    }
  }
  
  num get iwidth => img.width;
  
  num get iheight => img.height;
  
  void draw(CanvasRenderingContext2D ctx, num width, num height) {
    ctx.save();
    {
      ctx.translate(x, y);
      ctx.rotate(heading + PI/2);
      ctx.drawImage(img, -img.width/2, -img.height/2);
     
    }

    ctx.restore();
  }
  
  bool touchDown(Contact c) {
    buyPhase.upgradeTouched(this);
    _dragging = true;
    return true;
  }
  
  void touchDrag(Contact c) {
    move(c.touchX - x, c.touchY - y);
    _targetX = c.touchX;
    _targetY = c.touchY;    
    repaint();
  }
  
  void touchUp(Contact c) {
    _dragging = false;
    if(canBuy()){
      buyPhase.deleteUpgrade(this);
    }
    
  }

  bool containsTouch(Contact c) {
    num tx = c.touchX;
    num ty = c.touchY;
    num bx = x - iwidth/2;
    num by = y - iheight/2;
    return (tx >= bx && ty >= by && tx <= bx + iwidth && ty <= by + iheight);
  }
  
    
  void touchSlide(Contact c) { }  
}
