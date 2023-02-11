import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
   final greyBDBDBD = Color(0xFFBDBDBD);
   final grey333333 = Color(0xFF333333);
   final orangeMain = Color(0xFFFF8139);
   final backGround = Color(0xff1E1E20);
  final _formSignInKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 117,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello",
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "LogIn",
                    style: Theme.of(context)
                        .textTheme
                        .headline6?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 107,
            ),
            Form(
              key: _formSignInKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// email input field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle:  TextStyle(
                              fontSize: 16,
                              color: greyBDBDBD,
                            ),
                            enabledBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(color: grey333333),
                            ),
                            focusedBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(color: grey333333),
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            )
                          ),
                          validator: (value){
                            print("from validator");
                            if(value!=null){
                              if(value.isEmpty){
                                return "enter user name";
                              }else if(value.length<8){
                                return "user name must be more than 8 chars";
                              }
                              else{
                                return null ;
                              }
                            }else{
                              return "enter user name";
                            }
                          },
                          controller: emailController,
                        ),
                        const SizedBox(height: 16),
                        /// password input field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "password",
                            labelStyle:  TextStyle(
                              fontSize: 16,
                              color: greyBDBDBD,
                            ),
                            suffixIcon: InkWell(
                              child: Icon(
                                // controller.isHiddenPassword
                                //     ?
                                // Icons.visibility_off
                                //     :
                                Icons.visibility,
                                color: greyBDBDBD,
                              ),
                              onTap: () {
                                // controller.setPasswordHidden(!controller.isHiddenPassword);
                              },
                            ),
                            enabledBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(color: grey333333),
                            ),
                            focusedBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(color: grey333333),
                            ),
                          ),
                          autofocus: false,
                          obscureText: false,
                          controller: passwordController,
                        ),
                        SizedBox(height: 57),

                        // if (!controller.isLoading) ...[
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: Text("signIn"),
                                  onPressed: () {
                                    if (_formSignInKey.currentState!.validate()) {
                                      signIn();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 12,),
                              //TODO: add finger print implementation
                              ElevatedButton(
                                onPressed: (){},
                                child: Icon(
                                  Icons.fingerprint,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        // ] else ...[
                        //   const Loading(),
                        // ],
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                             " kInitAccountTxt.tr",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                color: greyBDBDBD,
                                fontSize: 16,
                              ),
                            ),

                            /// tap  Sign up button
                            InkWell(
                              child: Text(
                                "kSignUpTxt.tr",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                  color: orangeMain,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                // Get.to(SignUpPage());
                              },
                            )
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn()async{
    print("sign in started");
    Uri url  = Uri(
      scheme: 'http',
      host: 'clickarabstudent123.com',
      path: "api/student/login"
    );
    Map<String,dynamic> body = {
      'email':emailController.text,
      'password':passwordController.text,
    };
    var response =  await http.post(url,body: json.encode(body));
    log(url.toString(),name: "url");
    log(body.toString(),name: "request body");
    log(response.statusCode.toString(),name: "status code");
    log(response.body.toString(),name: "body");

  }
}
