import 'package:flutter/material.dart';
import 'package:lytatapp/home.dart';

import 'chat.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home(title: 'Lytat'))
              );
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat(name: 'Chats', lastSeen: "Yesterday",))
              );
            },
          ),
        ],
      ),
    );
  }
}