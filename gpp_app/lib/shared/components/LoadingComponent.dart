import 'package:flutter/material.dart';
import 'styles.dart';

class LoadingComponent extends StatelessWidget {
  const LoadingComponent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: secundaryColor,
            )),
      ],
    );
  }
}
