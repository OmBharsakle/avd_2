import 'package:avd_2/view/home_page.dart';
import 'package:avd_2/view/sign_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';
import '../utils/globle.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<FitnessProvider>(context);
    var providerFalse = Provider.of<FitnessProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              TextField(
                controller: loginEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          20)),
                  hintText: 'Enter Email',
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: loginPassWord,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          20)),
                  hintText: 'Enter Your Password',
                ),
              ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () async {
                await providerFalse.loginpagemy(loginEmail.text, loginPassWord.text);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(),));
              },
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?'),
                TextButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignPage(),));
                }, child: Text('Sign up now')),
              ],
            ),
            ]
        ),
      ),
    );
  }
}
