import 'package:flutter/material.dart';

class ToolTile extends StatelessWidget {
  final String name;
  final String route;

  ToolTile({required this.name, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(name, style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
        trailing: Icon(Icons.arrow_forward, color: Colors.greenAccent),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
