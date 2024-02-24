import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ulms/screens/home.dart';
import '../custom_widget/theme_helper.dart';
import '../services/constant.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: isLoading
          ? ThemeHelper().progressBar()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // CircleAvatar(),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                      child: TextFormField(
                                        controller: _emailTextController,
                                        decoration: ThemeHelper()
                                            .textInputDecoration("Staff ID",
                                                "Enter your Staff ID"),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        keyboardType: TextInputType.text,
                                        validator: (val) {
                                          // ignore: prefer_is_not_empty
                                          if ((val!.isEmpty)) {
                                            return "Enter correct Staff ID";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 30.0),
                                    Container(
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                      child: TextFormField(
                                        controller: _passwordTextController,
                                        //obscureText: true,
                                        decoration: ThemeHelper()
                                            .textInputDecoration("Password*",
                                                "Enter your password"),
                                        style: const TextStyle(
                                            color: Colors.black),

                                        obscureText: true,
                                        // ignore: missing_return
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Password is required";
                                          } else if (value.length < 6) {
                                            return "the password has to be at least 6 characters long";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      // trailing: IconButton(
                                      //     color: Colors.purple,
                                      //     icon: const Icon(
                                      //       Icons.remove_red_eye,
                                      //     ),
                                      //     onPressed: () {
                                      //       if (hidePass) {
                                      //         setState(() {
                                      //           hidePass = false;
                                      //         });
                                      //       } else {
                                      //         setState(() {
                                      //           hidePass = true;
                                      //         });
                                      //       }
                                      //     })
                                    ),
                                    const SizedBox(height: 30.0),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 10),
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Get.to(ForgotPassword());
                                        },
                                        child: const Text(
                                          "Forgot your password?",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: ThemeHelper()
                                          .buttonBoxDecoration(context),
                                      child: ElevatedButton(
                                        style: ThemeHelper().buttonStyle(),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Text(
                                            'Sign In'.toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          // String school = "";
                                          // Constants
                                          //         .getUserSchoolSharedPreference()
                                          //     .then((value) {
                                          //   setState(() {
                                          //     school = value!;
                                          //   });
                                          // });
                                          // print(school);
                                          userLogin();
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    Container(
                                      // margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      alignment: Alignment.bottomCenter,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Get.to(ForgotPassword());
                                        },
                                        child: const Text(
                                          "Powered by: UniApp",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future userLogin() async {
    FormState? formState = _formKey.currentState;
    // Getting value from Controller
    String email = _emailTextController.text;
    String password = _passwordTextController.text;
    // Store all data with Param Name.
    var data = {
      'email': email,
      'password': password,
    };

    if (formState!.validate()) {
      // Showing CircularProgressIndicator.
      setState(() {
        isLoading = true;
      });
      // String school = Constants.getUserSchoolSharedPreference().toString();
      // SERVER LOGIN API URL
      var url = "https://uniappdigitalsoluttions.com.ng/api/lecturer/login";
      Dio dio = Dio();
      var response = await dio.post(
        url,
        data: data,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }),
      );
      var result = response.data;
      // print(result);
      var message = result["access_token"];
      var type = result["type"];
      var role = result["role"][0];

      if (message != null) {
        Constants.saveUserTokenKeyInSharedPreference(message);
        setState(() {
          // token = message;
          Constants.saveUserLoggedInSharedPreference(true);
          Constants.savegetUserRoleSharedPreference(role);
          Constants.savegUserTypeSharedPreference(type);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MyHomePage(),
          ));
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Showing Alert Dialog with Response JSON Message.
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: Border(),
              title: new Text(
                response.data['info'],
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 20.00,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
