import 'package:animation/src/helpers/helpers.dart';
import 'package:flutter/material.dart';

import 'explicit.dart';
import 'flutter_animate.dart';
import 'hero.dart';
import 'hit_the_target/pull_to_refresh.dart';
import 'implicit.dart';
import 'rive.dart';
import 'transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<ExampleCardData> cardData;

  @override
  void initState() {
    super.initState();

    cardData = [
      ExampleCardData(
        icon: Icons.contrast,
        description: 'Implicit animation',
        info: 'Flutter SDK',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImplicitPage()),
          );
        },
      ),
      // ExampleCardData(
      //   icon: Icons.difference_outlined,
      //   description: 'TweenBuilder',
      //   info: 'Flutter SDK',
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Container()),
      //     );
      //   },
      // ),
      ExampleCardData(
        icon: Icons.control_camera,
        description: 'Explicit animation',
        info: 'Flutter SDK',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExplicitPage()),
          );
        },
      ),
      ExampleCardData(
        icon: Icons.start,
        description: 'Transition animation',
        info: 'Flutter SDK',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FirstScreen()),
          );
        },
      ),
      ExampleCardData(
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
      ExampleCardData(
        icon: Icons.switch_access_shortcut_add,
        description: 'Animation shortcut',
        info: 'package:flutter_animate',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FlutterAnimatePage()),
          );
        },
      ),
      ExampleCardData(
        icon: Icons.spa_outlined,
        description: 'Rive animations',
        info: 'package:rive',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RivePage()),
          );
        },
      ),
      ExampleCardData(
        icon: Icons.update,
        description: 'Hit the target',
        info: 'Complex example',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PullToRefreshPage()),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              title: Text('Главный экран'),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ExampleCard(
                  index: index,
                  cardData: cardData[index],
                ),
                childCount: cardData.length,
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(
                top: 32,
              ),
            ),
          ],
        );
      }),
    );
  }
}
