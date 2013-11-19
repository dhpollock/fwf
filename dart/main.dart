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
part 'buy.dart';


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