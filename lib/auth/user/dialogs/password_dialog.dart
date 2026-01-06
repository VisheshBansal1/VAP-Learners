import 'package:flutter/material.dart';

Future<String?> showPasswordDialog(BuildContext context) async {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;
  String? errorText;

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1C2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Set Password',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: passwordController,
                  obscureText: obscure1,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter new password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure1 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() => obscure1 = !obscure1);
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFF2A2838),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmController,
                  obscureText: obscure2,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() => obscure2 = !obscure2);
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFF2A2838),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    errorText!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final password = passwordController.text.trim();
                  final confirm = confirmController.text.trim();

                  if (password.isEmpty || confirm.isEmpty) {
                    setState(() => errorText = 'Please fill both fields');
                    return;
                  }

                  if (password != confirm) {
                    setState(() => errorText = 'Passwords do not match');
                    return;
                  }

                  if (password.length < 8) {
                    setState(() => errorText =
                        'Password must be at least 8 characters');
                    return;
                  }

                  if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])')
                      .hasMatch(password)) {
                    setState(() => errorText =
                        'Must include upper, lower case letters & a number');
                    return;
                  }

                  Navigator.pop(context, password);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
