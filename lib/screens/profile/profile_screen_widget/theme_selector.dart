import 'package:flutter/material.dart';
import 'package:learnify/services/theme_service.dart';
import 'package:provider/provider.dart';

class ThemeSelectorTile extends StatelessWidget {
  const ThemeSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(Icons.color_lens, color: Colors.white70),
        title: const Text(
          "App Theme",
          style: TextStyle(color: Colors.white),
        ),
        trailing: DropdownButton<AppTheme>(
          value: themeService.theme,
          underline: const SizedBox(),
          dropdownColor: const Color(0xFF1C1A2E),
          iconEnabledColor: Colors.white,
          items: const [
            DropdownMenuItem(
              value: AppTheme.system,
              child: Text("System"),
            ),
            DropdownMenuItem(
              value: AppTheme.light,
              child: Text("Light"),
            ),
            DropdownMenuItem(
              value: AppTheme.dark,
              child: Text("Dark"),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              themeService.setTheme(value);
            }
          },
        ),
      ),
    );
  }
}
