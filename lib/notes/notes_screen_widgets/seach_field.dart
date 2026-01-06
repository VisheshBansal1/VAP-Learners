import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnify/notes/change_notifier/notes_provider.dart';
import 'package:provider/provider.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    searchController.addListener(() {
      context.read<NotesProvider>().searchTerm =
          searchController.text.trim();
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search notes',
        prefixIcon: const Icon(
          FontAwesomeIcons.magnifyingGlass,
          size: 16,
        ),

        // ❌ / ✔ clear button
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  FontAwesomeIcons.circleXmark,
                  size: 16,
                ),
                onPressed: () {
                  searchController.clear();
                },
              )
            : null,

        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
