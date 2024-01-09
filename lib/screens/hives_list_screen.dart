import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pszczoly_v3/models/hive.dart';
import 'package:pszczoly_v3/screens/add_hive_screen.dart';
import 'package:pszczoly_v3/widgets/hives_list.dart';

class HivesListScreen extends ConsumerWidget {
  const HivesListScreen({super.key, required this.hives});

  final List<Hive> hives;

  @override
  Widget build(BuildContext context, ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista uli'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [const SizedBox(width: 150, height: 37,child: SearchBar(hintText: 'Wyszukaj'),),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const AddHiveScreen(),
                      ),
                    );
                  },
                  child: Text('Dodaj nowy ul', style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(height: 400, child: HivesList()),
          ],
        ),
      ),
    );
  }
}
