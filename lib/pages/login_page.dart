import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talktrail/consts.dart';
import 'package:talktrail/services/alert_services.dart';
import 'package:talktrail/services/auth_service.dart';
import 'package:talktrail/services/navigation_services.dart';
import 'package:talktrail/widgets/custom_formfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  String? email, password;
  bool _isShow = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            _headerText(),
            _loginForm(),
            _createAnAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi, Welcome Back!",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Hello Again, You've Been Missed!",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            CustomFormField(
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              obscureText: false,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              hintText: "example@gmail.com",
              labelText: 'Email',
            ),
            SizedBox(
              height: 18,
            ),
            CustomFormField(
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    style: IconButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      setState(() {
                        _isShow = !_isShow;
                      });
                    },
                    icon: _isShow
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
              ),
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: _isShow ? false : true,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              hintText: "********",
              labelText: 'Password',
            ),
            SizedBox(
              height: 20,
            ),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.06,
      width: MediaQuery.sizeOf(context).width * 0.35,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            setState(() {
              _isLoading = true;
            });
            bool result = await _authService.login(email!, password!);
            print(result);
            if (result) {
              _navigationService.pushReplacementNamed('/home');
              _alertService.showToast(
                icon: Icons.verified,
                text: "You’re Logged in!",
              );
            } else {
              _alertService.showToast(
                icon: Icons.error,
                text: "Invalid Credentials!",
              );
            }
          }
          setState(() {
            _isLoading = false;
          });
        },
        child: _isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                "Login",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _createAnAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("Don't Have an Account? "),
          InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            onTap: () {
              _navigationService.pushNamed('/register');
            },
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
