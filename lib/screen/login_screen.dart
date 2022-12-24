import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir/screen/homescreen.dart';
import 'package:tugas_akhir/utils/color_utils.dart';
import 'package:tugas_akhir/screen/reg_screen.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseDatabase fireDB = FirebaseDatabase.instance;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    cekUser();
  }

  cekUser() {
    getAuth().then((value) {
      if (value.value != null) {
        navigatorPushReplace(context, page: Dashboard());
      }
    });
  }

  login() async {
    try {
      var result = await fireDB.ref('user').get();
      var data = result.children.toList().where((item) {
        if ((item.value as dynamic)['username'] == username.text) {
          return true;
        }

        return false;
      });

      if (data.isEmpty) {
        notif(context, text: 'username tidak ditemukan', color: Colors.red);
      } else {
        for (var item in data) {
          if ((item.value as dynamic)['password'] == password.text) {
            SharedPreferences session = await SharedPreferences.getInstance();
            session.setString('auth', item.key.toString());

            notif(context, text: 'berhasil login', color: Colors.green);
            navigatorPushReplace(context, page: Dashboard());
            return true;
          }
        }

        notif(context, text: 'password salah', color: Colors.red);
      }
    } catch (e) {
      notif(context, text: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      
      body: Stack(
        children:<Widget> [
          Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Login", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 25,),
                    Text("Welcome back lads.. ", style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700]
                    ),)
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: <Widget>[
                  makeInput(label: "Username"),
                  makeInput2(label: "Password", obscure: true),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                    padding: EdgeInsets.only(top:3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )
                    ),
                    child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: login,
                    color: Colors.purple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Login", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Belum punya Akun?"),
                  GestureDetector(
                      onTap: () {navigatorPushReplace(context, page: Register());
                    },
                    child: Text("Sign Up",style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,                   
                  ),),
                    ),
                ],
              )
          ],
        ),
      ),
        ]
      )
    );
  }
  Widget makeInput ({label, obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),),
        SizedBox(height: 5,),
        TextField(
          obscureText: obscure,
          controller: username,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Color.fromARGB(166, 158, 158, 158))
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(155, 158, 158, 158))
            )
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }
  
  Widget makeInput2 ({label, obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),),
        SizedBox(height: 5,),
        TextField(
          obscureText: obscure,
          controller: password,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Color.fromARGB(166, 158, 158, 158))
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(155, 158, 158, 158))
            )
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }
}