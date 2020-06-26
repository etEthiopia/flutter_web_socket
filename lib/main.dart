import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(
          channel: new IOWebSocketChannel.connect("ws://echo.websocket.org")),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({this.channel});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
                child: TextFormField(
              controller: _editingController,
              decoration: InputDecoration(labelText: "Send my Message"),
            )),
            StreamBuilder(
                builder: (context, snapshot) => Padding(
                    padding: EdgeInsets.all(20.0),
                    child:
                        Text(snapshot.hasData ? "${snapshot.data}" : "NULL")),
                stream: widget.channel.stream)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _sendMyMessage, child: Icon(Icons.send)),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMyMessage() {
    if (_editingController.text.isNotEmpty) {
      widget.channel.sink.add(_editingController.text);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
