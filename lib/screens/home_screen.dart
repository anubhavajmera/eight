import 'package:eight/screens/choose_channel_screen.dart';
import 'package:eight/screens/size_config.dart';
import 'package:eight/screens/stream_page_mj.dart';
import 'package:eight/src/pages/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFF432020),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(30),
                  horizontal: getProportionateScreenWidth(15)),
              width: double.infinity,
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Text(
                          "Featured",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "MJ Arnab",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "200",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " followers",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(30),
                  horizontal: getProportionateScreenWidth(15)),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 50.0, // soften the shadow
                    spreadRadius: 15.0, //extend the shadow
                    // offset: Offset(
                    //   15.0, // Move to right 10  horizontally
                    //   15.0, // Move to bottom 10 Vertically
                    // ),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.wifi,
                    color: Colors.red,
                    size: 60,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => ChooseChannelScreen()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "GO LIVE",
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "GET STARTED",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.white,
                    size: 45,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(30),
                  left: getProportionateScreenWidth(15)),
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Popular Channels",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(2),
                        horizontal: getProportionateScreenWidth(1)),
                    width: double.infinity,
                    height: SizeConfig.screenHeight * 0.25,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: SizeConfig.screenHeight * 0.15,
                                  width: SizeConfig.screenHeight * 0.15,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "MJ Adeetya",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "300 views",
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              )
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: getProportionateScreenWidth(15),
                  left: getProportionateScreenWidth(15)),
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Join your friends",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Container(
                    width: double.infinity,
                    height: SizeConfig.screenHeight * 0.2,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: SizeConfig.screenHeight * 0.1,
                                  width: SizeConfig.screenHeight * 0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.screenHeight * 0.1)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Adeetya",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(5),
                  left: getProportionateScreenWidth(15)),
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Buy Music",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(1),
                        vertical: 15),
                    width: double.infinity,
                    height: SizeConfig.screenHeight * 0.25,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: SizeConfig.screenHeight * 0.15,
                                  width: SizeConfig.screenHeight * 0.15,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
