import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnify/notes/normal_notes/change_notifier/notes_provider.dart';
import 'package:learnify/notes/normal_notes/enums/order_option.dart';
import 'package:provider/provider.dart';

class ViewOptions extends StatefulWidget {
  const ViewOptions({super.key});

  @override
  State<ViewOptions> createState() => _ViewOptionsState();
}

class _ViewOptionsState extends State<ViewOptions> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(
                  () =>
                      notesProvider.isDescending = !notesProvider.isDescending,
                );
              },
              icon: FaIcon(
                notesProvider.isDescending
                    ? FontAwesomeIcons.arrowDown
                    : FontAwesomeIcons.arrowUp,
                color: Colors.grey,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            DropdownButton<OrderOption>(
              value: notesProvider.orderBy,
              icon: const FaIcon(
                FontAwesomeIcons.arrowDownWideShort,
                size: 18,
                color: Colors.grey,
              ),
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(16.0),
              items: OrderOption.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      Text(e.name),
                      if (e == notesProvider.orderBy) ...[
                        const SizedBox(width: 5),
                        const Icon(Icons.check, size: 16),
                      ],
                    ],
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) =>
                  OrderOption.values.map((e) => Text(e.name)).toList(),
              onChanged: (newValue) =>
                  setState(() => notesProvider.orderBy = newValue!),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  notesProvider.isGrid = !notesProvider.isGrid;
                });
              },
              icon: FaIcon(
                notesProvider.isGrid
                    ? FontAwesomeIcons.tableCellsLarge
                    : FontAwesomeIcons.bars,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
