import 'package:flutter/material.dart';

class SearchBarWidget<T> extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.items,
    required this.searchFilter,
    required this.onSearch,
    this.availableFilters,
  });

  final String hintText;
  final List<T> items;
  final List<T> Function(
    List<T> items,
    String query,
    Map<String, dynamic> filters,
  )
  searchFilter;
  final void Function(List<T> filteredItems) onSearch;
  final Map<String, List<String>>? availableFilters;

  @override
  State<SearchBarWidget<T>> createState() => _SearchBarWidgetState<T>();
}

class _SearchBarWidgetState<T> extends State<SearchBarWidget<T>> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic> _selectedFilters = {};

  void _handleSearch() {
    final query = _controller.text.trim();
    final results = widget.searchFilter(widget.items, query, _selectedFilters);
    widget.onSearch(results);
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Select Filters"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    widget.availableFilters!.entries.map((entry) {
                      final key = entry.key;
                      final values = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: key,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                value: _selectedFilters[key],
                                borderRadius: BorderRadius.circular(20),
                                items:
                                    values
                                        .map(
                                          (v) => DropdownMenuItem(
                                            value: v,
                                            child: Text(v),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedFilters[key] = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilters.clear();
                  });
                  Navigator.pop(context);
                  _handleSearch();
                },
                child: const Text("Reset All"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleSearch();
                },
                child: const Text("Apply"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).cardColor,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.center,
                      height: 40,
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        onSubmitted: (_) => _handleSearch(),
                        onChanged: (_) => _handleSearch(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _handleSearch,
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  IconButton(
                    onPressed:
                        widget.availableFilters == null
                            ? null
                            : _openFilterDialog,
                    icon: Icon(
                      _selectedFilters.isNotEmpty
                          ? Icons.filter_alt
                          : Icons.filter_alt_outlined,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_selectedFilters.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  _selectedFilters.entries.map((e) {
                    return Chip(
                      deleteIconColor:
                          Theme.of(context).colorScheme.onTertiaryContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      label: Text(
                        "${e.key}: ${e.value}",
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                      onDeleted: () {
                        setState(() {
                          _selectedFilters.remove(e.key);
                        });
                        _handleSearch();
                      },
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }
}
