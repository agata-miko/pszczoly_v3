import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pszczoly_v3/main.dart';
import 'package:pszczoly_v3/models/hive.dart';
import 'package:pszczoly_v3/models/language_constants.dart';
import 'package:pszczoly_v3/screens/add_hive_screen.dart';
import 'package:pszczoly_v3/screens/filtered_hives_list_screen.dart';
import 'package:pszczoly_v3/widgets/hives_list.dart';
import 'package:pszczoly_v3/providers/search_query_providers.dart';
import 'package:pszczoly_v3/widgets/sunset_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pszczoly_v3/widgets/search_bar.dart';
import 'package:pszczoly_v3/providers/search_bar_bool_provider.dart';

class HivesListScreen extends ConsumerWidget {
  HivesListScreen({super.key, required this.hives});

  final List<Hive> hives;
  final TextEditingController _searchController = TextEditingController();

  void _showAddHiveModal(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery
                  .of(context)
                  .size
                  .height * 0.8,
            ), // Adjust the height as needed
            child: const AddHiveScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(hivesSearchQueryProvider);
    bool searchBool = ref.watch(searchBarVisibilityProvider);
    return SafeArea(
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: AppBar(
          centerTitle: false,
          title: searchBool == false ? Text('logo??') : SearchBarHive(searchController: _searchController),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _searchController.clear();
                  ref
                      .read(hivesSearchQueryProvider.notifier)
                      .updateSearchQuery('');
                  ref.read(searchBarVisibilityProvider.notifier).toggleSearchBool();
                }),
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              //in case of more languages they can be moved to the list that would be used to create the items
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                    value: 'pl',
                    child: Text(AppLocalizations.of(context)!.polishFlag)),
                PopupMenuItem<String>(
                    value: 'en',
                    child: Text(AppLocalizations.of(context)!.englishFlag)),
              ],
              offset: const Offset(0, 40),
              onSelected: (String? language) async {
                if (language != null) {
                  Locale? locale = await setLocale(language);
                  if (!context.mounted) return;
                  MyApp.setLocale(context, locale!);
                }
              },
            ),
          ],
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SunsetWidget(),
                ],
              ),
              HivesList(),
            ],
          ),
        ),
        bottomNavigationBar:
        Container(
          //   decoration: BoxDecoration(boxShadow: [
          //   BoxShadow(
          //   color: Colors.black.withOpacity(0.1),
          //   spreadRadius: 1,
          //   blurRadius: 12,
          //   offset: const Offset(0, -1),
          // )], color: Theme.of(context).colorScheme.primaryContainer,),
          height: MediaQuery
              .of(context)
              .size
              .height * 0.12,
          child: Column(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  _showAddHiveModal(context);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (ctx) => const AddHiveScreen(),
                  //   ),
                  // );
                },
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
                elevation: 8,
                child: const Icon(Icons.add_home),

              ),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
              //   // IconButton(onPressed: () {}, icon: Icon(Icons.home)),
              //   IconButton(onPressed: () {_showAddHiveModal(context);}, icon: Icon(Icons.add_home)),
              // ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                    text: TextSpan(
                        text: AppLocalizations.of(context)!.iconsBy,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall,
                        children: <TextSpan>[
                          TextSpan(
                              text: AppLocalizations.of(context)!.icons8,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(decoration: TextDecoration
                                  .underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrlString('https://icons8.com');
                                })
                        ]),
                  ),
                  const VerticalDivider(
                    width: 20,
                    indent: 4,
                    thickness: 1,
                    endIndent: 4,
                    color: Colors.grey,
                  ),
                  RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.sunData,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall,
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!.ssIo,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrlString('https://sunrisesunset.io');
                            },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


