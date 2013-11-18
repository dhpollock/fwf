/*
 * Dart Game Sample Code
 */
library DartSample;   // change the library name if you want

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


// global game object
Game game;

void main() {
  
  // initialize all popover menus
  initPopovers();
  
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