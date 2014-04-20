part of fwf;


class Agent extends stagexl.Sprite implements stagexl.Animatable {
  
  
  static const PLANKTON = 0;
  static const SARDINE = 1;
  static const TUNA = 2;
  static const SHARK = 3;
  
  stagexl.BitmapData bitmapDataSingle;
  stagexl.BitmapData bitmapDataFew;
  stagexl.BitmapData bitmapDataMany;

  
  stagexl.Sprite fishSprite;
  stagexl.Bitmap fishBitmap;
  

  
  //Position in space
  Point position ;
  
  //Energy value, used for determining behavior modes & population increase/decrease
  num energy;
  
  //Counter, essentially a timer based off of animation recall (every 40ms) to update energy value
  num energyCounter = 0;
  
  //Hunger Energy Threshold, allows for population growth and behavior change
  //Split Energy Threshold for breaking agent into seperate agents
  num split;

  //Counter Threshold, ie when to take action on energyCounter level
  num energyThreshold;

  
  //Population represnted by agent
  num population;
  num oldPopulation;

  
  //Current heading and max speed for animation
  num heading;
  num speed;
  num hunger;

  //Agent type and associated prey and pred
  num type;
  num foodType;
  num predType;
  
  //Current Behavior Mode
  var mode;
  
  //Has the agent been selected for consumption by another agent
  bool ate;
  bool fished;
  
  //nearest agent of food or pred type
  Agent nearest;
  
  AgentManager manager;
  
  /* random number generator */
  Random random = new Random();
  
  //factor that determines how fast the entities run
  num playSpeed = 1;
  bool nofoodBool = false;
  Point nofoodPoint = new Point(0,0);
  
  
  //Uses agent manager findNearest to fill the nearest agent, marks it as ate.
  void findFood(var foodType){
    if(!manager.findNearest(foodType, this)){
      nearest = null;
    }
    else{
      if(nearest != null){
        nearest.ate = true;
      }
    }
  }
  
  
  bool advanceTime(num time){
    
    if(population != oldPopulation){
      if(population < split/3.0){
        fishSprite.removeChild(fishBitmap);
        fishBitmap = new stagexl.Bitmap(bitmapDataSingle);
        fishSprite.addChild(fishBitmap);
      }
      else if(population >= split/3.0 && population < 2*split/3.0){
        fishSprite.removeChild(fishBitmap);
        fishBitmap = new stagexl.Bitmap(bitmapDataFew);
        fishSprite.addChild(fishBitmap);
      }
      else{
        fishSprite.removeChild(fishBitmap);
        fishBitmap = new stagexl.Bitmap(bitmapDataMany);
        fishSprite.addChild(fishBitmap);
      }
    }
    
    //Animate different behaviors based on mode
    switch (mode){
      //Find Food and go to it
      case 'FOOD':
        if(nearest == null){
          findFood(foodType);
        }
        else{
          if(nearest != null){
            if(goto(nearest.position)){
              if(nearest.population > 2){
                num tempPopulation = nearest.population/2.floor();
                nearest.population  = tempPopulation;
                energy += tempPopulation;
                nearest.ateDelay();
                nearest = null;
              }
              else{
                manager.toBeRemoved.add(nearest);
                if(nearest.nearest != null){
                  nearest.nearest.ate = false;
                }
                nearest = null;
                energy += 1;
              }
            }
          }
        }
        return true;
        break;
        
      //Find Pred and go the opposite direction until hungry again
      //CURRENTLY NOT USED
      case 'NOFOOD':
        if(nearest == null){
          findFood(foodType);
        }
        if(!nofoodBool){
          nofoodPoint.x = random.nextInt(game.width);
          nofoodPoint.y = random.nextInt(game.height);    
          nofoodBool = true;
        }
        if(goto(nofoodPoint)){
          nofoodBool = false;
        }
        return true;
        break;
      default:
        break;
    }
  return true;
  }
  
