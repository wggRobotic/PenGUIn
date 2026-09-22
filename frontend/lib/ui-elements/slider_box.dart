import 'package:flutter/material.dart';
import 'package:frontend/datamodells.dart';

class SliderBox extends StatefulWidget{
  final SliderDatamodell slider;
  final ValueChanged<double> onChangeEnd;
  const SliderBox({
    super.key,
    required this.slider,
    required this.onChangeEnd,
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