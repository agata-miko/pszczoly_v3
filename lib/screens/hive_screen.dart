import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pszczoly_v3/models/note.dart';
import 'package:pszczoly_v3/screens/checklist_screen.dart';
import 'package:pszczoly_v3/widgets/image_input.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({super.key});

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive +hiveId')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
            ),
            const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ChecklistScreen()),);},
                  child: const Text('Nowa checklista'),
                ),
                const ElevatedButton(
                  onPressed: null,
                  child: Text('Poprzednie checklisty'),
                ),
              ],
            ),

            const SizedBox(height: 20,),
            const NoteEditor(),
          ],
        ),
      ),
    );
  }
}
