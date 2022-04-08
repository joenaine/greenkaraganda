import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashpick/Pages/OnAppStart/sign_in_page.dart';
import 'package:trashpick/Pages/OnAppStart/user_guide.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_guide_page.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_page.dart';
import '../../Widgets/toast_messages.dart';
import '../../Theme/theme_provider.dart';
import '../../Widgets/button_widgets.dart';

class SignUpPage extends StatefulWidget {
/*  SignUpPage({Key key, this.title}) : super(key: key);
  final String title;*/
  SignUpPage({this.app});

  final FirebaseApp app;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ToastMessages _toastMessages = new ToastMessages();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String defaultUserAvatar =
      "https://firebasestorage.googleapis.com/v0/b/greeeeeeen-1a869.appspot.com/o/WhatsApp%20Image%202022-04-08%20at%2003.33.25.jpeg?alt=media&token=1a04dd81-c196-405f-822d-ce9c35e246f2";

  bool _isHidden = true;
  bool _isHiddenC = true;

  double circularProgressVal;
  bool isUserCreated = false;
  bool isAnError = false;

  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());

  String accountTypeName = "Trash Picker";
  int accountTypeID;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHiddenC = !_isHiddenC;
    });
  }

  bool validateUser() {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (nameController.text.isEmpty &&
        emailController.text.isEmpty &&
        phoneNumberController.text.isEmpty &&
        homeAddressController.text.isEmpty &&
        passwordController.text.isEmpty &&
        confirmPasswordController.text.isEmpty) {
      _toastMessages.toastInfo('Заполните все поля', context);
    } else if (nameController.text.isEmpty) {
      _toastMessages.toastInfo('Введите имя', context);
    } else if (emailController.text.isEmpty) {
      _toastMessages.toastInfo('Введите email', context);
    } else if (!regExp.hasMatch(emailController.text)) {
      _toastMessages.toastInfo('Неправильный Email', context);
    } else if (phoneNumberController.text.isEmpty) {
      _toastMessages.toastInfo('Введите номер телефона', context);
    } else if (homeAddressController.text.isEmpty) {
      _toastMessages.toastInfo('Введите Адресс', context);
    } else if (passwordController.text.length < 6) {
      _toastMessages.toastInfo(
          'Пароль должен быть больше , символов!', context);
    } else if (passwordController.text.isEmpty) {
      _toastMessages.toastInfo('Введите пароль', context);
    } else if (confirmPasswordController.text != passwordController.text) {
      _toastMessages.toastInfo('Пароли не совпадают', context);
    } else {
      print('Validation Success!');
      return true;
    }

    return false;
  }

  showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: !isUserCreated
                  ? Center(child: Text("Создание аккаунта"))
                  : Center(child: Text("Аккаунт создан")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUserCreated)
                    !isAnError
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              CircularProgressIndicator(
                                value: circularProgressVal,
                                strokeWidth: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppThemeData().primaryColor),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                  "" +
                                      nameController.text +
                                      "Подождите, пока мы создадим вашу учетную запись!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Container(
                            child: Column(
                            children: [
                              Text("Ошибка!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                              new ButtonWidget(
                                  text: "Повторите еще раз",
                                  textColor: AppThemeData().whiteColor,
                                  color: AppThemeData().redColor,
                                  onClicked: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                          ))
                  else
                    Container(
                        child: Column(
                      children: [
                        Text("Добро пожаловать!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(
                          height: 50.0,
                        ),
                        Image.asset(
                          'assets/images/welcome.png',
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        new ButtonWidget(
                            text: "Continue",
                            textColor: AppThemeData().whiteColor,
                            color: AppThemeData().primaryColor,
                            onClicked: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeGuidePage(
                                          nameController.text.toString(),
                                          accountTypeName)),
                                  ModalRoute.withName("/WelcomeScreen"));
                            }),
                      ],
                    )),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            );
          },
        );
      },
    );
  }

  void ifAnError() {
    Navigator.pop(context);
    setState(() {
      isUserCreated = false;
      isAnError = true;
      //Navigator.pop(context);
      showAlertDialog(context);
    });
  }

  void printSignUpData() {
    print("ACCOUNT TYPE: " + "$accountTypeName");
    print("NAME: " + nameController.text.toString());
    print("EMAIL: " + emailController.text.toString());
    print("CONTACT NUMBER: " + phoneNumberController.text.toString());
    print("HOME ADDRESS: " + homeAddressController.text.toString());
    print("PASSWORD: " + passwordController.text.toString());
    print("CONFIRM PASSWORD: " + confirmPasswordController.text.toString());
  }

  void authenticateUser() async {
    showAlertDialog(context);

    setState(() {
      isUserCreated = false;
      isAnError = false;
    });

    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (FirebaseAuth.instance.currentUser.uid != null) {
        print('User Account Authenticated!');

        User user = FirebaseAuth.instance.currentUser;

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          print('Verification Email Send!');
        }
        try {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser.uid.toString())
              .set({
            "uuid": FirebaseAuth.instance.currentUser.uid.toString(),
            "accountType": "$accountTypeName",
            "name": nameController.text,
            "email": emailController.text,
            "contactNumber": phoneNumberController.text,
            "homeAddress": homeAddressController.text,
            'password': passwordController.text,
            'appearedLocation': new GeoPoint(7.8731, 80.7718),
            'lastAppeared': "Not Set",
            'accountCreated': "$formattedDate, $formattedTime",
            'profileImage': "$defaultUserAvatar",
          }).then((value) {
            print("User Added to Firestore success");
            Navigator.pop(context);
            setState(() {
              isUserCreated = true;
              isAnError = false;
              showAlertDialog(context);
            });
          });
        } catch (e) {
          print("Failed to Add User to Firestore!: $e");
          ifAnError();
        }
      } else {
        print('Failed to User Account Authenticated!');
        ifAnError();
      }
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          "[firebase_auth/email-already-in-use] Адрес электронной почты уже используется другим аккаунтом..") {
        ifAnError();
        new ToastMessages().toastError(
            "Адрес электронной почты уже используется другим аккаунтом.",
            context);
      } else {
        ifAnError();
        print(e.toString());
      }
    }
  }

  radioButtonList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Выберите тип аккаунта",
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline6.fontSize,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: accountTypeID,
              onChanged: (val) {
                setState(() {
                  accountTypeName = 'Trash Picker';
                  accountTypeID = 1;
                });
              },
            ),
            Text(
              'Пользователь',
              style: new TextStyle(fontSize: 17.0),
            ),
            Radio(
              value: 2,
              groupValue: accountTypeID,
              onChanged: (val) {
                setState(() {
                  accountTypeName = 'Trash Collector';
                  accountTypeID = 2;
                });
              },
            ),
            Text(
              'Сборщик сырья',
              style: new TextStyle(
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("test");
        return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserGuidePage()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: AppThemeData().whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              icon: Icon(Icons.arrow_back_ios_rounded),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserGuidePage()),
                                  (Route<dynamic> route) => false,
                                );
                              })),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logos/trashpick_logo_banner.png',
                            height: 120,
                            width: 120,
                          ),
                          SizedBox(width: 10),
                          Text("Форма регистраций",
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .fontSize,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      SizedBox(height: 20),
                      radioButtonList(),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Icon(Icons.account_circle_outlined),
                                border: OutlineInputBorder(),
                                labelText: 'Имя',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Icon(Icons.phone_android_rounded),
                                border: OutlineInputBorder(),
                                labelText: 'Номер телефона',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: homeAddressController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.home_rounded),
                                border: OutlineInputBorder(),
                                labelText: 'Адресс',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              obscureText: _isHidden,
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                                border: OutlineInputBorder(),
                                labelText: 'Пароль',
                                suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              obscureText: _isHiddenC,
                              controller: confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                                border: OutlineInputBorder(),
                                labelText: 'Подтвердите пароль',
                                suffix: InkWell(
                                  onTap: _toggleConfirmPasswordView,
                                  child: Icon(
                                    _isHiddenC
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      new ButtonWidget(
                        textColor: AppThemeData().whiteColor,
                        color: AppThemeData().secondaryColor,
                        text: "Зарегестрироваться",
                        onClicked: () {
                          if (validateUser()) {
                            printSignUpData();
                            authenticateUser();
                          } else {
                            /*_toastMessages.toastInfo(
                                'Try again with correct details!');*/
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Новый пользователь ?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(width: 10),
                            new RadiusFlatButtonWidget(
                              text: "Войти",
                              onClicked: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInPage()),
                                  (Route<dynamic> route) => false,
                                );
                                print("Switch to Sign In");
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ))),
        ),
      ),
    );
  }
}
