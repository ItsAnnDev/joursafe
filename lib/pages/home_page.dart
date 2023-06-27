import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joursafe/services/auth/auth_service.dart';
import 'package:joursafe/theme.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // instance for auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign user out
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('HomePage'),
      actions: [
        // sign out button
        IconButton(
          onPressed: signOut, 
          icon: const Icon(Icons.logout),
        ),
      ],
    ),
    backgroundColor: Color(0xFFAED3FF),
    body: Container(
      alignment: Alignment.center,
      child: _buildUserList()),
    bottomNavigationBar: Container(
      height: 80, // Adjust the height as per your requirement
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: CupertinoTabBar(
          border: Border(
            top: BorderSide.none, // Hide the top line
          ),
          height: 80, // Adjust the height as per your requirement
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'lib/icons/routes.svg',
                width: 40,
                height: 40,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'lib/icons/reports.svg',
                width: 40,
                height: 40,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'lib/icons/message.svg',
                width: 40,
                height: 40,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'lib/icons/settings.svg',
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}




  // build a list of users except for the current logged-in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading...');
        }

        return ListView(
          children: snapshot.data!.docs
            .map<Widget>((doc) => _buildUserListItem(doc))
            .toList(),
        );
      },
    );
  }

  // build individual users
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Display all users except the current user
    if (_auth.currentUser!.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color to white
            borderRadius: BorderRadius.circular(20), // Set the border radius to 20
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 11,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(data['email']),
              onTap: () {
                // Pass the clicked user's UID to the chat page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverUserEmail: data['email'],
                      receiverUserID: data['uid'],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    } else {
      // Return empty container
      return Container();
    }
  }
}
