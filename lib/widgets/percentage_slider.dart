import 'package:flutter/material.dart';
import 'package:pszczoly_v3/models/question.dart';

class PercentageSlider extends StatefulWidget {
  PercentageSlider({super.key});

  @override
  PercentageSliderState createState() => PercentageSliderState();
}

class PercentageSliderState extends State<PercentageSlider> {
  double _selectedPercentage = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '${_selectedPercentage.round()}%',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SliderTheme(
          data: const SliderThemeData(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
              trackHeight: 1),
          child: Slider(
            value: _selectedPercentage,
            onChanged: (value) {
              setState(() {
                _selectedPercentage = value;
              });
            },
            min: 0,
            max: 100,
            divisions: 100,
            // label: '${_selectedPercentage.round()}%',
          ),
        ),
      ],
    );
  }
}
