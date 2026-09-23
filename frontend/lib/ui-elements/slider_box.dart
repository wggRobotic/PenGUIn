import 'package:flutter/material.dart';
import 'package:frontend/datamodells.dart';

class SliderBox extends StatefulWidget{
  final SliderDatamodell slider;
  final ValueChanged<double> onChangeEnd;
  final bool verticalOrientation;

  const SliderBox({
    super.key,
    required this.slider,
    required this.onChangeEnd,
    required this.verticalOrientation,
  });

  @override
  State<SliderBox> createState() => _SliderBoxState();
}

class _SliderBoxState extends State<SliderBox> {
  double sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("${widget.slider.label}:"), // Display the label of the slider
        RotatedBox( // Rotate the slider so its either horizontal or vertical
          quarterTurns: widget.verticalOrientation
            ? 3
            : 0,
          child: Slider( // Display the slider and its current value
            value: sliderValue,
            min: widget.slider.centered // Center the x-axis
              ? -1
              : 0,
            max: 1,
            activeColor: Color.fromARGB(175, 118, 116, 115),
            inactiveColor: Color.fromARGB(175, 118, 116, 115),
            thumbColor: Theme.of(context).colorScheme.primary,
            onChanged: (value) {
              setState(() {
                sliderValue = value;
              });
            },
            onChangeEnd: (value) => widget.onChangeEnd(value),
          ),
        ),
      ],
    );
  }
}