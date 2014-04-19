/*
 * Dart Game Sample Code
 */
library fwf;   // change the library name if you want

import 'dart:html';
import 'dart:math';
//import 'dart:async';
//import 'dart:web_audio';
import 'packages/stagexl/stagexl.dart' as stagexl;

part 'dart/boat.dart';
part 'dart/game.dart';
//part 'dart/popover.dart';
//part 'dart/sounds.dart';
part 'dart/touch.dart';
part 'dart/button.dart';
//part 'dart/fleet.dart';
part 'dart/phaseTitle.dart';
//part 'dart/phaseBuy.dart';
part 'dart/phaseFish.dart';
//part 'dart/phaseRegrow.dart';
//part 'dart/phaseOver.dart';
//part 'dart/agent.dart';
//part 'dart/instructions.dart';
//part 'dart/finishButton.dart';



// global game object
Game game;


void main() {
  
  int height = window.innerHeight-20;
  int width = window.innerWidth;
  
  var canvas = querySelector('#game');
  canvas.width = width;
  canvas.height = height;
  
  var stage = new stagexl.Stage(canvas);
  var renderLoop = new stagexl.RenderLoop();
  renderLoop.addStage(stage);

  var resourceManager = new stagexl.ResourceManager();
  resourceManager.addBitmapData("background", "images/background.png");
  resourceManager.addBitmapData("title", "images/title.png");
  resourceManager.addBitmapData("boatsardineA", "images/boatsardineA.png");

  // load sounds that your game will use (these are in the sounds directory)
//  Sounds.loadSound("drum");
//  Sounds.loadSound("tick");
//  Sounds.loadSound("chimes");
  
  
  // create game object
  resourceManager.load().then((res) {
    game = new Game(resourceManager, width, height);
    stage.addChild(game);
    stage.juggler.add(game);
  });
}
//
//void repaint() {
//  game.draw();
//}