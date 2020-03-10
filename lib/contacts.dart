import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'chat.dart';
import 'main.dart' as Main;

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          title: new Text(Main.currentUser.displayName),
        ),
        body: Scrollbar(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("contacts").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                final int userCount = snapshot.data.documents.length;
                return ListView.builder(
                  itemCount: userCount,
                  itemBuilder: (_, int index) {
                    final DocumentSnapshot document = snapshot.data.documents[index];
                    final String user = document['name'];
                    final String email = document.documentID;
                    return ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(child: Text(user[0])),
                      ),
                      title: Text(user),
                      subtitle: Text(email),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen(email)),
                        );
                      },
                    );
                  },
                );
              },
            )
        )

    );
  }
}
