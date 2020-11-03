import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lytatapp/navigation_drawer.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'chat.dart';
import 'model/Chat.dart' as model;
import 'tools/Tools.dart' as tools;


class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: HomeBodyLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // New message/chat
        },
        child: Icon(Icons.messenger, color: Colors.white,),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}


class HomeBodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var builder = StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: new CircularProgressIndicator());
        } else {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          List<model.Chat> chats = documents.map((doc) => model.parseDocument(doc)).toList();
          return _myListView(context, chats);
        }
      },
    );

    return Container(
      child: builder
    );


    //return _myListView(context);
  }
}

class ItemLayout extends StatelessWidget {
  const ItemLayout(
      {Key key, this.onTap, @required this.item, this.selected: false}
      ) : super(key: key);

  final VoidCallback onTap;
  final model.Chat item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle nameStyle = Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w500);
    TextStyle infoStyle = Theme.of(context).textTheme.caption;
    TextStyle messageStyle = item.state == model.ChatStates.normal ? Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey[600]) : Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).accentColor);

    List<Widget> trailingBuilder() {
      List<Widget> builder = [
        Text(item.lastSeen, style: infoStyle),
      ];

      if (item.timeoutStart != null && item.timeoutEnd != null && (item.timeoutEnd?.isAfter(DateTime.now().toUtc()) ?? false)) {
        builder.add(Spacer());
        builder.add(new CircularPercentIndicator(
            radius: 20.0,
            lineWidth: 2.5,
            animation: true,
            percent: item.getProgress(DateTime.now()),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.lightBlue[700],
            backgroundColor: Colors.blueGrey[800],
        ));
      }

      return builder;
    }

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            _createChatRoute(item)
        );
      },
      leading: CustomPaint(
          size: Size(55,55),
          painter: CirclePainter(character: item.name.substring(0,1), color: tools.colorFor(item.name))
      ),
      title: Text(item.name, style: nameStyle, textAlign: TextAlign.left, maxLines: 1,),
      subtitle: Text(item.message, style: messageStyle, textAlign: TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis,),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: trailingBuilder(),
      ),
      isThreeLine: true,
    );
  }
}

Route _createChatRoute(model.Chat chat) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Chat(chat: chat),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context, List<model.Chat> items) {

  /*final List<model.Chat> items = <model.Chat>[
    model.Chat(
        name: "Bob",
        lastSeen: "10:20",
        timeoutStart: DateTime.now().toUtc().subtract(new Duration(minutes: 1)),
        timeoutEnd: DateTime.now().toUtc().add(new Duration(minutes: 2)),
        message: "Let's talk about that."
    ),
    model.Chat(
        name: "Alice",
        lastSeen: "Yesterday",
        message: "Just joined Lytat!",
        state: model.ChatStates.highlighted
    ),
    model.Chat(
        name: "Carlos",
        lastSeen: "May 12",
        timeoutStart: DateTime.now().toUtc().subtract(new Duration(minutes: 5)),
        timeoutEnd: DateTime.now().toUtc().add(new Duration(minutes: 1)),
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed mauris enim, condimentum eget imperdiet id, facilisis vitae velit. Curabitur maximus tincidunt ex euismod rutrum."
    ),
  ];*/

  return new ListView.separated(
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) {
      return Center(child: ItemLayout(item: items[index]));
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, indent: 80, color: Colors.grey,),
  );
}

class CirclePainter extends CustomPainter {
  CirclePainter({@required this.character, @required this.color});

  final Color color;
  final String character;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final offset = Offset(size.width/2, size.width/2);
    canvas.drawCircle(offset, size.width/2, paint);

    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 24), text: character);
    TextPainter textPainter = new TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset(
      (size.width - textPainter.width) * 0.5,
      (size.height - textPainter.height) * 0.5,
    ),);

  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
