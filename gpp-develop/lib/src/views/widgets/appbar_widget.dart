import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/home/filial_view.dart';

import '../../shared/components/TextComponent.dart';
import '../../utils/dispositivo.dart';

class NavbarWidget extends StatelessWidget implements PreferredSizeWidget {
  NavbarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      new Size.fromHeight(GetPlatform.isMobile ? 100 : 70);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return NavbarMobile();
    } else if (Dispositivo.tablet(context.width)) {
      return NavbarMobile();
    } else {
      return NavbarDesktop();
    }
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
                  FilialWidget(),
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
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Stack(
        //       alignment: Alignment.center,
        //       textDirection: TextDirection.rtl,
        //       fit: StackFit.loose,
        //       overflow: Overflow.visible,
        //       clipBehavior: Clip.hardEdge,
        //       children: [
        //         Container(
        //           padding: EdgeInsets.symmetric(horizontal: 24),
        //           decoration: BoxDecoration(
        //               color: Colors.pinkAccent,
        //               borderRadius: BorderRadius.circular(20)),
        //           child: Row(
        //             children: [
        //               TextComponent('Filial 500',
        //                   fontWeight: FontWeight.bold, color: Colors.white),
        //               IconButton(
        //                   onPressed: () {},
        //                   icon: Icon(
        //                     Icons.expand_more_rounded,
        //                     color: Colors.white,
        //                   ))
        //             ],
        //           ),
        //         ),
        //         Positioned(
        //             top: 30,
        //             child: Container(
        //               height: 200,
        //               width: 200,
        //               color: Colors.white,
        //             ))
        //       ],
        //     )
        //   ],
        // ),
        SizedBox(
          width: 32,
        ),
        Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilialWidget(),
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

class NavbarDesktop extends StatelessWidget {
  const NavbarDesktop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () {
          Get.toNamed('/home');
        },
        child: const TextComponent(
          'GPP',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      actions: [
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Stack(
        //       alignment: Alignment.center,
        //       textDirection: TextDirection.rtl,
        //       fit: StackFit.loose,
        //       overflow: Overflow.visible,
        //       clipBehavior: Clip.hardEdge,
        //       children: [
        //         Container(
        //           padding: EdgeInsets.symmetric(horizontal: 24),
        //           decoration: BoxDecoration(
        //               color: Colors.pinkAccent,
        //               borderRadius: BorderRadius.circular(20)),
        //           child: Row(
        //             children: [
        //               TextComponent('Filial 500',
        //                   fontWeight: FontWeight.bold, color: Colors.white),
        //               IconButton(
        //                   onPressed: () {},
        //                   icon: Icon(
        //                     Icons.expand_more_rounded,
        //                     color: Colors.white,
        //                   ))
        //             ],
        //           ),
        //         ),
        //         Positioned(
        //             top: 30,
        //             child: Container(
        //               height: 200,
        //               width: 200,
        //               color: Colors.white,
        //             ))
        //       ],
        //     )
        //   ],
        // ),
        SizedBox(
          width: 32,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilialWidget(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
                'https://as1.ftcdn.net/v2/jpg/01/71/25/36/1000_F_171253635_8svqUJc0BnLUtrUOP5yOMEwFwA8SZayX.jpg'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 32),
          child: Icon(Icons.notifications_rounded),
        )
      ],
    );
  }
}
