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
                manager.removeAgent(foodType, nearest.position);
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
    //distTravel += distance; // USE IF TRYING TO BASE ENERGY USE OFF OF DISTANCE TRAVELED
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
      if(population == 0 ){
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
  
}

//Plankton Agent Class... sets variables and draw function
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
  
  void draw(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'black';
    ctx.fillRect(position.x, position.y, 5, 5);
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
  
  void draw(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'green';
    ctx.fillRect(position.x, position.y, 10 + population, 10 + population);
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
  
  void draw(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'red';
    ctx.fillRect(position.x, position.y, 15 + population, 15 + population);
  }

}

//Shark Agent Class... sets variables and draw function
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
  
  void draw(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'blue';
    ctx.fillRect(position.x, position.y, 20 + population, 20 + population);
  }
}


/*Agent Manager class for the ecosystem.  Should be initalized in Game() but drawn in
appriorate phases, such as REGROW and possibly FISH
*/
class AgentManager{
  //Lists of each agent types
  List<Plankton> planktons = new List<Plankton>();
  List<Sardine> sardines = new List<Sardine>();
  List<Tuna> tunas = new List<Tuna>();
  List<Shark> sharks = new List<Shark>();
  
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
  AgentManager(num startPCount,num startSaCount,num startTCount, num startSCount, num newWidth, num newHeight){
    width = newWidth;
    height = newHeight;
    
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
            planktons.add(temp);
          }
          if(type == 'sardine'){
            Sardine temp = new Sardine(this, x, y, playSpeed);
            sardines.add(temp);
          }
          if(type == 'tuna'){
            Tuna temp = new Tuna(this, x, y, playSpeed);
            tunas.add(temp);
          }
          if(type == 'shark'){
            Shark temp = new Shark(this, x, y, playSpeed);
            sharks.add(temp);
          }
        }
  }
  
  //Iterate through each list and draw the agent
  void draw(CanvasRenderingContext2D ctx){
    for(Plankton plankton in planktons){
      plankton.draw(ctx);
    }
    for(Sardine sardine in sardines){
      sardine.draw(ctx);
    }
    for(Tuna tuna in tunas){
      tuna.draw(ctx);
    }
    for(Shark shark in sharks){
      shark.draw(ctx);
    }
  }
  
  num distanceSquare(Point a, Point b){
    return pow((a.x - b.x), 2) + pow((a.y - b.y), 2);
  }
  
  void drawPortal(CanvasRenderingContext2D ctx, Point center, num r){
    for(Sardine sardine in sardines){
      var dist = distanceSquare(sardine.position, center);
      if(r*r > dist){
        sardine.draw(ctx);
      }
    }
    for(Tuna tuna in tunas){
      var dist = distanceSquare(tuna.position, center);
      if(r*r > dist){
        tuna.draw(ctx);
      }
    }
    for(Shark shark in sharks){
      var dist = distanceSquare(shark.position, center);
      if(r*r > dist){
        shark.draw(ctx);
      }
    }
  }
  
  
  
  //Find the nearest agent of type 'type' and set the parent's variable 'nearest' to that agent
  //returns true if it finds a nearest agent, otherwise returns false
  bool findNearest(var type, Agent parent){
    
    //set minDist to high, since we're comparing dist squared
    num minDist = 50000000;
    Agent nearest;
    if(type == 'plankton'){
      if(planktons.length == 0){
        return false;
      }
      else{
        for(Plankton plankton in planktons){
          var dist = distanceSquare(plankton.position, parent.position);
          if(minDist > dist && !plankton.ate){
            minDist = dist;
            nearest = plankton;
          }
        }
        parent.nearest = nearest;
        return true;
      }
    }
    else if(type == 'sardine'){
      if(sardines.length == 0){
        return false;
      }
      else{
        for(Sardine sardine in sardines){
          var dist = distanceSquare(sardine.position, parent.position);
          if(minDist > dist && !sardine.ate){
            minDist = dist;
            nearest = sardine;
          }
        }
        parent.nearest = nearest;        
        return true;
      }
    }
    else if(type == 'tuna'){
      if(tunas.length == 0){
        return false;
      }
      else{
        for(Tuna tuna in tunas){
          var dist = distanceSquare(tuna.position, parent.position);
          if(minDist > dist && !tuna.ate){
            minDist = dist;
            nearest = tuna;
          }
        }
        parent.nearest = nearest;
        return true;
      }
    }
    else if(type == 'shark'){
      if(sharks.length == 0){
        return false;
      }
      else{
        for(Shark shark in sharks){

          var dist = distanceSquare(shark.position, parent.position);
          if(minDist > dist && !shark.ate){
            minDist = dist;
            nearest = shark;
          }
        }
        parent.nearest = nearest;
        return true;
      }
    }
    else{
      return false;
    }
    
  }
  
  //remove agent at a given 'location' from the type of list
  void removeAgent(var type,  Point location){
    if(type == 'plankton'){
      for(int i = 0; i < planktons.length; i++){
        if(location.x  == planktons[i].position.x && location.y == planktons[i].position.y){
          planktons.removeAt(i);
        }

      }
    }
    if(type == 'sardine'){
      for(int i = 0; i < sardines.length; i++){
        if(location.x  == sardines[i].position.x && location.y == sardines[i].position.y){
          sardines.removeAt(i);
        }
      }
    }
    if(type == 'tuna'){
      for(int i = 0; i < tunas.length; i++){
        if(location.x  == tunas[i].position.x && location.y == tunas[i].position.y){
          tunas.removeAt(i);
        }
      }
    }
    if(type == 'shark'){
      for(int i = 0; i < sharks.length; i++){
        if(location.x  == sharks[i].position.x && location.y == sharks[i].position.y){
          sharks.removeAt(i);
        }
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
      planktons.add(temp);
    }
    if(type == 'sardine'){
      Sardine temp = new Sardine(this, x, y, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      sardines.add(temp);
    }
    if(type == 'tuna'){
      Tuna temp = new Tuna(this, x, y, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      tunas.add(temp);
    }
    if(type == 'shark'){
      Shark temp = new Shark(this, x, y, playSpeed);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      sharks.add(temp);
    }
  }
  
  //Animate each of the moving agents lists
  void animate(){
    for(Sardine sardine in sardines){
      sardine.manageEnergy();
      sardine.animate();
    }
    for(Tuna tuna in tunas){
      tuna.manageEnergy();
      tuna.animate();
    }
    for(Shark shark in sharks){
      shark.manageEnergy();
      shark.animate();
    }
    
    if(planktonTimer > 10/playSpeed){
      for(int i = 0; i < playSpeed; i++){
        addAgent('plankton');
        addAgent('plankton');
      }
      planktonTimer = 0;
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
    
    //print("${planktons.length}, ${sardines.length}, ${tunas.length}, ${sharks.length}");
    planktonTimer++;
  }
  
  void updateSpeed(num factor){
    playSpeed = factor;
    for(Sardine sardine in sardines){
      sardine.updatePlaySpeed(factor);
    }
    for(Tuna tuna in tunas){
      tuna.updatePlaySpeed(factor);
    }
    for(Shark shark in sharks){
      shark.updatePlaySpeed(factor);
    }
    
  }
  
  void catchCheck(Boat fishingBoat){
    if(fishingBoat.boatPath.length > 1){
      if(fishingBoat.boatType == 'sardine'){
        for(Sardine sardine in sardines){
          if((sardine.position.x > fishingBoat.x - fishingBoat.img.width/2 && sardine.position.x < fishingBoat.x + fishingBoat.img.width/2)
              && (sardine.position.y > fishingBoat.y - fishingBoat.img.height/2 && sardine.position.y < fishingBoat.y + fishingBoat.img.height/2) && !sardine.fished){
            num temp = sardine.population;
            fishingBoat.fishCount += temp;
            if(sardine.population > 2){
              sardine.population = temp/2; 
              sardine.fished = true;
              sardine.fishedDelay();
            }
            else{
              toBeRemoved.add(sardine);
            }
          }
        }
      }
      else if(fishingBoat.boatType == 'tuna'){
        for(Tuna tuna in tunas){
          if((tuna.position.x > fishingBoat.x - fishingBoat.img.width/2 && tuna.position.x < fishingBoat.x + fishingBoat.img.width/2)
              && (tuna.position.y > fishingBoat.y && tuna.position.y - fishingBoat.img.height/2< fishingBoat.y + fishingBoat.img.height/2) && !tuna.fished){
            num temp = tuna.population;
            fishingBoat.fishCount += temp;
            if(tuna.population > 2){
              tuna.population = temp/2; 
              tuna.fished = true;
              tuna.fishedDelay();
            }
            else{
              toBeRemoved.add(tuna);
            }
          }
        }
      }
      else if(fishingBoat.boatType == 'shark'){
        for(Shark shark in sharks){
          if((shark.position.x > fishingBoat.x - fishingBoat.img.width/2 && shark.position.x < fishingBoat.x + fishingBoat.img.width/2) 
              && (shark.position.y > fishingBoat.y && shark.position.y - fishingBoat.img.height/2< fishingBoat.y + fishingBoat.img.height/2) && !shark.fished){
            num temp = shark.population;
            fishingBoat.fishCount += temp;
            if(shark.population > 2){
              shark.population = temp/2; 
              shark.fished = true;
              shark.fishedDelay();
            }
            else{
              toBeRemoved.add(shark);
            }
          }
        }
      }
    }
  }
  
}