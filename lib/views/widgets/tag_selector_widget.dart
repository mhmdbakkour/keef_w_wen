import 'package:flutter/material.dart';

class TagSelector extends StatefulWidget {
  final List<String> tags;
  final List<String>? currentTags;
  final Function(List<String>) onSelectionChanged;

  const TagSelector({
    super.key,
    required this.tags,
    this.currentTags,
    required this.onSelectionChanged,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late List<String> _selectedTags;
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
  void initState() {
    super.initState();
    _selectedTags = [...widget.currentTags ?? []];
  }

  @override
  Widget build(BuildContext context) {
    final Color variantColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: variantColor),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 16.0),
            child: Row(
              children: [
                Icon(Icons.style, color: variantColor),
                SizedBox(width: 15),
                Text(
                  "Tags",
                  style: TextStyle(fontSize: 16, color: variantColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          if (_selectedTags.isNotEmpty)
            Container(
              padding: EdgeInsets.all(8),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children:
                        List.generate(
                          widget.tags.length,
                          (i) => i,
                        ).where((i) => i.isEven).map((i) {
                          final tag = widget.tags[i];
                          if (_selectedTags.contains(tag)) {
                            return const SizedBox.shrink();
                          }
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
                        }).toList(),
                  ),
                  Row(
                    children:
                        List.generate(
                          widget.tags.length,
                          (i) => i,
                        ).where((i) => i.isOdd).map((i) {
                          final tag = widget.tags[i];
                          if (_selectedTags.contains(tag)) {
                            return const SizedBox.shrink();
                          }
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
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
