import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/components/TextComponent.dart';
import '../shared/components/styles.dart';

class NavbarWidget extends StatelessWidget implements PreferredSizeWidget {
  NavbarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      new Size.fromHeight(GetPlatform.isMobile ? 100 : 70);

  @override
  Widget build(BuildContext context) {
   
      return NavbarMobile();
   
    
  }
}

class NavbarMobile extends StatelessWidget {
  const NavbarMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.width < 576) {
      return Container(
        color: primaryColor,
        width: context.width,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer()),
                  Text('GPP',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                ],
              ),
              Row(
                children: [
                 // FilialWidget(),
                  SizedBox(
                    width: 16,
                  ),
                  Icon(Icons.notifications_rounded, color: Colors.white),
                ],
              )
            ]),
      );
    }

    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      shadowColor: Colors.transparent,
      title: GestureDetector(
          onTap: () {
            Get.toNamed('/dashboard');
          },
          child: Text(
            'GPP',
            style: textStyleTitulo,
          )),
      actions: [
       
        SizedBox(
          width: 32,
        ),
        Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //FilialWidget(),
            ],
          ),
        ),
        context.width > 576
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                      'https://as1.ftcdn.net/v2/jpg/01/71/25/36/1000_F_171253635_8svqUJc0BnLUtrUOP5yOMEwFwA8SZayX.jpg'),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 32),
          child: Icon(Icons.notifications_rounded),
        )
      ],
    );
  }
}
