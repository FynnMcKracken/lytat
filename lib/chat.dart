import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'model/Chat.dart' as model;


class Chat extends StatefulWidget {
  Chat({Key key, @required this.chat}) : super(key: key);


  final model.Chat chat;


  @override
  State<StatefulWidget> createState() => ChatState(chat: chat);
}

class ChatState extends State<Chat> {
  ChatState({Key key, @required this.chat});
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  model.Chat chat;
  double _currentSliderValue = 2;

  Widget inputWidget() {

    Widget timerWidget() {
      if (chat.timeoutStart != null && chat.timeoutEnd != null && (chat.timeoutEnd?.isAfter(DateTime.now().toUtc()) ?? false)) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 21.0, horizontal: 17.0),
          child: new LinearPercentIndicator(
            alignment: MainAxisAlignment.center,
            lineHeight: 6.0,
            percent: chat.getProgress(DateTime.now()),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.lightBlue[700],
            backgroundColor: Colors.blueGrey[900],
          ),
        );
      } else {
        return Slider(
          value: _currentSliderValue,
          min: 0,
          max: 5,
          divisions: 5,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        );
      }
    }

    return Material(
      type: MaterialType.card,
      borderRadius: BorderRadius.circular(25),
      color: Theme.of(context).primaryColor,
      child: Container(
        child: Column(
          children: <Widget>[
            timerWidget(),
            Row(
              children: <Widget>[
                // Edit text
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Message',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.blueGrey[100].withAlpha(100)),
                      ),
                      focusNode: focusNode,
                    ),
                  ),
                ),

                // Send message button
                IconButton(
                  constraints: BoxConstraints.expand(width: 48, height: 48),
                  icon: Icon(Icons.send),
                  onPressed: () => {
                   /* Fluttertoast.showToast(
                        msg: "This is Center Short Toast",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0)*/
                  },
                  color: Theme.of(context).accentColor,
                ),
              ],
            )
          ]

        ),
        width: double.infinity,
        //height: 102.0,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.chat.name, style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),),
              Text("last seen ${widget.chat.lastSeen}", style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.blueGrey[50]),),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _myListView(context),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: inputWidget(),
            )
          ],
        )
    );
  }

}

enum MessageStates {
  incoming,
  outgoing,
  info
}

class Message {
  const Message({@required this.body, @required this.date, @required this.state});

  final String body;
  final String date;
  final MessageStates state;
}

class ItemLayout extends StatelessWidget {
  const ItemLayout(
      {Key key, this.onTap, @required this.message}
      ) : super(key: key);

  final VoidCallback onTap;
  final Message message;

  Bubble createIncomingBubble(BuildContext context, Message _message) {
    return Bubble(
        elevation: 0.5,
        alignment: Alignment.topLeft,
        margin: BubbleEdges.only(left: 10, right: 60, top: 5, bottom: 5),
        nip: BubbleNip.leftTop,
        color: Colors.blueGrey[800],
        child: Column(
          children: <Widget>[
            Text(_message.body),
            Text(_message.date, textAlign: TextAlign.end, style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10, color: Colors.blueGrey[100].withAlpha(200)),),
          ],
        )
    );
  }

  Bubble createOutgoingBubble(BuildContext context, Message _message) {
    return Bubble(
        elevation: 0.5,
        alignment: Alignment.topRight,
        margin: BubbleEdges.only(left: 60, right: 10, top: 5, bottom: 5),
        nip: BubbleNip.rightTop,
        color: Colors.lightBlue[700],
        child: Column(
          children: <Widget>[
            Text(_message.body),
            Row(
                children: [
                  Spacer(),
                  Text(_message.date, textAlign: TextAlign.end, style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10, color: Colors.blueGrey[100].withAlpha(200)),),
                ]
            )
          ],
        )
    );
  }

  Bubble createInfoBubble(BuildContext context, Message _message) {
    return Bubble(
      elevation: 0.5,
      alignment: Alignment.center,
      margin: BubbleEdges.only(left: 10, top: 5, bottom: 5),
      color: Colors.blueGrey[600],
      child: Text(_message.body, style: TextStyle(color: Colors.grey[300]),),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (message.state == MessageStates.incoming)
      return createIncomingBubble(context, message);
    else if(message.state == MessageStates.outgoing)
      return createOutgoingBubble(context, message);
    else
      return createInfoBubble(context, message);
  }
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context) {

  final List<Message> messages = const <Message>[
    const Message(date: "00:00", state: MessageStates.info, body: "Today",),
    const Message(date: "10:42", state: MessageStates.incoming, body: "foo",),
    const Message(date: "10:43", state: MessageStates.incoming, body: "bar",),
    const Message(date: "10:50", state: MessageStates.incoming, body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ac ultrices magna. Integer porta varius ipsum, scelerisque finibus enim. Aliquam ac elit vel justo sollicitudin porttitor sed vel mi.",),
    const Message(date: "11:24", state: MessageStates.outgoing, body: "Pellentesque malesuada est quis mattis rhoncus. Aenean luctus erat nibh, sit amet viverra massa rutrum eget.",),
    const Message(date: "10:42", state: MessageStates.incoming, body: "foo",),
    const Message(date: "10:43", state: MessageStates.incoming, body: "bar",),
    const Message(date: "10:50", state: MessageStates.incoming, body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ac ultrices magna. Integer porta varius ipsum, scelerisque finibus enim. Aliquam ac elit vel justo sollicitudin porttitor sed vel mi.",),
    const Message(date: "11:24", state: MessageStates.outgoing, body: "Pellentesque malesuada est quis mattis rhoncus. Aenean luctus erat nibh, sit amet viverra massa rutrum eget.",),
    const Message(date: "10:42", state: MessageStates.incoming, body: "foo",),
    const Message(date: "10:43", state: MessageStates.incoming, body: "bar",),
    const Message(date: "10:50", state: MessageStates.incoming, body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ac ultrices magna. Integer porta varius ipsum, scelerisque finibus enim. Aliquam ac elit vel justo sollicitudin porttitor sed vel mi.",),
    const Message(date: "11:24", state: MessageStates.outgoing, body: "Pellentesque malesuada est quis mattis rhoncus. Aenean luctus erat nibh, sit amet viverra massa rutrum eget.",),
    const Message(date: "10:42", state: MessageStates.incoming, body: "foo",),
    const Message(date: "10:43", state: MessageStates.incoming, body: "bar",),
    const Message(date: "10:50", state: MessageStates.incoming, body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ac ultrices magna. Integer porta varius ipsum, scelerisque finibus enim. Aliquam ac elit vel justo sollicitudin porttitor sed vel mi.",),
    const Message(date: "11:24", state: MessageStates.outgoing, body: "Pellentesque malesuada est quis mattis rhoncus. Aenean luctus erat nibh, sit amet viverra massa rutrum eget.",),
  ];

  return ListView.builder(
    itemCount: messages.length,
    itemBuilder: (BuildContext context, int index) {
      return Center(child: ItemLayout(message: messages[index]));
    },
  );
}

class ChatBodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Hello, World!', style: Theme.of(context).textTheme.headline4);
  }

}





