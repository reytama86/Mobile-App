import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir/reusable_widgets/reusable_widget.dart';
import 'package:tugas_akhir/screen/homescreen.dart';
import 'package:tugas_akhir/utils/color_utils.dart';

class Profil extends StatefulWidget {
  Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  FirebaseDatabase fireDB = FirebaseDatabase.instance;

  TextEditingController username = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nomorTelepon = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    await getAuth().then((value) {
      setState(() {
        username.text = value.value['username'];
        nama.text = value.value['nama'];
        password.text = '';
        nomorTelepon.text = value.value['nomorTelepon'];
      });
    });
  }

  Future update() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    String key = session.getString('auth').toString();

    try {
      var data = {
        'username': username.text,
        'nama': nama.text,
        'nomorTelepon': nomorTelepon.text,
      };

      if (password.text.isNotEmpty) {
        data['password'] = password.text;
      }

      await fireDB.ref('user').child(key).update(data).then((value) {
        notif(context, text: 'akun berhasil diedit', color: Colors.green);
        getUser();
      });
    } catch (e) {
      notif(context, text: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Profil',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Panel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: username,
                decoration: InputDecoration(hintText: 'Masukkan Username', label: Text('Username')),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nama,
                decoration: InputDecoration(hintText: 'Masukkan Nama', label: Text('Nama')),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: password,
                // obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Kosongkan jika tidak ingin mengganti password',
                  label: Text('Password'),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nomorTelepon,
                keyboardType: TextInputType.phone,
                decoration:
                    InputDecoration(hintText: '62xxxxxxxxxxx', label: Text('Nomor Telepon')),
              ),
              SizedBox(height: 40),
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
                      onPressed: update,
                      color: Colors.purple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Simpan", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}