import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String? imagePath;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    this.imagePath,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  File? selectedImage;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);

    if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      final file = File(widget.imagePath!);
      if (file.existsSync()) selectedImage = file;
    }
  }

  // ---------------- IMAGE PICKING ----------------

  Future<void> pickFromGallery() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> pickFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _showSnack("Camera permission denied");
      return;
    }

    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  // ---------------- SAVE ----------------

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      _showSnack("Name cannot be empty");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': name,
        'profileImage': selectedImage?.path,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context, {
        'name': name,
        'email': widget.email,
        'imagePath': selectedImage?.path,
      });

      _showSnack("Profile updated");
    } catch (_) {
      _showSnack("Update failed");
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final avatar = selectedImage != null
        ? FileImage(selectedImage!)
        : const NetworkImage(
            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
          ) as ImageProvider;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔙 BACK
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 AVATAR
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: avatar,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text("Gallery"),
                                onTap: () {
                                  Navigator.pop(context);
                                  pickFromGallery();
                                },
                              ),
                              if (Platform.isAndroid || Platform.isIOS)
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text("Camera"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pickFromCamera();
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.deepPurpleAccent,
                      child:
                          Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 🔥 FORM
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle:
                            const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Save Changes",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
