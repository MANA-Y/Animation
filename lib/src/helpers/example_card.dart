import 'package:flutter/material.dart';

class ExampleCardData {
  final IconData icon;
  final String description;
  final String? info;
  final VoidCallback? onTap;

  const ExampleCardData({
    required this.icon,
    required this.description,
    this.info,
    this.onTap,
  });
}

class ExampleCard extends StatelessWidget {
  final ExampleCardData cardData;
  final int? index;

  const ExampleCard({
    super.key,
    required this.cardData,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: cardData.description,
      child: Stack(
        children: [
          Positioned.fill(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: cardData.onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cardData.icon,
                      size: 48,
                    ),
                    Text(
                      cardData.description,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    if (cardData.info != null)
                      Text(
                        cardData.info!,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (index != null)
            Positioned.fill(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  index.toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
