import 'package:flutter/material.dart';

import 'main/listing.dart';
import 'main/main.dart';
class DashboardMain extends StatefulWidget {
  final Function function;
  final String eamil;
  const DashboardMain({Key? key,required this.function,required this.eamil}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardMain>  {


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
List<Widget> _widgetOptions = <Widget>[


  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _widgetOptions=[
      MainDashboardSreen(function: widget.function,email : widget.eamil),
      ListingSection()
    ];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 10,left: 20),
          child: Image.asset('assets/forward.png'),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Text('Email to SMS',style: TextStyle(color: Colors.black87),),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 15,top: 15,bottom: 05),
            child: InkWell(
              child:  Image.asset('assets/off.png'),
            ),
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
