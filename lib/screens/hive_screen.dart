import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pszczoly_v3/screens/checklist_screen.dart';
import 'package:pszczoly_v3/screens/checklists_list_screen.dart';
import 'package:pszczoly_v3/widgets/image_input.dart';
import '../providers/hive_list_provider.dart';

// //ignore: must_be_immutable - this comment make flutter ignore this warning
class HiveScreen extends ConsumerStatefulWidget {
  HiveScreen(
      {super.key,
      this.selectedImage,
      required this.hiveName,
      required this.hiveId});

  File? selectedImage;
  String hiveName;
  String hiveId;

  @override
  ConsumerState<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends ConsumerState<HiveScreen> {
  updateHiveData(BuildContext context, File newImage) {
    ref
        .read(hiveDataProvider.notifier)
        .updateHivePhoto(widget.hiveName, newImage);
    ref.read(databaseProvider).updateHivePhoto(widget.hiveId, newImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.hiveName)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.selectedImage != null &&
                      widget.selectedImage!.path.isNotEmpty &&
                      File(widget.selectedImage!.path).existsSync()
                  ? SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Image.file(
                        widget.selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ImageInput(onPickImage: (image) {
                      widget.selectedImage = image;
                    }, updateHiveData: (image) {
                      updateHiveData(context, image);
                    }),
            ),
            widget.selectedImage == null
                ? TextButton(
                    onPressed: () {
                      ref.read(hiveDataProvider.notifier).updateHivePhoto(
                          widget.hiveName, widget.selectedImage);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Dodaj zdjęcie'),
                  )
                : const SizedBox(
                    height: 20,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => ChecklistScreen(
                                hiveId: widget.hiveId,
                                hiveName: widget.hiveName,
                              )),
                    );
                  },
                  child: const Text('Nowa checklista'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => ChecklistListScreen()),
                    );
                  },
                  child: const Text('Poprzednie checklisty'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // const NoteEditor(),
          ],
        ),
      ),
    );
  }
}