  //Simple Turn and goto function used in animate()
  bool goto(Point newPoint){
    var dist = sqrt(pow((newPoint.x - position.x), 2) + pow((newPoint.y - position.y), 2));
    heading = atan2((newPoint.y - position.y), (newPoint.x - position.x));
    if(dist > speed * playSpeed){
      rotation = atan2(newPoint.y - position.y, newPoint.x - position.x);
      forward(speed * playSpeed);
      return false;
    }
    else{
      rotation = atan2(newPoint.y - position.y, newPoint.x - position.x);
      forward(dist);
      return true;
    }
  }
  
  void forward(num distance) {
    position.x += cos(rotation) * distance;
    position.y += sin(rotation) * distance;
    this.x = position.x;
    this.y = position.y;
  }
  
  //RUN manageEnergy() concurrently with animate, keeps track of energy usages and updates
  //Also changes mode/behavior types
  void manageEnergy(){
    //Decrease energy usage on a timer count
    if(energyCounter > energyThreshold){
      energy-=1;
      energyCounter = 0;

      //Split Agent into two based on agents represented population size
  
      //Increase population if above hunger, check on energy counter timer
      if(energy > hunger){
         mode = 'FOOD';
         oldPopulation = population;
         population++;
         
       
      }
      //Could potentially set AVOID mode here
      if(energy > 0){
        mode = 'FOOD';
      }
      //Decrease population if there is no energy
      //might we worth putting this on a timer count as well
      else{
        mode = 'FOOD';
        oldPopulation = population;
        population -= 1;
        
      }
      if(population <= 0 ){
        if(nearest != null){
          if(nearest.type == foodType){
            nearest.ate = false;
          }
        }
        //removig agent from the ecosystem, must be added to remove queue instead of direct removal
        manager.toBeRemoved.add(this);
      }
      if(population > split){
        oldPopulation = population;
        population = split/2;
        manager.toBeAdded.add(this);
      }
      if(nearest == null){
        mode = 'NOFOOD';
      }
    }
    energyCounter++;
  }
  
  void ateDelay(){
    new Timer(new Duration(seconds : (5 / playSpeed).floor()), () {
        ate = false;
    });
  }
  void fishedDelay(){
    new Timer(new Duration(seconds : (2).floor()), () {
        fished = false;
    });
  }
  
  void updatePlaySpeed(num factor){
    playSpeed = factor;
    //speed = speed * factor;
    energyThreshold = energyThreshold / factor;
  }
  
  
}

//Plankton Agent Class... sets variables
class Plankton extends Agent{
  
  static const PLANKTON = 0;
  static const SARDINE = 1;
  static const TUNA = 2;
  static const SHARK = 3;
  
  stagexl.BitmapData bitmapData;
  
  
  Plankton(stagexl.BitmapData bdata, AgentManager newManager, num newX, num newY):super(){
    
    bitmapData = bdata;
    
    position = new Point(newX, newY);
    this.x = position.x;
    this.y = position.y;
    population = 1;
    energy = 1;
    speed = 0;
    type = PLANKTON;
    manager = newManager;
    ate = false;
    energyThreshold = 0;
  }
}

//Sardine Agent Class... sets variables and draw function
class Sardine extends Agent{
  
  
  static const PLANKTON = 0;
  static const SARDINE = 1;
  static const TUNA = 2;
  static const SHARK = 3;
  
  static const scale = 0.1;
  
  stagexl.ResourceManager _resourceManager;
  
