import 'dart:math';

import 'package:flutter/material.dart';

export 'example_card.dart';

Color randomColor() => Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1);

double random(double max) => Random().nextDouble() * max;

Alignment randomAlignment() => Alignment(Random().nextDouble() * 2 - 1, Random().nextDouble() * 2 - 1);

double randomClamp(double min, double max) => min + Random().nextDouble() * (max - min);
