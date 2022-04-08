import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import '../../../Widgets/primary_app_bar_widget.dart';

class HomePage extends StatefulWidget {
  final String accountType;

  HomePage(this.accountType);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userReference = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String badgeType;

  @override
  void initState() {
    _setBadgeType();
    super.initState();
  }

  _setBadgeType() {
    if (widget.accountType == "Trash Picker") {
      badgeType = "Picker";
    } else if (widget.accountType == "Trash Collector") {
      badgeType = "Collector";
    }
  }

  _statTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          fontWeight: FontWeight.bold),
    );
  }

  _statDetail(double numberValue, bool isDouble) {
    String detailString;
    if (isDouble) {
      detailString = numberValue.toString();
    } else {
      detailString = numberValue.toInt().toString();
    }

    return Text(
      detailString,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          fontWeight: FontWeight.bold),
    );
  }

  _badgeRequiresPoints(String points) {
    return Text(
      points,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
          fontWeight: FontWeight.normal),
    );
  }

  _badgeDesignsWidget(String image, String badgeName, String badgePoints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 60.0,
          width: 60.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statTitle(badgeName),
            _badgeRequiresPoints(badgePoints),
          ],
        )
      ],
    );
  }

  welcomeHeader() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where('uuid', isEqualTo: "${auth.currentUser.uid}")
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          //return profileHeaderShimmer();
          return Text(
            " ",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline6.fontSize,
                fontWeight: FontWeight.bold),
          );
        } else {
          UserModelClass userModelClass =
              UserModelClass.fromDocument(dataSnapshot.data.docs[0]);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " ${userModelClass.name}",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    fontWeight: FontWeight.normal),
              ),
            ],
          );
        }
      },
    );
  }

  _profileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statTitle("Всего собрано мусора"),
                SizedBox(
                  height: 10.0,
                ),
                _statTitle("Общее количество очков"),
              ],
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statDetail(4, false),
                SizedBox(
                  height: 10.0,
                ),
                _statDetail(52, false),
              ],
            )
          ],
        ),
        Column(
          children: [
            Image.asset(
              'assets/images/badge_starter.png',
              height: 70.0,
              width: 70.0,
            ),
            SizedBox(
              height: 5.0,
            ),
            _statTitle("Уровень 1"),
          ],
        )
      ],
    );
  }

  _badgeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.accountType == "Зеленая Караганда"
            ? _statTitle(
                "Запланируйте больше вывоза мусора, чтобы разблокировать")
            : _statTitle("Соберите больше мусора, чтобы разблокировать"),
        SizedBox(
          height: 10.0,
        ),
        _badgeDesignsWidget('assets/images/badge_bronze.png',
            "Бронзовая Медаль", "100 Баллов"),
        SizedBox(
          height: 10.0,
        ),
        _badgeDesignsWidget('assets/images/badge_silver.png',
            "Серебряная медаль", "1000 Баллов"),
        SizedBox(
          height: 10.0,
        ),
        _badgeDesignsWidget(
            'assets/images/badge_gold.png', "Золотая медаль", "10000 Баллов"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Зеленая Караганда",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.home_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 35.0,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/logos/trashpick_logo_curved.png',
                  height: 75.0,
                  width: 75.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                welcomeHeader(),
                Center(
                  child: Text(
                    "Добро пожаловать",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline5.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
/*                Text(
                  "${widget.accountType}",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline4.fontSize,
                      fontWeight: FontWeight.bold),
                ),*/
                _profileStats(),
                SizedBox(
                  height: 30.0,
                ),
                _badgeDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
