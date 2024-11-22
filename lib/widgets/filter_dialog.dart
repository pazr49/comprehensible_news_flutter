import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final String? selectedLevel;
  final String? selectedLanguage;

  const FilterDialog({
    Key? key,
    this.selectedLevel,
    this.selectedLanguage,
  }) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _level;
  String? _language;

  @override
  void initState() {
    super.initState();
    _level = widget.selectedLevel;
    _language = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Articles'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Level'),
              items: ['A1', 'A2', 'B1']
                  .map((lvl) => DropdownMenuItem(
                        value: lvl,
                        child: Text(lvl),
                      ))
                  .toList(),
              value: _level,
              onChanged: (value) {
                setState(() {
                  _level = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Language'),
              items: ['es', 'fr', 'en']
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              value: _language,
              onChanged: (value) {
                setState(() {
                  _language = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog without changes
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'level': _level,
              'language': _language,
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
