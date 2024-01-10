import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pszczoly_v3/models/hive.dart';
import 'package:pszczoly_v3/providers/hive_list_provider.dart';
import 'package:pszczoly_v3/screens/checklist_screen.dart';
import 'package:pszczoly_v3/screens/hive_screen.dart';

class HivesList extends ConsumerStatefulWidget {
  const HivesList({super.key});

  @override
  ConsumerState<HivesList> createState() {
    return _HivesListState();
  }
}

class _HivesListState extends ConsumerState<HivesList> {
  @override
  Widget build(BuildContext context) {
    ref.watch(hiveDataProvider);
    final Future<List<Map<String, dynamic>>> hivesListFromDatabase =
        ref.read(databaseProvider).getAllHives();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: hivesListFromDatabase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Zaden ul nie zostal jeszcze dodany. Dodaj teraz!'),
          );
        } else {
          final List<Hive> hivesList = snapshot.data!
              .map((row) => Hive(
                    hiveName: row['hiveName'] as String,
                    hiveId: row['hiveId'] as String,
                    photo: File('${row['photoPath']}'),
                  ))
              .toList();
          return ListView.builder(
            itemCount: hivesList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: hivesList[index].photo != null
                      ? BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(hivesList[index].photo!),
                          ))
                      : BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                ),
                title: Text(
                  hivesList[index].hiveName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ChecklistScreen(
                                hiveId: hivesList[index].hiveId,
                                hiveName: hivesList[index].hiveName,
                              )));
                    },
                    icon: const Icon(Icons.checklist)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HiveScreen(
                          hiveName: hivesList[index].hiveName,
                          selectedImage: hivesList[index].photo,
                          hiveId: hivesList[index].hiveId),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
