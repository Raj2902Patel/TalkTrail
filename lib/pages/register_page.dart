import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talktrail/consts.dart';
import 'package:talktrail/services/alert_services.dart';
import 'package:talktrail/services/auth_service.dart';
import 'package:talktrail/services/media_services.dart';
import 'package:talktrail/services/navigation_services.dart';
import 'package:talktrail/widgets/custom_formfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late AlertService _alertService;

  String? email, password, name;
  File? selectedImage;
  bool _isShow = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
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
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          children: [
            _headerText(),
            if (!_isLoading) _registerForm(),
            if (!_isLoading) _loginAccountLink(),
            if (_isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
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
            "Let's get going!",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Register an account using the form below!",
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

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            _pfpSelectionFiled(),
            SizedBox(
              height: 18,
            ),
            CustomFormField(
              hintText: "eg. John",
              labelText: "Name",
              obscureText: false,
              validationRegEx: NAME_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(
              height: 18,
            ),
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
                      : Icon(Icons.visibility),
                ),
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
              height: 18,
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionFiled() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();

        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.06,
      width: MediaQuery.sizeOf(context).width * 0.35,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          try {
            if ((_registerFormKey.currentState?.validate() ?? false) &&
                selectedImage != null) {
              _registerFormKey.currentState?.save();

              bool result = await _authService.signup(email!, password!);

              if (result) {
                selectedImage = null;
                _alertService.showToast(
                  icon: Icons.verified,
                  text: "Successfully Registered!",
                );
                _navigationService.pushReplacementNamed('/login');
              } else {
                selectedImage = null;
                _alertService.showToast(
                  icon: Icons.error,
                  text: "Email Is Already In Use!",
                );
              }
              print(result);
            }
          } catch (error) {
            print(error);
          }
          setState(() {
            _isLoading = false;
          });
        },
        child: Text(
          "Register",
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
          ),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("Already have an Account? "),
          InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            onTap: () {
              _navigationService.goBack();
            },
            child: Text(
              "Login",
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
