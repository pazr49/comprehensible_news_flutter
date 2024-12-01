import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final String? selectedLevel;
  final String? selectedLanguage;

  const FilterDialog({
    super.key,
    this.selectedLevel,
    this.selectedLanguage,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _level;
  String? _language;

  final Map<String, String> _languageMap = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
  };

  @override
  void initState() {
    super.initState();
    _level = widget.selectedLevel;
    _language = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a language'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Language'),
              items: _languageMap.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
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
              'language': _language,
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
