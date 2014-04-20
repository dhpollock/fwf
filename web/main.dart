/*
 * Dart Game Sample Code
 */
library fwf;   // change the library name if you want

import 'dart:html';
import 'dart:math';
import 'dart:async';
//import 'dart:web_audio';
import 'packages/stagexl/stagexl.dart' as stagexl;

part 'dart/boat.dart';
part 'dart/game.dart';
//part 'dart/popover.dart';
//part 'dart/sounds.dart';
part 'dart/touch.dart';
part 'dart/button.dart';
part 'dart/fleet.dart';
part 'dart/phaseTitle.dart';
//part 'dart/phaseBuy.dart';
part 'dart/phaseFish.dart';
//part 'dart/phaseRegrow.dart';
//part 'dart/phaseOver.dart';
part 'dart/agent.dart';
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
  resourceManager.addBitmapData("boatSardineA", "images/boatSardineA.png");
  resourceManager.addBitmapData("boatSardineB", "images/boatSardineB.png");
  resourceManager.addBitmapData("boatTunaA", "images/boatTunaA.png");
  resourceManager.addBitmapData("boatTunaB", "images/boatTunaB.png");
  resourceManager.addBitmapData("boatSharkA", "images/boatSharkA.png");
  resourceManager.addBitmapData("boatSharkB", "images/boatSharkB.png");
  resourceManager.addBitmapData("sardine50Single", "images/sardine50.png");
  resourceManager.addBitmapData("sardine50Few", "images/sardine50few.png");
  resourceManager.addBitmapData("sardine50Many", "images/sardine50many.png");
  resourceManager.addBitmapData("tuna50Single", "images/tuna50.png");
  resourceManager.addBitmapData("tuna50Few", "images/tuna50few.png");
  resourceManager.addBitmapData("tuna50Many", "images/tuna50many.png");
  resourceManager.addBitmapData("shark50Single", "images/shark50.png");
  resourceManager.addBitmapData("shark50Few", "images/shark50few.png");
  resourceManager.addBitmapData("shark50Many", "images/shark50many.png");
  resourceManager.addBitmapData("plankton", "images/plankton.png");
  resourceManager.addBitmapData("netEmpty", "images/netEmpty.png");
  resourceManager.addBitmapData("netSlight", "images/netSlight.png");
  resourceManager.addBitmapData("netHalf", "images/netHalf.png");
  resourceManager.addBitmapData("netFull", "images/netFull.png");

  // load sounds that your game will use (these are in the sounds directory)
//  Sounds.loadSound("drum");
//  Sounds.loadSound("tick");
//  Sounds.loadSound("chimes");
  
  
  // create game object
  resourceManager.load().then((res) {
    game = new Game(resourceManager, stage.juggler, width, height);
    stage.addChild(game);
    stage.juggler.add(game);
  });
}
//
//void repaint() {
//  game.draw();
//}