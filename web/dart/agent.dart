part of fwf;


class Agent{
  //Position in space
  Point position ;
  
  //Energy value, used for determining behavior modes & population increase/decrease
  num energy;
  
  //Counter, essentially a timer based off of animation recall (every 40ms) to update energy value
  num energyCounter = 0;
  
  //Hunger Energy Threshold, allows for population growth and behavior change
  num hunger;
  //Split Energy Threshold for breaking agent into seperate agents
  num split;
  //Counter Threshold, ie when to take action on energyCounter level
  num energyThreshold;
  
  /*
  //Alternatively make the energy use dependent on distance traveled by agent
  num distTravel;
  num dist2Energy = 50;
   */
  
  //Population represnted by agent
  num population;

  
  //Current heading and max speed for animation
  num heading;
  num speed;
  
  //Agent type and associated prey and pred
  var type;
  var foodType;
  var predType;
  
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
  
  
  void animate(){
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
        break;
      default:
        break;
    }
  }
  
  //Simple Turn and goto function used in animate()
  bool goto(Point newPoint){
    var dist = sqrt(pow((newPoint.x - position.x), 2) + pow((newPoint.y - position.y), 2));
    heading = atan2((newPoint.y - position.y), (newPoint.x - position.x));
    if(dist > speed * playSpeed){
      forward(speed * playSpeed);
      return false;
    }
    else{
      forward(dist);

      return true;
    }
  }
  
  void forward(num distance) {
    position.x += cos(heading) * distance;
    position.y += sin(heading) * distance;
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
      //Could potentially set AVOID mode here
      if(energy > hunger){
        mode = 'FOOD';
        population++;
      }
      //FOOD mode conditions
      else if(energy < hunger && energy > 0){
        mode = 'FOOD';
      }
      //Decrease population if there is no energy
      //might we worth putting this on a timer count as well
      else if (energy <= 0){
        mode = 'FOOD';
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
  
  void draw(CanvasRenderingContext2D ctx){
    switch(type){
      case 'plankton':
        ctx.fillStyle = 'black';
        ctx.fillRect(position.x, position.y, 5, 5);
        break;
      case 'sardine':
        ctx.fillStyle = 'green';
        ctx.fillRect(position.x, position.y, 10 + population, 10 + population);
        break;
      case 'tuna':
        ctx.fillStyle = 'red';
        ctx.fillRect(position.x, position.y, 15 + population, 15 + population);
        break;
      case 'shark':
        ctx.fillStyle = 'blue';
        ctx.fillRect(position.x, position.y, 20 + population, 20 + population);
        break;
    }
  }
  
}

//Plankton Agent Class... sets variables
class Plankton extends Agent{
  
  Plankton(AgentManager newManager, num newX, num newY){
    position = new Point(newX, newY);
    population = 1;
    energy = 1;
    speed = 0;
    type = 'plankton';
    manager = newManager;
    ate = false;
    energyThreshold = 0;
  }
}

//Sardine Agent Class... sets variables and draw function
class Sardine extends Agent{
  
  Sardine(AgentManager newManager,num newX, num newY, num newPlaySpeed){
    position = new Point(newX, newY);
    playSpeed = newPlaySpeed;
    energy = 2;
    energyCounter = 0;
    heading = 0;
    speed = 1.000000;
    population = 5;
    type = 'sardine';
    foodType = 'plankton';
    predType = 'tuna';
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    fished = false;
    hunger = 3;
    split = 10;
    energyThreshold = 160;
  }
  
}

//Tuna Agent Class... sets variables and draw function
class Tuna extends Agent{
  Tuna(AgentManager newManager,num newX, num newY, num newPlaySpeed){
    playSpeed = newPlaySpeed;
    position = new Point(newX, newY);
    energy = 2;
    energyCounter = 0;
    population = 10;
    speed = 1.1;
    type = 'tuna';
    foodType = 'sardine';
    predType = 'shark';
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    fished = false;
    split = 20;
    hunger = 5.0;
    energyThreshold = 180;
  }
}

//Shark Agent Class... sets variables
class Shark extends Agent{
  Shark(AgentManager newManager,num newX, num newY, num newPlaySpeed){
    playSpeed = newPlaySpeed;
    position = new Point(newX, newY);
    energy = 2;
    energyCounter = 0;
    population = 10; 
    speed = 1.15;
    type = 'shark';
    foodType = 'tuna';
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    fished = false;
    split = 20;
    hunger = 5;
    energyThreshold = 100.0;
  }
}


/*Agent Manager class for the ecosystem.  Should be initalized in Game() but drawn in
appriorate phases, such as REGROW and possibly FISH
*/
class AgentManager{
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
  
  //Constructor, setting initial number of each agent type
  AgentManager(num startPCount,num startSaCount,num startTCount, num startSCount, this.width, this.height){

    planktonTimer = 0;
    playSpeed = 1;
    
    //Set all the agents at random locations based off the starting counts    
    seedAgents(startPCount, 'plankton');
    seedAgents(startSaCount, 'sardine');
    seedAgents(startTCount, 'tuna');
    seedAgents(startSCount, 'shark');
    
  }
  
  //Seed new agents at random position and add to respective agent list
  void seedAgents(num Count, var type){
    for(int i = 0; i < Count; i++){
      num x = random.nextInt(width);
      num y = random.nextInt(height);
        if(type == 'plankton'){
          Plankton temp = new Plankton(this, x, y);
          fish.add(temp);
        }
        if(type == 'sardine'){
          Sardine temp = new Sardine(this, x, y, playSpeed);
          fish.add(temp);
        }
        if(type == 'tuna'){
          Tuna temp = new Tuna(this, x, y, playSpeed);
          fish.add(temp);
        }
        if(type == 'shark'){
          Shark temp = new Shark(this, x, y, playSpeed);
          fish.add(temp);
        }
      }
  }
  
  //Iterate through each list and draw the agent
  void draw(CanvasRenderingContext2D ctx){
    for(Agent fishies in fish){
      fishies.draw(ctx);
    }
  }
  
  num distanceSquare(Point a, Point b){
    return pow((a.x - b.x), 2) + pow((a.y - b.y), 2);
  }
  
  void drawPortal(CanvasRenderingContext2D ctx, Point center, num r){
    for(Agent fishies in fish){
      var dist = distanceSquare(fishies.position, center);
      if(r*r > dist){
        fishies.draw(ctx);
      }
    }
  }
  
  
  
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
  void removeAgent(var type,  Point location){
    
    for(int i = 0; i < fish.length; i++){
      if(location.x  == fish[i].position.x && location.y == fish[i].position.y && fish[i].type == type){
        fish.removeAt(i);
      }
    }
  }
  
  
  //Inserts a new agent into the agent list
  //will send new split agents to give location
  void addAgent(var type, [Point location]){
    num x = random.nextInt(width);
    num y = random.nextInt(height);
    if(type == 'plankton'){
      Plankton temp = new Plankton(this, x, y);
      fish.add(temp);
    }
    if(type == 'sardine'){
      Sardine temp = new Sardine(this, x, y, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      fish.add(temp);
    }
    if(type == 'tuna'){
      Tuna temp = new Tuna(this, x, y, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      fish.add(temp);
    }
    if(type == 'shark'){
      Shark temp = new Shark(this, x, y, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      fish.add(temp);
    }
  }
  
  //Animate each of the moving agents lists
  void animate(){
    for(Agent fishies in fish){
      if( fishies.type != 'plankton'){
        fishies.manageEnergy();
        fishies.animate();
      }
    }  
    
    //Update lists based on the toBeRemoved and toBeAdded queues
    for(Agent agent in toBeRemoved){
      removeAgent(agent.type, agent.position);
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
        addAgent('plankton');
        addAgent('plankton');
      }
      planktonTimer = 0;
    }
    planktonTimer++;
  }
  
  void updateSpeed(num factor){
    playSpeed = factor;
    for(Agent fishies in fish){
      if(fishies.type != 'plankton')
        fishies.updatePlaySpeed(factor);
    }
  }
  
  void catchCheck(Boat fishingBoat){
    if(fishingBoat.boatPath.length > 1){
        for(Agent fishies in fish){
          if((fishies.type == fishingBoat.boatType && fishies.position.x > fishingBoat.x - fishingBoat.img.width/2 && fishies.position.x < fishingBoat.x + fishingBoat.img.width/2)
              && (fishies.position.y > fishingBoat.y - fishingBoat.img.height/2 && fishies.position.y < fishingBoat.y + fishingBoat.img.height/2) && !fishies.fished){
            num temp = fishies.population;
            fishingBoat.oldfishCount = fishingBoat.fishCount;
            fishingBoat.fishCount += temp;
            fishingBoat.soldFish = true;
            if(fishies.population > 2){
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