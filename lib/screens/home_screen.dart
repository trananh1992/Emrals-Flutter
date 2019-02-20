import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/report_list.dart';
import 'package:emrals/screens/stats.dart';
import 'package:emrals/screens/zone_list.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/state_container.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final formatter = new NumberFormat("#,###");
  int _selectedIndex = 0;
  BuildContext _ctx;

  final List<Widget> _children = [
    ReportListWidget(),
    CameraApp(),
    Stats(),
    ZoneListWidget(),
  ];

  User user;

  @override
  void initState() {
    super.initState();

    DatabaseHelper().getUser().then((u) {
      if (u != null) {
        user = u;
        setState(() {
          RestDatasource().updateEmrals(u.token).then((e) {
            StateContainer.of(_ctx)
                .updateEmrals(double.parse(e['emrals_amount']));
            DatabaseHelper().updateUser(u);
          });
        });
      } else {
        Navigator.of(_ctx).pushReplacementNamed("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.map, color: emralsColor()),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/map',
            );
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              formatter.format(StateContainer.of(_ctx).emralsBalance),
              style: TextStyle(
                color: emralsColor(),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // child: AnimatedBuilder(
            //   animation: StateContainer.of(_ctx).animation,
            //   builder: (BuildContext context, Widget child) {
            //     return new Text(
            //       formatter.format(StateContainer.of(_ctx).emralsBalance),
            //       style: TextStyle(
            //         color: emralsColor(),
            //         fontSize: 24.0,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     );
            //   },
            // ),
          ),
          IconButton(
            icon: Image.asset("assets/JustElogo.png"),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
              );
            },
          ),
        ],
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          brightness: Brightness.dark,
          canvasColor: Colors.black,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              this._selectedIndex = index;
            });
          },
          fixedColor: Colors.red,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.view_agenda,
              ),
              title: Text('Activity'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.camera,
              ),
              title: Text('Report'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.multiline_chart,
              ),
              title: Text('Stats'),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.map,
              ),
              title: Text('Zones'),
            ),
          ],
        ),
      ),
    );
  }
}
