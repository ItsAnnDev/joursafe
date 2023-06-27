import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joursafe/components/chat_bubble.dart';
import 'package:joursafe/services/chat/chat_service.dart';
import 'package:joursafe/theme.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key, 
    required this.receiverUserEmail, 
    required this.receiverUserID
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID, _messageController.text);
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: SvgPicture.asset(
                'lib/icons/chat-background.svg',
                fit: BoxFit.none,
              ),
            ),
          ),
          Column(
            children: [
              // messages
              Expanded(
                child: _buildMessageList(),
              ),

              // user input
              _buildMessageInput(),

              const SizedBox(height: 25),
            ],
          ),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid, _firebaseAuth.currentUser!.uid),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('loading');
      }

      return ListView(
        children: snapshot.data!.docs
          .map((document) => _buildMessageItem(document))
          .toList(),
        );
      },
    );
  }

  // build message item
Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  final bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.uid;
  CrossAxisAlignment crossAlignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  MainAxisAlignment mainAlignment = isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start;

  return Container(
    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: crossAlignment,
        mainAxisAlignment: mainAlignment,
        children: [
          Text(data['senderEmail']),
          const SizedBox(height: 5),
          ChatBubble(
            message: data['message'],
            isCurrentUserMessage: isCurrentUser,
          ),
        ],
      ),
    ),
  );
}



  // build message input
Widget _buildMessageInput() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: _messageController,
            obscureText: false,
            style: normalSize.copyWith(fontSize: 14),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Escribe tu mensaje',
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),
          Positioned(
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: sendMessage,
                child: SvgPicture.asset(
                  'lib/icons/send.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}