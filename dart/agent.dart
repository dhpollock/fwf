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
  
  //nearest agent of food or pred type
  Agent nearest;
  
  AgentManager manager;
  
  /* random number generator */
  Random random = new Random();
  
  
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
      case 'AVOID':
        if(predType != null){
          if(!manager.findNearest(predType, this)){
            if(nearest != null){
              heading = atan2((nearest.position.y - position.y), (nearest.position.x - position.x))+ PI;
              forward(speed);
            }
          }
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
    if(dist > speed){
      forward(speed);
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
        if(population == 0 ){
          if(nearest != null){
            if(nearest.type == foodType){
              nearest.ate = false;
            }
          }
          //removig agent from the ecosystem, must be added to remove queue instead of direct removal
          manager.toBeRemoved.add(this);
        }
      }
      if(population > split){
        population = split/2;
        manager.toBeAdded.add(this);
      }
    }
    energyCounter++;
  }
  
  void ateDelay(){
    new Timer(const Duration(seconds : 2), () {
        ate = false;
    });
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
  }
  
  void draw(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'black';
    ctx.fillRect(position.x, position.y, 5, 5);
  }
  
}

//Sardine Agent Class... sets variables and draw function
class Sardine extends Agent{
  
  Sardine(AgentManager newManager,num newX, num newY){
    position = new Point(newX, newY);

    energy = 2;
    energyCounter = 0;
    heading = 0;
    speed = 5;
    population = 5;
    type = 'sardine';
    foodType = 'plankton';
    predType = 'tuna';
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    hunger = 3;
    split = 10;
    energyThreshold = 32;
  }
  
  void draw(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'green';
    ctx.fillRect(position.x, position.y, 10 + population, 10 + population);
  }
  
}

//Tuna Agent Class... sets variables and draw function
class Tuna extends Agent{
  Tuna(AgentManager newManager,num newX, num newY){
    position = new Point(newX, newY);
    energy = 2;
    energyCounter = 0;
    population = 10;
    speed = 5.5;
    type = 'tuna';
    foodType = 'sardine';
    predType = 'shark';
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    split = 20;
    hunger = 5;
    energyThreshold = 36;
  }
  
  void draw(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'red';
    ctx.fillRect(position.x, position.y, 15 + population, 15 + population);
  }

}

//Shark Agent Class... sets variables and draw function
class Shark extends Agent{
  Shark(AgentManager newManager,num newX, num newY){
    position = new Point(newX, newY);
    energy = 2;
    energyCounter = 0;
    population = 10; 
    speed = 5.75;
    type = 'shark';
    foodType = 'tuna';
    manager = newManager;
    mode = 'FOOD';
    ate = false;
    split = 20;
    hunger = 5;
    energyThreshold = 20;
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
  
  //Constructor, setting initial number of each agent type
  AgentManager(num startPCount,num startSaCount,num startTCount, num startSCount, num newWidth, num newHeight){
    width = newWidth;
    height = newHeight;
    
    planktonTimer = 0;
    
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
            Sardine temp = new Sardine(this, x, y);
            sardines.add(temp);
          }
          if(type == 'tuna'){
            Tuna temp = new Tuna(this, x, y);
            tunas.add(temp);
          }
          if(type == 'shark'){
            Shark temp = new Shark(this, x, y);
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
          var dist = pow((plankton.position.x - parent.position.x), 2) + pow((plankton.position.y - parent.position.y), 2);
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

          var dist = pow((sardine.position.x -parent.position.x), 2) + pow((sardine.position.y - parent.position.y), 2);
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

          var dist = pow((tuna.position.x - parent.position.x), 2) + pow((tuna.position.y - parent.position.y), 2);
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

          var dist = pow((shark.position.x -parent.position.x), 2) + pow((shark.position.y - parent.position.y), 2);
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
      Sardine temp = new Sardine(this, x, y);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      sardines.add(temp);
    }
    if(type == 'tuna'){
      Tuna temp = new Tuna(this, x, y);
      if(location != null){
        temp.position.x = location.x;
        temp.position.y = location.y;
      }
      tunas.add(temp);
    }
    if(type == 'shark'){
      Shark temp = new Shark(this, x, y);
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
    
    if(planktonTimer > 1){
      addAgent('plankton');
      addAgent('plankton');
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
    
    print("${planktons.length}, ${sardines.length}, ${tunas.length}, ${sharks.length}");
    planktonTimer++;
  }
  
}