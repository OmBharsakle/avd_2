import 'package:avd_2/view/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';
import '../utils/globle.dart';

class SignPage extends StatelessWidget {
  const SignPage({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<FitnessProvider>(context);
    var providerFalse = Provider.of<FitnessProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Page'),
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
                  hintText: 'Enter Your Email',
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
              TextField(
                controller: loginPassWordConfirm,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          20)),
                  hintText: 'Enter Your Confirm Password',
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () async {
                  await providerFalse.signAccount(loginEmail.text, loginPassWordConfirm.text);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));

                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Sign',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already a user?'),
                  TextButton(onPressed: () {

                  }, child: Text('LOGIN')),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
