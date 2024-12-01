import 'package:flutter/material.dart';

class CategoryButtons extends StatefulWidget {
  final String initialSelectedCategory;
  final Function(String) onCategorySelected; // Add this line

  const CategoryButtons({Key? key, required this.initialSelectedCategory, required this.onCategorySelected}) : super(key: key);

  @override
  _CategoryButtonsState createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  late String _selectedCategory;

  final Map<String, String> _categoryMap = {
    'Today\'s News': 'todays-news',
    'Top Picks': 'top-picks',
  };

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialSelectedCategory;
  }

  void _onCategorySelected(String displayCategory) {
    setState(() {
      _selectedCategory = _categoryMap[displayCategory]!;
      widget.onCategorySelected(_selectedCategory); // Call the callback function
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCategoryButton('Today\'s News'),
        const SizedBox(width: 10), // Spacing between buttons
        _buildCategoryButton('Top Picks'),
      ],
    );
  }

  Widget _buildCategoryButton(String displayCategory) {
    final bool isSelected = _selectedCategory == _categoryMap[displayCategory];
    return GestureDetector(
      onTap: () => _onCategorySelected(displayCategory),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey[300], // Color for selected vs unselected
          borderRadius: BorderRadius.circular(5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          displayCategory,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
