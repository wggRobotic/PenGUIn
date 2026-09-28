import 'package:flutter/material.dart';
import 'package:frontend/ui-elements/filter_checkbox.dart';

class FilterDialog {
  void showFilterDialog(BuildContext context, String firstLabel, List<String> firstFilter, String secondLabel, List<String> secondFiler, VoidCallback resetAction, Function(List<String>, List<String>) applyAction) {
    List<String> selectedTagsOfFirst = [];
    List<String> selectedTagsOfSecond = [];

    showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double maxHeight = constraints.maxHeight * 0.9;

            return AlertDialog(
              title: const Text("Apply filter"),
              alignment: AlignmentGeometry.bottomRight,
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxHeight
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(firstLabel),
                      Column(
                        children: firstFilter.map((attribute) {
                          return FilterCheckbox(
                            label: attribute,
                            onChanged: (state) {
                              // Add the type to the list of selected filters
                              if (state == true) {
                                selectedTagsOfFirst.add(attribute);
                              } else if (state == false) {
                                selectedTagsOfFirst.remove(attribute);
                              }
                            }
                          );
                        }).toList(),
                      ),
                      Text(secondLabel),
                      Column(
                        children: secondFiler.map((attribute) {
                          return FilterCheckbox(
                            label: attribute,
                            onChanged: (state) {
                              // Add the type to the list of selected filters
                              if (state == true) {
                                selectedTagsOfSecond.add(attribute);
                              } else if (state == false) {
                                selectedTagsOfSecond.remove(attribute);
                              }
                            }
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.pop(context)
                ),
                TextButton(
                  child: Text("Apply"),
                  onPressed: () {
                    // TODO: Support multiple tabs
                    if (selectedTagsOfFirst.isEmpty && selectedTagsOfSecond.isEmpty) {
                      // Reset in order to improve the performance
                      resetAction();
                    } else {
                      // Apply the filter
                      applyAction(selectedTagsOfFirst, selectedTagsOfSecond);
                    }

                    // Close the dialog
                    Navigator.pop(context);
                  }
                )
              ],
            );
          },
        );
      }
    );
  }
}
