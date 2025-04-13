import 'package:flutter/material.dart';

class TagSelector extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) onSelectionChanged;

  const TagSelector({
    super.key,
    required this.tags,
    required this.onSelectionChanged,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  final List<String> _selectedTags = [];
  final int _maxTags = 5;

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        if (_selectedTags.length < _maxTags) {
          _selectedTags.add(tag);
        }
      }
      widget.onSelectionChanged(_selectedTags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(Icons.tag_outlined),
              SizedBox(width: 5),
              Text("Event Tags", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        SizedBox(height: 10),
        if (_selectedTags.isNotEmpty)
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children:
                  _selectedTags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => _toggleTag(tag),
                    );
                  }).toList(),
            ),
          ),
        SizedBox(height: 10),
        SizedBox(
          height: 170,
          child: SingleChildScrollView(
            controller: ScrollController(initialScrollOffset: 250),
            scrollDirection: Axis.horizontal,
            child: Column(
              children: List.generate(3, (index) {
                return Row(
                  children:
                      widget.tags
                          .where((tag) => !_selectedTags.contains(tag))
                          .skip(index * (widget.tags.length ~/ 3))
                          .take(widget.tags.length ~/ 3)
                          .map((tag) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 4.0,
                              ),
                              child: ChoiceChip(
                                label: Text(tag),
                                selected: false,
                                onSelected: (_) => _toggleTag(tag),
                              ),
                            );
                          })
                          .toList(),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
