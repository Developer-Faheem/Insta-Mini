import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_c/resources/auth_methods.dart';
import 'package:instagram_c/resources/firestore_methods.dart';
import 'package:instagram_c/screens/signin_screen.dart';
import 'package:instagram_c/utils/colors.dart';
import 'package:instagram_c/utils/utils.dart';
import 'package:instagram_c/Widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  // final String uid;
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int followers = 0;
  int postLen = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  getData(var uid) async {
    // setState(() {
    //   isLoading = false;
    // });
    try {
      //   final UserProvider userProvider = Provider.of<UserProvider>(context);

      print('this is the uid -------------------------------------------');
      print(uid);

      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userData = userSnap.data()!;

      print("++++++++++++++++++++${userSnap}");

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['followers'].length;
      isFollowing = userSnap.data()!['followers'].contain(uid);
      print(isFollowing);
      setState(() {});
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User currentUser = _auth.currentUser!;

    getData(currentUser.uid);
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(currentUser.email.toString()),
              //   userData['bio'] == null ? 'null' : 'not null'),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: //NetworkImage(
                                // userData['photoUrl'].toString()
                                NetworkImage(//currentUser.photoURL.toString()
                                    'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-person-icon.png'),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "Posts"),
                                    buildStatColumn(followers, "Followers"),
                                    buildStatColumn(following, "Following")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            currentUser.uid
                                        ? Expanded(
                                            child: FollowButton(
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              borderColor: Colors.grey,
                                              text: 'Sign out',
                                              textColor: primaryColor,
                                              function: () async {
                                                await AuthMethods().signOut();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const SigninScreen()));
                                              },
                                            ),
                                          )
                                        : isFollowing
                                            ? Expanded(
                                                child: FollowButton(
                                                  backgroundColor: Colors.white,
                                                  borderColor: Colors.grey,
                                                  text: 'Unfollow',
                                                  textColor: Colors.black,
                                                  function: () {},
                                                ),
                                              )
                                            : Expanded(
                                                child: FollowButton(
                                                  backgroundColor: Colors.blue,
                                                  borderColor: Colors.blue,
                                                  text: 'Follow',
                                                  textColor: Colors.white,
                                                  function: () {},
                                                ),
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          currentUser.email.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text('jack of non'
                            // 'some description',
                            ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: currentUser.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

//
// class ProfileScreen extends StatefulWidget {
//   // final String uid;
//   const ProfileScreen({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   // var userData = {};
//   // int postLen = 0;
//   // int followers = 0;
//   // int following = 0;
//   // bool isFollowing = false;
//   // bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // getData();
//   }
//
//   // getData() async {
//   //   print(widget.uid);
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   try {
//   //     var userSnap = await FirebaseFirestore.instance
//   //         .collection('users')
//   //         .doc(widget.uid)
//   //         .get();
//   //
//   //     // get post lENGTH
//   //     var postSnap = await FirebaseFirestore.instance
//   //         .collection('posts')
//   //         .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//   //         .get();
//   //
//   //     postLen = postSnap.docs.length;
//   //     userData = userSnap.data()!;
//   //     followers = userSnap.data()!['followers'].length;
//   //     following = userSnap.data()!['following'].length;
//   //     isFollowing = userSnap
//   //         .data()!['followers']
//   //         .contains(FirebaseAuth.instance.currentUser!.uid);
//   //     setState(() {});
//   //   } catch (e) {
//   //     showSnackbar(
//   //       e.toString(),
//   //       context,
//   //     );
//   //   }
//   //   setState(() {
//   //     isLoading = false;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//         // isLoading
//         //   ? const Center(
//         //       child: CircularProgressIndicator(),
//         //     )
//         //   :
//         Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: Text(
//             //  userData['username'],
//             'else'),
//         centerTitle: false,
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.grey,
//                       backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbnhvB5mOyuyQ-a4R980CZEsNCJakr_ye-n0Mvqsb8SA&s'
//                           // userData['photoUrl'],
//                           ),
//                       radius: 40,
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               // buildStatColumn(postLen, "posts"),
//                               // buildStatColumn(followers, "followers"),
//                               // buildStatColumn(following, "following"),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               // FirebaseAuth.instance.currentUser!.uid ==
//                               //         widget.uid
//                               //     ?
//                               FollowButton(
//                                       text: 'Sign Out',
//                                       backgroundColor: mobileBackgroundColor,
//                                       textColor: primaryColor,
//                                       borderColor: Colors.grey,
//                                       function: () async {
//                                         await AuthMethods().signOut();
//                                         Navigator.of(context).pushReplacement(
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const SigninScreen(),
//                                           ),
//                                         );
//                                       },
//                                     )
//                                   // : isFollowing
//                                   //     ?
//                               // FollowButton(
//                               //             text: 'Unfollow',
//                               //             backgroundColor: Colors.white,
//                               //             textColor: Colors.black,
//                               //             borderColor: Colors.grey,
//                               //             function: () {}
//                                           //     () async {
//                                           //   await FireStoreMethods()
//                                           //       .followUser(
//                                           //     FirebaseAuth.instance
//                                           //         .currentUser!.uid,
//                                           //     userData['uid'],
//                                           //   );
//                                           //
//                                           //   setState(() {
//                                           //     isFollowing = false;
//                                           //     followers--;
//                                           //   });
//                                           // },
//                                       //     )
//                                       // : FollowButton(
//                                       //     text: 'Follow',
//                                       //     backgroundColor: Colors.blue,
//                                       //     textColor: Colors.white,
//                                       //     borderColor: Colors.blue,
//                                       //     function: () {}
//                                           //     () async {
//                                           //   await FireStoreMethods()
//                                           //       .followUser(
//                                           //     FirebaseAuth.instance
//                                           //         .currentUser!.uid,
//                                           //     userData['uid'],
//                                           //   );
//                                           //
//                                           //   setState(() {
//                                           //     isFollowing = true;
//                                           //     followers++;
//                                           //   });
//                                           // },
//                                           )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.only(
//                     top: 15,
//                   ),
//                   child: Text(
//                     userData['username'],
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.only(
//                     top: 1,
//                   ),
//                   child: Text(
//                     userData['bio'],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//
//         ],
//       ),
//     );
//   }
//
//   Column buildStatColumn(int num, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           num.toString(),
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 4),
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