  Sardine(this._resourceManager, AgentManager newManager,num newX, num newY, num newPlaySpeed){
    
    bitmapDataSingle = _resourceManager.getBitmapData("sardine50Single");
    bitmapDataFew = _resourceManager.getBitmapData("sardine50Few");
    bitmapDataMany = _resourceManager.getBitmapData("sardine50Many");
    position = new Point(newX, newY);
    this.x = position.x;
    this.y = position.y;
    this.scaleX = scale;
    this.scaleY = scale;

    playSpeed = newPlaySpeed;
    energy = 5;

    heading = 0;
    speed = 1.000000;
    population = 5;
    type = SARDINE;
    foodType = PLANKTON;
    predType = TUNA;
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    fished = false;
    split = 10;
    energyThreshold = 160;
    energyCounter = random.nextInt(energyThreshold);
    hunger = 3;
    fishSprite = new stagexl.Sprite();
    addChild(fishSprite);
    fishBitmap = new stagexl.Bitmap(bitmapDataFew);
    fishSprite.addChild(fishBitmap);
    
    this.pivotX = fishBitmap.width/2;
    this.pivotY = fishBitmap.height/2;
  }
  
}

//Tuna Agent Class... sets variables and draw function
class Tuna extends Agent{
  
  static const PLANKTON = 0;
  static const SARDINE = 1;
  static const TUNA = 2;
  static const SHARK = 3;
  
  static const scale = 0.1;
  
  stagexl.ResourceManager _resourceManager;
  
  Tuna(this._resourceManager, AgentManager newManager,num newX, num newY, num newPlaySpeed):super(){
    
    bitmapDataSingle = _resourceManager.getBitmapData("sardine50Single");
    bitmapDataFew = _resourceManager.getBitmapData("sardine50Few");
    bitmapDataMany = _resourceManager.getBitmapData("sardine50Many");
    
    playSpeed = newPlaySpeed;
    position = new Point(newX, newY);
    this.x = position.x;
    this.y = position.y;
    this.scaleX = scale;
    this.scaleY = scale;

    energy = 2;
    population = 10;
    speed = 1.1;
    type = TUNA;
    foodType = SARDINE;
    predType = SHARK;
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    fished = false;
    split = 20;
    energyThreshold = 180;
    energyCounter = random.nextInt(energyThreshold);
    hunger = 5;
    fishSprite = new stagexl.Sprite();
    addChild(fishSprite);
    fishBitmap = new stagexl.Bitmap(bitmapDataFew);
    fishSprite.addChild(fishBitmap);
    
    this.pivotX = fishBitmap.width/2;
    this.pivotY = fishBitmap.height/2;
    
  }
}

//Shark Agent Class... sets variables
class Shark extends Agent{
  
  stagexl.BitmapData bitmapData;
  
  static const PLANKTON = 0;
  static const SARDINE = 1;
  static const TUNA = 2;
  static const SHARK = 3;
  
  static const scale = 0.05;
  
  stagexl.ResourceManager _resourceManager;
  
  Shark(this._resourceManager, AgentManager newManager,num newX, num newY, num newPlaySpeed){
    
    bitmapDataSingle = _resourceManager.getBitmapData("sardine50Single");
    bitmapDataFew = _resourceManager.getBitmapData("sardine50Few");
    bitmapDataMany = _resourceManager.getBitmapData("sardine50Many");
    
    playSpeed = newPlaySpeed;
    position = new Point(newX, newY);
    
    this.x = position.x;
    this.y = position.y;
    this.scaleX = scale;
    this.scaleY = scale;

    
    energy = 2;
    population = 10; 
    speed = 1.15;
    type = SHARK;
    foodType = TUNA;
    
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    fished = false;
    
    split = 20;
    energyThreshold = 100;
    energyCounter = random.nextInt(energyThreshold);
    hunger = 5;
    
    fishSprite = new stagexl.Sprite();
    addChild(fishSprite);
    fishBitmap = new stagexl.Bitmap(bitmapDataFew);
    fishSprite.addChild(fishBitmap);
    
    this.pivotX = fishBitmap.width/2;
    this.pivotY = fishBitmap.height/2;
  }
}


/*Agent Manager class for the ecosystem.  Should be initalized in Game() but drawn in
appriorate phases, such as REGROW and possibly FISH
*/
class AgentManager extends stagexl.Sprite implements stagexl.Animatable{
  
  static const PLANKTON = 0;
  static const SARDINE = 1;
  static const TUNA = 2;
  static const SHARK = 3;
  
