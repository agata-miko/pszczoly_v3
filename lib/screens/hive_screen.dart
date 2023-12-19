import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pszczoly_v3/models/note.dart';
import 'package:pszczoly_v3/screens/checklist_screen.dart';
import 'package:pszczoly_v3/widgets/image_input.dart';

class HiveScreen extends StatefulWidget {
  HiveScreen({super.key, this.selectedImage, required this.hiveName});

  File? selectedImage;
  String hiveName;

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.hiveName)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.selectedImage != null
                  ? SizedBox(height: 250, width: double.infinity,
                    child: Image.file(
                        widget.selectedImage!,
                        fit: BoxFit.cover,
                      ),
                  )
                  : ImageInput(
                      onPickImage: (image) {
                        widget.selectedImage = image;
                      },
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => const ChecklistScreen()),
                    );
                  },
                  child: const Text('Nowa checklista'),
                ),
                const ElevatedButton(
                  onPressed: null,
                  child: Text('Poprzednie checklisty'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const NoteEditor(),
          ],
        ),
      ),
    );
  }
}
