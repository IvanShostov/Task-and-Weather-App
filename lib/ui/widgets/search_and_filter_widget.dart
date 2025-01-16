import 'package:flutter/material.dart';

/// SearchAndFilterWidget provides a search bar and a filter button for tasks.
class SearchAndFilterWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onFilterPressed;
  final bool isFilterActive;

  const SearchAndFilterWidget({
    super.key,
    required this.onSearch,
    required this.onFilterPressed,
    required this.isFilterActive,
  });

  @override
  State<SearchAndFilterWidget> createState() => _SearchAndFilterWidgetState();
}

class _SearchAndFilterWidgetState extends State<SearchAndFilterWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, top: 12, right: 10),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                focusNode: _focusNode,
                onChanged: widget.onSearch,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                onTapOutside: (_) => _focusNode.unfocus(),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _focusNode.unfocus();
              widget.onFilterPressed();
            },
            icon: Icon(
              Icons.filter_list_outlined,
              color: widget.isFilterActive ? Colors.blue : Colors.grey,
            ),
            tooltip: 'Filter',
          ),
        ],
      ),
    );
  }
}
