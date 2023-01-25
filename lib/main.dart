import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_c/provider/user_provider.dart';
import 'package:instagram_c/screens/Signup_scrteen.dart';
import 'package:instagram_c/screens/signin_screen.dart';
import 'package:provider/provider.dart';
import 'responsive_layouts/responsive_layouts.dart';
import 'utils/colors.dart';
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBNPud9KNJd0GWYSkbjQXNGGz0UKUZ97ZY",
          projectId: "instagram-clone-47773",
          messagingSenderId: "220960628927",
          appId: "1:220960628927:web:31953377bf679f24b1e60a",
          storageBucket:
              "instagram-clone-47773.appspot.com" //this is only used when we are to use the cloud firebase storage
          ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'insta clone ',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance
              .authStateChanges(), //tells when the user state(login or logout changes )
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ResponsiveLayouts();
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('some type of error '),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return const SigninScreen(); //when the snapshot has no data
          },
        ),
      ),
    );
  }
}