  //Lists of agents
  List<Agent> fish = new List<Agent>();
  
  //Add and remove queues to keep for loops from throwing exceptions
  List<Agent> toBeRemoved = new List<Agent>();
  List<Agent> toBeAdded = new List<Agent>();
  
  Random random = new Random();
  
  //width and height of canvas
  num width, height;
  
  //Counter that keeps track on when to add more plankton
  num planktonTimer;
  
  num playSpeed;
  
  var fishCount = {
    PLANKTON : 0,
    SARDINE : 0,
    TUNA : 0,
    SHARK:0,
    
  };
  
  stagexl.ResourceManager _resourceManager;
  stagexl.Juggler _juggler;
  
  //Constructor, setting initial number of each agent type
  AgentManager(this._resourceManager, this._juggler, num startPCount,num startSaCount,num startTCount, num startSCount, this.width, this.height){

    planktonTimer = 0;
    playSpeed = 1;
    
    fishCount[PLANKTON] = startPCount;
    fishCount[SARDINE] = startSaCount;
    fishCount[TUNA] = startTCount;
    fishCount[SHARK] = startSCount;
    
    //Set all the agents at random locations based off the starting counts    
    seedAgents(startPCount, PLANKTON);
    seedAgents(startSaCount, SARDINE);
    seedAgents(startTCount, TUNA);
    seedAgents(startSCount, SHARK);
    
  }
  
  //Seed new agents at random position and add to respective agent list
  void seedAgents(num Count, var type){
    for(int i = 0; i < Count; i++){
      num rx = random.nextInt(width);
      num ry = random.nextInt(height);
        if(type == PLANKTON){
          Plankton temp = new Plankton(null, this, rx, ry);
          fish.add(temp);
//          this.addChild(temp);
//          _juggler.add(temp);
        }
        if(type == SARDINE){
          Sardine temp = new Sardine(_resourceManager,this, rx, ry, playSpeed);
          fish.add(temp);
          this.addChild(temp);
          _juggler.add(temp);
        }
        if(type == TUNA){
          Tuna temp = new Tuna(_resourceManager,this, rx, ry, playSpeed);
          fish.add(temp);
          this.addChild(temp);
          _juggler.add(temp);
        }
        if(type == SHARK){
          Shark temp = new Shark(_resourceManager,this, rx, ry, playSpeed);
          fish.add(temp);
          this.addChild(temp);
          _juggler.add(temp);
        }
      }
  }
  
  //Iterate through each list and draw the agent
//  void draw(CanvasRenderingContext2D ctx){
//    for(Agent fishies in fish){
//      fishies.draw(ctx);
//    }
//  }
  
  num distanceSquare(Point a, Point b){
    return pow((a.x - b.x), 2) + pow((a.y - b.y), 2);
  }
  
//  void drawPortal(CanvasRenderingContext2D ctx, Point center, num r){
//    for(Agent fishies in fish){
//      var dist = distanceSquare(fishies.position, center);
//      if(r*r > dist){
//        fishies.draw(ctx);
//      }
//    }
//  }
  
  
  
  //Find the nearest agent of type 'type' and set the parent's variable 'nearest' to that agent
  //returns true if it finds a nearest agent, otherwise returns false
  bool findNearest(var type, Agent parent){
    
    //set minDist to high, since we're comparing dist squared
    num minDist = 50000000;
    Agent nearest;
    
    for(Agent fishies in fish){
      if(fishies.type == type){
        var dist = distanceSquare(fishies.position, parent.position);
        if(minDist > dist && !fishies.ate){
          minDist = dist;
          nearest = fishies;
        }
      }
    }
    if(nearest != null){
      parent.nearest = nearest;
      return true;
    }
    else{
      return false;
      }
  }
  
