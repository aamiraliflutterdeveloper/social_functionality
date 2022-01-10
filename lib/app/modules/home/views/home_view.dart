import 'package:social_media_application/app/controllers/auth_controller.dart';
import 'package:social_media_application/app/routes/app_pages.dart';
import 'package:social_media_application/app/controllers/auth_controller.dart';
import 'package:social_media_application/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    accentColor: Colors.black,
    buttonColor: Colors.red[900],
  );

  final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF686D76),
    accentColor: Colors.white,
    buttonColor: Colors.red[900],
  );
  final List<Widget> myChats = List.generate(20, (index) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.CHAT_ROOM),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black26,
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(100),
            child: Image.asset(
              "assets/logo/noimage.png",
              fit: BoxFit.cover,
            )
          ),
        ),
        title: Text(
          "Orange is: ${index + 1}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Orange is: ${index + 1}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: const Chip(
          label: Text("3"),
        ),
      ),
    );
  }).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Get.theme.primaryColor,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Material(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chats",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red[900],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: myChats.length,
                itemBuilder: (context, index) {
                  return myChats[index];
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: const Icon(
          Icons.search,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.red[900],
      ),
    );
  }
}
