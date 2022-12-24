import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:tugas_akhir/main.dart';
import 'package:tugas_akhir/reusable_widgets/bestoffer.dart';
import 'package:tugas_akhir/reusable_widgets/categories.dart';
import 'package:tugas_akhir/reusable_widgets/recomennded.dart';
import 'package:tugas_akhir/screen/login_screen.dart';
import 'package:tugas_akhir/screen/profile.dart';
import 'package:tugas_akhir/screen/user.dart';
import 'package:tugas_akhir/utils/color_utils.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController searchLocation = TextEditingController();

  String userNama = '';
  Position position = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );
  bool loading = false;
  String address = 'Tidak diketahui';

  @override
  void initState() {
    super.initState();
    getUser();
    getLocation();
  }

  void getUser() async {
    getAuth().then((value) {
      if (value == null) {
        navigatorPushReplace(context, page: Login());
      } else {
        setState(() {
          userNama = value.value['nama'];
        });
      }
    });
  }

  void goToLocation() async {
    var intent = AndroidIntent(
      action: 'action_view',
      data: 'google.navigation:q=${searchLocation.text}',
    );
    await intent.launch();
  }

  getLocation() async {
    setState(() {
      loading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      notif(context, text: 'service lokasi tidak tersedia', color: Colors.red);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        notif(context, text: 'Akses lokasi tidak diizinkan');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      notif(context, text: 'Akses lokasi tidak diizinkan secara permanen');
    }

    var location = await Geolocator.getCurrentPosition();
    var placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
    var place = placemarks[0];

    setState(() {
      position = location;
      loading = false;
      address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.country}";
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    
    return Layout(
      title: 'Dashboard',
      body: ListView(
       children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text : TextSpan(
                   text: 'Hallo ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black38),
                  children: <TextSpan>[
                    TextSpan(text: userNama, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple))
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  'Lokasi Anda Saat ini',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  loading ? 'Memuat...' : address,
                ),
              ],
            ),
          ),
          Categories(),
          RecommendedHouse(),
          BestOffer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi lain yang ingin kamu tuju',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: searchLocation,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Cari.....',
                  ),
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
                      onPressed: goToLocation,
                      color: Colors.purple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Go", style: TextStyle(
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: getLocation,
        child: Icon(
          Icons.place,
        ),
      ),
    );
  }
}
///======================== classs Lyout Widget
class Layout extends StatefulWidget {
  const Layout({
    Key? key,

    this.body,
    this.title,
    this.floatingActionButton,
  }) : super(key: key);
  
  final Widget? body;
  final String? title;
  final Widget? floatingActionButton;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  String userUsername = '';
  String userNama = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    cekUser();
  }

  void cekUser() {
    getAuth().then((value) {
      if (value.value != null) {
        setState(() {
          userUsername = value.value['username'];
          userNama = value.value['nama'];
          userRole = value.value['role'];
        });
      }
    });
  }

  

  logout() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    await session.clear();

    navigatorPushReplace(context, page: Homepage());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(widget.title.toString()),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * .25,
            width: size.width,
          ),
          widget.body as Widget,
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              currentAccountPicture: Container(               
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundImage: AssetImage('assets/img/admin.jpg',),
                    )
                  ],
                ),
              ),
              accountName: Text(userUsername),
              accountEmail: Text(userNama),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard'),
              onTap: () {
                navigatorPush(context, page: Dashboard());
              },
            ),
            userRole == '1'
                ? ListTile(
                    leading: Icon(Icons.supervisor_account),
                    title: Text('Data User'),
                    onTap: () {
                      navigatorPush(context, page: User());
                    },
                  )
                : SizedBox(),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profil'),
              onTap: () {
                navigatorPush(context, page: Profil());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      content: Text("Anda yakin akan logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            navigatorPop(context);
                          },
                          child: Text('BATAL'),
                        ),
                        TextButton(
                          onPressed: logout,
                          child: Text('LOGOUT'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        
      ),
    );
  }
}