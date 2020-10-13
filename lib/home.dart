import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lytatapp/navigation_drawer.dart';

import 'chat.dart';


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
    );
  }
}


class HomeBodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

enum ItemStates {
  normal,
  highlighted
}

class Item {
  const Item({this.name, this.message, this.date, this.icon, this.state: ItemStates.normal});

  final String name;
  final String message;
  final String date;
  final IconData icon;
  final ItemStates state;
}



class ItemLayout extends StatelessWidget {
  const ItemLayout(
      {Key key, this.onTap, @required this.item, this.selected: false}
      ) : super(key: key);

  final VoidCallback onTap;
  final Item item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle nameStyle = Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w500);
    TextStyle infoStyle = Theme.of(context).textTheme.caption;
    TextStyle messageStyle = item.state == ItemStates.normal ? Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey[600]) : Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).accentColor);
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            _createChatRoute(item)
        );
      },
      leading: CustomPaint(
          size: Size(55,55),
          painter: CirclePainter(character: item.name.substring(0,1), color: Colors.primaries[Random().nextInt(Colors.primaries.length)])
      ),
      title: Text(item.name, style: nameStyle, textAlign: TextAlign.left, maxLines: 1,),
      subtitle: Text(item.message, style: messageStyle, textAlign: TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis,),
      trailing: Text(item.date, style: infoStyle),
      isThreeLine: true,
    );
  }
}

Route _createChatRoute(Item item) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Chat(name: item.name, lastSeen: item.date,),
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
Widget _myListView(BuildContext context) {

  final List<Item> items = const <Item>[
    const Item(name: "Bob", date: "10:20", message: "Let's talk about that.", icon: Icons.ac_unit),
    const Item(name: "Alice", date: "Yesterday", message: "Just joined Lytat!", icon: Icons.access_alarm, state: ItemStates.highlighted),
    const Item(name: "Carlos", date: "May 12", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed mauris enim, condimentum eget imperdiet id, facilisis vitae velit. Curabitur maximus tincidunt ex euismod rutrum.", icon: Icons.account_balance),
  ];

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
