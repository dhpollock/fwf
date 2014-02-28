library simple_http_server;

import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory;
import 'dart:convert';

VirtualDirectory virDir;
var id = 0;
final filename = 'data.csv';
List<String> gameData= new List<String>();

handleMsg(msg) {
  
  if(msg == 'connected'){
    print('Message received: $msg');
  }
  else if(msg == 'newgame'){
    print('Message received: $msg');
    gameData.clear();
    getID();
  }
  else if(msg == 'outcome:win'){
    var file = new File(filename);
    var sink = file.openWrite(mode: FileMode.APPEND);
    for(String data in gameData){
      print(data[0]);
      sink.write('${id},${data},1\n');
    }
    
  // Close the IOSink to free system resources.
    sink.close();
  }
  else if(msg == 'outcome:loss'){
    var file = new File(filename);
    var sink = file.openWrite(mode: FileMode.APPEND);
    for(String data in gameData){
      sink.write('${id},${data},0\n');
    }
    
  // Close the IOSink to free system resources.
  sink.close();
  }
  else{
    print(msg);
    gameData.add('${msg}');
  }
}


num getID(){
  print('before error?');
  var file = new File(filename);
  num temp;
  String last;
  file.readAsLines().then((List<String> lines){
    last = lines[lines.length-1];
    var splitLast = last.split(',');
    temp = num.parse(splitLast[0]);
    id = temp+1;
    print('id: ${id}');

  });

}

void directoryHandler(dir, request) {
  print('ehre');
  var indexUri = new Uri.file(dir.path).resolve('index.html');
  virDir.serveFile(new File(indexUri.toFilePath()), request);
}

void main() {
  virDir = new VirtualDirectory(Platform.script.resolve('./../../..').toFilePath())
    ..allowDirectoryListing = true
    ..directoryHandler = directoryHandler;

  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
    server.listen((request) {
      virDir.serveRequest(request);
    });
  });
  
  runZoned(() {
    HttpServer.bind('127.0.0.1', 4040).then((server) {
      server.listen((HttpRequest req) {
        if (req.uri.path == '/ws') {
          // Upgrade a HttpRequest to a WebSocket connection.
          WebSocketTransformer.upgrade(req).then((socket) {
            socket.listen(handleMsg);
          });
        }
      });
    });
  },
  onError: (e) => print(e));
  
}