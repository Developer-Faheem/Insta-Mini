import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_c/Widgets/textFieldInput.dart';
import 'package:instagram_c/resources/auth_methods.dart';
import 'package:instagram_c/screens/Signup_scrteen.dart';
import 'package:instagram_c/utils/colors.dart';
import 'package:instagram_c/utils/global_variables.dart';
import 'package:instagram_c/utils/utils.dart';
import 'package:instagram_c/responsive_layouts/responsive_layouts.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController
        .dispose(); //when all of our widgets are build disposal will happen
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });

    String res = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res != 'success') {
      showSnackbar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResponsiveLayouts()));
    }

    setState(() {
      _isloading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32.0),
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
                height: 25,
              ),
              InkWell(
                onTap: () {
                  loginUser();
                },
                child: Container(
                  child: _isloading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: primaryColor,
                        ))
                      : const Text('Log in '),
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
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
                      navigateToSignup();
                    },
                    child: Text(
                      'Sign up ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
