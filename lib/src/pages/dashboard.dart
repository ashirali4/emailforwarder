import 'package:emailforwarder/src/pages/auth/login.dart';
import 'package:emailforwarder/src/pages/utlis/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
import 'main/help.dart';
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
  PageController? _pageController;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
List<Widget> _widgetOptions = <Widget>[


  ];
  var _authModel;
  onlogout() async {
    SystemNavigator.pop();
  }

  void _onItemTapped(int index) {
    print("this is index+  "+ index.toString());
    setState(() {
      _selectedIndex = index;
      _pageController?.jumpToPage(index);

    });
  }

  @override
  void initState() {
    _authModel = Provider.of<AuthModel>(context, listen: false);
    _pageController = PageController(initialPage: _selectedIndex);

    _widgetOptions=[
      MainDashboardSreen(function: widget.function,email : widget.eamil),
      HelpScreen(),
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
          InkWell(
            onTap: onlogout,
            child: Container(
              padding: const EdgeInsets.only(right: 15,top: 15,bottom: 05),
              child: InkWell(
                child:  Image.asset('assets/off.png'),
              ),
            ),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