  //remove agent at a given 'location' from the type of list
  void removeAgent(Agent agent){
    
//    fish.remove(agent);
//    if(agent.type != 'plankton'){
//      this.removeChild(agent);
//      _juggler.remove(agent);
//    }
    for(int i = 0; i < fish.length; i++){
      if(agent.position.x  == fish[i].position.x && agent.position.y == fish[i].position.y && fish[i].type == agent.type){
        fish.removeAt(i);
        
        if(agent.type == PLANKTON) fishCount[PLANKTON]--;
        if(agent.type == SARDINE) fishCount[SARDINE]--;
        if(agent.type == TUNA) fishCount[TUNA]--;
        if(agent.type == SHARK) fishCount[SHARK]--;
        
        if(agent.type != PLANKTON){
          this.removeChild(agent);
          _juggler.remove(agent);
        }
      }
    }
  }
  
  
  //Inserts a new agent into the agent list
  //will send new split agents to give location
  void addAgent(var type, [Point location]){
    num rx = random.nextInt(width);
    num ry = random.nextInt(height);
    if(type == PLANKTON){
      Plankton temp = new Plankton(null, this, rx, ry);
      fish.add(temp);
      fishCount[PLANKTON]++;
//      this.addChild(temp);
//      _juggler.add(temp);
    }
    if(type == SARDINE){
      Sardine temp = new Sardine(_resourceManager,this, rx, ry, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      fish.add(temp);
      this.addChild(temp);
      _juggler.add(temp);
      fishCount[SARDINE]++;
    }
    if(type == TUNA){
      Tuna temp = new Tuna(_resourceManager,this, rx, ry, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      fish.add(temp);
      this.addChild(temp);
      _juggler.add(temp);
      fishCount[TUNA]++;
    }
    if(type == SHARK){
      Shark temp = new Shark(_resourceManager,this, rx, ry, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      fish.add(temp);
      this.addChild(temp);
      _juggler.add(temp);
      fishCount[SHARK]++;
    }
  }
  
  //Animate each of the moving agents lists
  bool advanceTime(num time){
    for(Agent fishies in fish){
      if( fishies.type != PLANKTON){
        fishies.manageEnergy();
//        fishies.animate();
      }
    }  
    
    //Update lists based on the toBeRemoved and toBeAdded queues
    for(Agent agent in toBeRemoved){
      removeAgent(agent);
    }
    toBeRemoved.clear();
    
    for(Agent agent in toBeAdded){
      Point newLocation = agent.position;
      newLocation.y += 25;
      addAgent(agent.type, newLocation);
    }
    toBeAdded.clear();
    
    if(planktonTimer > 10/playSpeed){
      for(int i = 0; i < playSpeed; i++){
        addAgent(PLANKTON);
        addAgent(PLANKTON);
             
      }
      planktonTimer = 0;
    }
    planktonTimer++;
    return true;
  }
  
  void updateSpeed(num factor){
    playSpeed = factor;
    for(Agent fishies in fish){
      if(fishies.type != PLANKTON)
        fishies.updatePlaySpeed(factor);
    }
  }
  
  void catchCheck(Boat fishingBoat){
    if(fishingBoat._dragging){
        for(Agent fishies in fish){
          if((fishies.type == fishingBoat.boatType && fishies.position.x > fishingBoat.x - fishingBoat.width/2 && fishies.position.x < fishingBoat.x + fishingBoat.width/2)
              && (fishies.position.y > fishingBoat.y - fishingBoat.height/2 && fishies.position.y < fishingBoat.y + fishingBoat.height/2) && !fishies.fished){
            num temp = fishies.population;
            fishingBoat.oldfishCount = fishingBoat.fishCount;
            fishingBoat.fishCount += temp;
            //fishingBoat.soldFish = true;
            if(fishies.population > 2){
              fishies.oldPopulation = fishies.population;
              fishies.population = temp/2; 
              fishies.fished = true;
              fishies.fishedDelay();
            }
            else{
              toBeRemoved.add(fishies);
            }
        }
      }
    }
  }
  
  int returnCount(var type){
    int count = 0;
    for(Agent fishies in fish){
      if(fishies.type == type){
        count++;
      }
    }
    return count;
  }
  
}