import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/pick_my_trash_page.dart';
import 'package:trashpick/Pages/BottomNavBar/TrashToBeCollected/trash_to_be_collected_page.dart';
import '../../Theme/theme_provider.dart';
import 'Home/home_page.dart';
import 'BeAware/be_aware.dart';
import 'RecyclingCenters/recycling_centers_page.dart';
import 'Settings/settings_page.dart';

class BottomNavBar extends StatefulWidget {
  final String accountType;

  BottomNavBar(this.accountType);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedPage = 0;
  List<Widget> pageList = [];

  String uuid = FirebaseAuth.instance.currentUser.uid.toString();

  @override
  void initState() {
    checkAccountType();
    super.initState();
  }

  List<BottomNavigationBarItem> appBottomNavBarItems =
      const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_rounded,
        size: 30.0,
      ),
      label: 'Главная',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.transfer_within_a_station_rounded,
        size: 30.0,
      ),
      label: 'Мусор, который нужно собрать',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.restore_from_trash,
        size: 30.0,
      ),
      label: 'Центры переработки',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.notifications_rounded,
        size: 30.0,
      ),
      label: 'Уведомления',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.settings_rounded,
        size: 30.0,
      ),
      label: 'Настройки',
    ),
  ];

  appBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedPage,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppThemeData().primaryColor,
      unselectedItemColor: AppThemeData().greyColor,
      onTap: _onItemTapped,
      items: appBottomNavBarItems,
    );
  }

  checkAccountType() async {
    pageList.add(HomePage(widget.accountType));

    if (widget.accountType == "Trash Picker") {
      pageList.add(PickMyTrash(widget.accountType));
    } else {
      pageList.add(TrashToBeCollected());
    }
    pageList.add(RecyclingCenters());
    pageList.add(BeAware());
    pageList.add(SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
                title: Text('Выйти'),
                content: Text('Вы действительно хотите выйти'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                actions: [
                  TextButton(
                    child: Text('Да'),
                    onPressed: () => Navigator.pop(c, true),
                  ),
                  TextButton(
                    child: Text('Нет'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              )),
      child: Scaffold(
          backgroundColor: AppThemeData().whiteColor,
          body: IndexedStack(
            index: _selectedPage,
            children: pageList,
          ),
          bottomNavigationBar: appBottomNavBar()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}
