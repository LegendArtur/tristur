
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart' as Main;

class ChatScreen extends StatefulWidget {
  String _contact;

  ChatScreen(this._contact);

  @override
  State createState() => new ChatScreenState(this._contact);

}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  String _contact;

  ChatScreenState(this._contact);

  @override
  void dispose() {                                                   //new
    for (ChatMessage message in _messages)                           //new
      message.animationController.dispose();                         //new
    super.dispose();                                                 //new
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        title: new Text(_contact ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS
            ? 0.0
            : 4.0,
      ),

      body: Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration: new BoxDecoration(
                    color: Colors.red[300]),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS //new
              ? new BoxDecoration(                                     //new
            border: new Border(                                  //new
              top: new BorderSide(color: Colors.grey[200]),      //new
            ),                                                   //new
          )                                                      //new
              : null),
      backgroundColor: Colors.grey[900],
    );
  }

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  Widget _buildTextComposer() {
    return new IconTheme(data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {          //new
                  setState(() {                     //new
                    _isComposing = text.length > 0; //new
                  });                               //new
                },
                onSubmitted: _handleSubmitted,
                cursorColor: Colors.black,
                decoration: new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),

            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS  //modified
                  ? new CupertinoButton(                                       //new
                child: new Text("Send"),                                 //new
                onPressed: _isComposing                                  //new
                    ? () =>  _handleSubmitted(_textController.text)      //new
                    : null,)
                  : new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text) : null),
            ),
          ],
        ),
      ),
    );
  }
  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                                                    //new
      _isComposing = false;                                          //new
    });
    if (text.trim() != "") {
      ChatMessage message = new ChatMessage(
        text: text,
        animationController: new AnimationController(
            duration: new Duration(milliseconds: 300),
            vsync: this
        ),
      );
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
    }
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(                              //new
          parent: animationController, curve: Curves.bounceOut),      //new
      axisAlignment: 0.0,                                           //new
      child:  new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(Main.currentUser.displayName[0])),

            ),

            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(Main.currentUser.displayName, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text, style: TextStyle(color: Colors.red[300])),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
}