import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emrals/data/database_helper.dart';

// class SharedPreferencesHelper {

//   static Future<String> getUserPicture() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     print(prefs.getString("user_picture"));
//     return prefs.getString("user_picture").toString() ?? 'http://www.google.com/logo.png';
//   }

// }

class Settingg extends StatefulWidget {
  const Settingg({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => new _SettingsPage();
}

Future<String> getUserPicture() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String picture = prefs.getString('user_picture');
  return picture;
}

class _SettingsPage extends State<Settingg> {
  String userPicture = "https://www.emrals.com/static/images/emrals128.png";

  @override
  void initState() {
    getUserPicture().then(updatePicture);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.black.withOpacity(0.8)),
            ),
            Positioned(
                width: 350.0,
                top: MediaQuery.of(context).size.height / 9,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(userPicture),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 20.0),
                    Text(
                      'Tom Cruise',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      'Subscribe guys',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Edit Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.redAccent,
                          color: Colors.red,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              var db = new DatabaseHelper();
                              db.deleteUsers().then((_) {
                                Navigator.pushNamed(context, '/login');
                              });
                            },
                            child: Center(
                              child: Text(
                                'Log out',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ))
                  ],
                ))
          ],
        ));
  }

  void updatePicture(String picture) {
    setState(() {
      this.userPicture = picture;
    });
  }
}
