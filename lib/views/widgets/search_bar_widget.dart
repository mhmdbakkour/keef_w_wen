import 'package:flutter/material.dart';

import '../../data/notifiers.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        width: double.infinity,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  height: 40,
                  child: TextField(
                    style: TextStyle(
                      color:
                          isDarkModeNotifier.value
                              ? Colors.white
                              : Colors.black,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color:
                            isDarkModeNotifier.value
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.filter_alt,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
