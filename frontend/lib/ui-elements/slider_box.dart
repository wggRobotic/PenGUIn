import 'package:flutter/material.dart';
import 'package:frontend/datamodells.dart';

class SliderBox extends StatefulWidget{
  final SliderDatamodell slider;
  final ValueChanged<double> onChangeEnd;
  final bool centeredNull;

  const SliderBox({
    super.key,
    required this.slider,
    required this.onChangeEnd,
    required this.centeredNull,
  });

  @override
  State<SliderBox> createState() => _SliderBoxState();
}

class _SliderBoxState extends State<SliderBox> {
  double sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("${widget.slider.label}:"), // Display the label of the slider
        Slider( // Display the slider and its current value
          value: sliderValue,
          min: widget.centeredNull // Center the x-axis
            ? -1
            : 0,
          max: 1,
          onChanged: (value) {
            setState(() {
              sliderValue = value;
            });
          },
          onChangeEnd: (value) => widget.onChangeEnd(value),
        ),
      ],
    );
  }
}