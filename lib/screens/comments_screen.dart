import 'package:flutter/material.dart';
import 'package:instagram_c/resources/firestore_methods.dart';
import 'package:instagram_c/utils/colors.dart';
import 'package:instagram_c/Widgets/CommentCard.dart';
import 'package:instagram_c/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_c/models/user_model.dart';
import 'package:instagram_c/resources/auth_methods.dart';
import 'package:instagram_c/utils/global_variables.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final model.User user = Provider.of<UserProvider>(context).getUser;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser!;

    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    //print(userProvider.getUser.photoUrl);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
      ),
      body: CommentCard(),
      bottomNavigationBar: SafeArea(
        child: Container(
          // height: KToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    //  userProvider.getUser.photoUrl.toString()),
                    //   'https://pixlr.com/images/index/remove-bg.webp'),
                    currentUser.photoURL.toString()),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${currentUser.email}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FireStoreMethods().postComment(
                      widget.snap['postId'],
                      _commentController.text,
                      currentUser.uid,
                      currentUser.email.toString(),
                      currentUser.photoURL.toString());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
