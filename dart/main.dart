/*
 * Dart Game Sample Code
 */
library fwf;   // change the library name if you want

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:web_audio';
//import 'dart:io';
//import 'dart:convert';

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
//part 'phaseSell.dart';
part 'phaseRegrow.dart';
part 'phaseOver.dart';
part 'agent.dart';
part 'instructions.dart';
part 'finishButton.dart';



// global game object
Game game;
WebSocket ws;

outputMsg(String msg) {
  
  print(msg);
//  var output = query('#output');
//  var text = msg;
//  if (!output.text.isEmpty) {
//    text = "${output.text}\n${text}";
//  }
//  output.text = text;
}

void initWebSocket([int retrySeconds = 2]) {
  var reconnectScheduled = false;

  outputMsg("Connecting to websocket");
  ws = new WebSocket('ws://127.0.0.1:4040/ws');

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    outputMsg('Connected');
    ws.send('connected');
  });

  ws.onClose.listen((e) {
    outputMsg('Websocket closed, retrying in $retrySeconds seconds');
    scheduleReconnect();
  });

  ws.onError.listen((e) {
    outputMsg("Error connecting to ws");
    scheduleReconnect();
  });

  ws.onMessage.listen((MessageEvent e) {
    outputMsg('Received message: ${e.data}');
  });
}


void main() {
 

  // load sounds that your game will use (these are in the sounds directory)
  Sounds.loadSound("drum");
  Sounds.loadSound("tick");
  Sounds.loadSound("chimes");
  
  // create game object
  game = new Game();
  
  initWebSocket();
}

void repaint() {
  game.draw();
}