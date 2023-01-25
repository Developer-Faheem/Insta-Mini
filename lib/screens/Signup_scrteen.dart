import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_c/Widgets/textFieldInput.dart';
import 'package:instagram_c/resources/auth_methods.dart';
import 'package:instagram_c/responsive_layouts/responsive_layouts.dart';
import 'package:instagram_c/screens/signin_screen.dart';
import 'package:instagram_c/utils/colors.dart';
import 'package:instagram_c/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController
        .dispose(); //when all of our widgets are build disposal will happen
    usernameController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(
        ImageSource.gallery); //the image has been temporarily stored in storage
    setState(() {
      _image = im;
    });
  }

  void signupUser() async {
    setState(() {
      // when signup button is pressed loading is shown
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        bio: bioController.text,
        file: _image!);

    if (res != 'success') {
      showSnackbar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResponsiveLayouts()));
    }
    setState(() {
      // when signup button is pressed loading is shown
      _isLoading = false;
    });
  }

  void navigateToSignin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SigninScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                SizedBox(
                  height: 70,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                          ),
                    Positioned(
                      left: 80,
                      bottom: -10,
                      child: IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextInputField1(
                    textEditingController: usernameController,
                    textHint: 'Enter your username',
                    isPass: false,
                    textInputType: TextInputType.text),
                SizedBox(
                  height: 30,
                ),
                TextInputField1(
                    textEditingController: emailController,
                    textHint: 'Enter your email',
                    isPass: false,
                    textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 30,
                ),
                TextInputField1(
                    textEditingController: passwordController,
                    textHint: 'Enter your password ',
                    isPass: true,
                    textInputType: TextInputType.text),
                SizedBox(
                  height: 30,
                ),
                TextInputField1(
                    textEditingController: bioController,
                    textHint: 'Enter your bio',
                    isPass: false,
                    textInputType: TextInputType.text),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    signupUser();
                  },
                  child: Container(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Text('Sign Up '),
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    InkWell(
                      onTap: () {
                        navigateToSignin();
                      },
                      child: Text(
                        'login ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
