import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/screen/login_screen.dart';
import 'package:tugas_akhir/utils/color_utils.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseDatabase fireDB = FirebaseDatabase.instance;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController nomorTelepon = TextEditingController();
  
  register() async {
    try {
      var result = await fireDB.ref('user').get();
      var data = result.children.toList().where((item) {
        if ((item.value as dynamic)['username'] == username.text) {
          return true;
        }
        return false;
      });

      if (data.isEmpty) {
        await fireDB.ref('user').push().set({
          'username': username.text,
          'nama': nama.text,
          'password': password.text,
          'nomorTelepon': nomorTelepon.text,
          'role': '2',
        }).then((value) {
          notif(context, text: 'registrasi akun berhasil. silahkan login!', color: Colors.green);
          navigatorPushReplace(context, page: Login());
        });
      } else {
        notif(context, text: 'username sudah digunakan', color: Colors.red);
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
                    Text("Sign Up", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 25,),
                    Text("Join keun mamank.. ", style: TextStyle(
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
                  makeInput3(label : "Nama"),
                  makeInput4(label : "Nomor Telepon")
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
                    onPressed: register,
                    color: Colors.purple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Sign Up", style: TextStyle(
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
                  Text("Sudah mempunyai Akun?"),
                  GestureDetector(
                      onTap: () {navigatorPushReplace(context, page: Login());
                    },
                    child: Text("Log In",style: TextStyle(
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
            ),
            hintText: ('username anda')
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
            ),
            hintText: ('******')
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }
  Widget makeInput3 ({label, obscure = false}) {
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
          controller: nama,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Color.fromARGB(166, 158, 158, 158))
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(155, 158, 158, 158))
            ),
            hintText: ('Nama Anda')
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }

  Widget makeInput4 ({label, obscure = false}) {
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
          controller: nomorTelepon,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Color.fromARGB(166, 158, 158, 158))
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(155, 158, 158, 158))
            ),
            hintText: ('+62xxxxxxxxxxxxx')
          ),
        ),
        SizedBox(height: 30,)
      ],
    );
  }
}