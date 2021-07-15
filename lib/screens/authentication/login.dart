import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/screens/authentication/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailCt = TextEditingController();
  TextEditingController _passwordCt = TextEditingController();

  FocusNode _emailFc = FocusNode();
  FocusNode _passwordFc = FocusNode();

  final _formKey = GlobalKey<FormState>();

  AuthService? _auth;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    _auth = Provider.of<AuthService>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: _size.height,
          width: _size.width,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(8),
          color: Color(0xffEAEFF7),
          child: Material(
            elevation: 30,
            borderRadius: BorderRadius.circular(40),
            child: SingleChildScrollView(
              child: Container(
                height: _size.height * 0.693,
                width: _size.width,
                padding: EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: Color(0xff192A4D),
                          ),
                        ),
                        SizedBox(height: 40),
                        _getTextField(
                          controller: _emailCt,
                          focusNode: _emailFc,
                          nextFocusNode: _passwordFc,
                          label: "Email ID",
                          icon: Icons.alternate_email,
                          validator: _emailValidator,
                        ),
                        SizedBox(height: 20),
                        _getTextField(
                          controller: _passwordCt,
                          focusNode: _passwordFc,
                          label: "Password",
                          icon: Icons.password_outlined,
                          obscureText: true,
                          validator: _passwordValidator,
                        ),
                        SizedBox(height: 30),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: MaterialButton(
                            onPressed: _login,
                            minWidth: double.infinity,
                            height: 55,
                            color: Color(0xff0165FF),
                            child: (_auth?.isLoading ?? false)
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "or, login with ",
                              style: TextStyle(
                                  color: Color(0xffA0A8B6), fontSize: 15.5),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () async {
                                await _auth!.signInWithGoogle();
                              },
                              child: Image.asset(
                                "assets/icons/google_icon.png",
                                height: 40,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not a member?",
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: _goToSignUp,
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color(0xff0165FF),
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      await _auth!
          .loginUserWithEmailAndPassword(_emailCt.text, _passwordCt.text);
    }
  }

  String? _emailValidator(String? val) {
    val = val!.trim();
    val = val.trimLeft();
    val = val.trimRight();
    if (val.isEmpty) return "Please enter an email";

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(val)) return "Email is invalid";

    return null;
  }

  String? _passwordValidator(String? val) {
    val = val!.trim();
    if (val.isEmpty) return "Please enter a password";

    if (val.length < 8) return "Password should contain atleast 8 characters";

    return null;
  }

  _goToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }

  _getTextField({
    required TextEditingController controller,
    required focusNode,
    required String label,
    required IconData icon,
    FocusNode? nextFocusNode,
    bool obscureText: false,
    required String? validator(String? val),
  }) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.red),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        validator: validator,
        onEditingComplete: (nextFocusNode == null)
            ? () => focusNode.unfocus()
            : () => nextFocusNode.requestFocus(),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        textInputAction: (nextFocusNode == null)
            ? TextInputAction.done
            : TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: Color(0xffA0A8B6),
            ),
          ),
          prefixIcon: Container(
            margin: EdgeInsets.only(right: 18),
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.only(bottom: 15, left: 10),
          labelStyle: TextStyle(fontSize: 17.5, color: Color(0xffA0A8B6)),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
