import 'package:flutter/material.dart';
import 'forget_pasword.dart';
import 'login.dart';
import 'register.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.lightGreenAccent,
                    Colors.pink,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: Text(
            'e-shop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 55.0,
              fontFamily: 'Signatra',
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock),
                text: 'Login',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Register',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Forget Password',
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0,
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreenAccent , Colors.pink],
              begin: FractionalOffset( 1.0 , 0.0),
              end: FractionalOffset(1.0,1)
            )
          ),
          child: TabBarView(children: [
            Login(),
            Register(),
            Forget(),

          ],),
        ),

      ),
    );
  }
}
