
import 'package:auth_migration/view/peca/peca_list.dart';
import 'package:auth_migration/widgets/sidebar_widget.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/NavBarWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, int? cla}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarWidget(),
      drawer: const Sidebar(),
      body: Container(
        margin: const EdgeInsets.only(left: 50, right: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const PecaList(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('LISTA DE PEÇAS'),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
}
