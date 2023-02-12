import 'package:flutter/material.dart';
import 'package:graphs/view/home/widgets/form.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Row(
        children: [
          Expanded(child: Container()),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            indent: 5,
            endIndent: 5,
          ),
          const FormWidget(),
        ],
      ),
    );
  }
}
