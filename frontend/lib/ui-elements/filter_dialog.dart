import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/ui-elements/filter_checkbox.dart';
import 'package:provider/provider.dart';

class FilterDialog {
  void showFilterDialog(BuildContext context, List<String> typeFilter, List<String> categoryFiler) {
    List<String> selectedTypes = [];
    List<String> selectedCategories = [];

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
                      Text("Type:"),
                      Column(
                        children: typeFilter.map((attribute) {
                          return FilterCheckbox(
                            label: attribute,
                            onChanged: (state) {
                              // Add the type to the list of selected filters
                              if (state == true) {
                                selectedTypes.add(attribute);
                              } else if (state == false) {
                                selectedTypes.remove(attribute);
                              }
                            }
                          );
                        }).toList(),
                      ),
                      Text("Category:"),
                      Column(
                        children: categoryFiler.map((attribute) {
                          return FilterCheckbox(
                            label: attribute,
                            onChanged: (state) {
                              // Add the type to the list of selected filters
                              if (state == true) {
                                selectedCategories.add(attribute);
                              } else if (state == false) {
                                selectedCategories.remove(attribute);
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
                    if (selectedTypes.isEmpty && selectedCategories.isEmpty) {
                      // Reset in order to improve the performance
                      context.read<AnalyticsProvider>().resetFilter();
                    } else {
                      // Apply the filter
                      context.read<AnalyticsProvider>().applyFilter(selectedTypes, selectedCategories);
                      Navigator.pop(context);
                    }
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
