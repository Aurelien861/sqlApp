import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:myapp/providers/admin_provider.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/views/widgets/filters/filter_section.dart';
import 'package:myapp/views/widgets/lostObjects_grid.dart';
import 'package:myapp/views/widgets/sort_section.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';

class HomePage extends StatefulWidget {
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var normalTheme = Themes.normalTheme;
    var adminTheme = Themes.adminTheme;

    final lostObjectsProvider = Provider.of<LostObjectsProvider>(context);
    final adminProvider = Provider.of<AdminProvider>(context);

    final lostObjects = lostObjectsProvider.lostObjects;
    final countLostObjects = lostObjects.length;

    return ThemeSwitchingArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: ThemeSwitcher(
                  clipper: const ThemeSwitcherCircleClipper(),
                  builder: (context) {
                    return IconButton(
                      icon: Icon(
                        adminProvider.isAdmin
                            ? Icons.luggage
                            : Icons.admin_panel_settings,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: () {
                        ThemeSwitcher.of(context).changeTheme(
                            theme: adminProvider.isAdmin
                                ? normalTheme
                                : adminTheme,
                            isReversed: adminProvider.isAdmin ? true : false,);
                        adminProvider.toggleAdmin();
                      },
                    );
                  }),
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Center(
                        child: adminProvider.isAdmin
                            ? Image.asset(
                                'assets/images/background_sncf_pink.png',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              )
                            : Image.asset(
                                'assets/images/background_sncf.png',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adminProvider.isAdmin
                                  ? "Un object trouvé ? 🙂"
                                  : "Un objet perdu ? 🙃",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 16),
                            Text(
                                adminProvider.isAdmin
                                    ? "Ajoutez un objet trouvé, peut être que son propriétaire le recherche..."
                                    : "Recherchez votre bien, peut être que nous l'avons retrouvé...",
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 32),
                            SortSection(
                                lostObjectsProvider: lostObjectsProvider),
                            FilterSection(
                                lostObjectsProvider: lostObjectsProvider)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (lostObjects.isNotEmpty) ...[
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          "$countLostObjects objets trouvés",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  )),
                  LostObjectsGrid(newLostObjects: lostObjects),
                ],
                SliverToBoxAdapter(
                  child: lostObjectsProvider.isLoading
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            )));
  }
}
