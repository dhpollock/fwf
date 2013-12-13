/*
 * Dart Game Sample Code
 */
library fwf;   // change the library name if you want

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:web_audio';

part 'boat.dart';
part 'game.dart';
part 'popover.dart';
part 'sounds.dart';
part 'touch.dart';
part 'button.dart';
part 'fleet.dart';
part 'phaseTitle.dart';
part 'phaseBuy.dart';
part 'phaseFish.dart';
part 'phaseSell.dart';
part 'phaseRegrow.dart';
part 'agent.dart';
part 'instructions.dart';
part 'finishButton.dart';



// global game object
Game game;

void main() {
  

  // load sounds that your game will use (these are in the sounds directory)
  Sounds.loadSound("drum");
  Sounds.loadSound("tick");
  Sounds.loadSound("chimes");
  
  // create game object
  game = new Game();
}


void repaint() {
  game.draw();
}