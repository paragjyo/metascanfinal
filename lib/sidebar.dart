import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'data_list.dart';
import 'main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class SideBar extends StatelessWidget {
  bool isTableExists=false;


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.

        //  Padding(padding: EdgeInsets.all(50)),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Metascan Project Corporation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: const Text('DashBoard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.dataset_outlined),
            title: const Text('Display Data'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Screen1(token: '', isLoggedIn: false)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.format_list_numbered_sharp),
            title: const Text('Forms'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
