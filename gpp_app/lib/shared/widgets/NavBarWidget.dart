import 'package:auth_migration/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/service/auth_service.dart';
import '../../view/login/login_screen.dart';
import '../components/styles.dart';

class NavbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const NavbarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(GetPlatform.isMobile ? 100 : 70);

  @override
  Widget build(BuildContext context) {
    return const NavbarMobile();
  }
}

class NavbarMobile extends StatelessWidget {
  const NavbarMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    logout() {
      _authService.logOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        ),
        (route) => false,
      );
    }

    if (context.width < 576) {
      return Container(
        color: primaryColor,
        width: context.width,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  const Text('GPP',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    color: Colors.white,
                    onPressed: logout,
                  ),
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen(),
              ),
              (route) => false,
            );
          },
          child: Text(
            'GPP',
            style: textStyleTitulo,
          )),
      actions: [
        const SizedBox(
          width: 32,
        ),
        SizedBox(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
        const Padding(
          padding: EdgeInsets.only(left: 8, right: 32),
          child: Icon(Icons.notifications_rounded),
        )
      ],
    );
  }
}
