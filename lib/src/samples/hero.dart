import 'package:animation/src/helpers/helpers.dart';
import 'package:flutter/material.dart';

class HeroPage extends StatelessWidget {
  const HeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero animation'),
      ),
      body: Container(
        color: Colors.black,
        child: Align(
          alignment: randomAlignment(),
          child: SizedBox(
            width: randomClamp(100, 300),
            height: randomClamp(100, 300),
            child: ExampleCard(
              cardData: ExampleCardData(
                icon: Icons.auto_awesome_outlined,
                description: 'Hero animation',
                info: 'Flutter SDK',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HeroPage()),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
