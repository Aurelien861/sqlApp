import 'package:flutter/material.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:myapp/views/pages/home_page.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  final String filterType;

  FilterPage(
      {required this.filterType,});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<String> selectedFilters = [];
  List<String> allFilters = [];
  List<String> searchedFilters = [];

  @override
  void initState() {
    super.initState();
    final lostObjectsProvider =
        Provider.of<LostObjectsProvider>(context, listen: false);
    if (widget.filterType == 'Gare de départ') {
      selectedFilters = lostObjectsProvider.stationFilter;
      allFilters = lostObjectsProvider.allStations;
    } else if (widget.filterType == 'Nature de l\'objet') {
      selectedFilters = lostObjectsProvider.natureFilter;
      allFilters = lostObjectsProvider.allNatures;
    } else if (widget.filterType == 'Type d\'objet') {
      selectedFilters = lostObjectsProvider.typeFilter;
      allFilters = lostObjectsProvider.allTypes;
    }
    allFilters.sort();
    searchedFilters = [...allFilters];
  }

  void toggleFilter(String filter, LostObjectsProvider lostObjectsProvider) {
    setState(() {
      if (selectedFilters.contains(filter)) {
        selectedFilters.remove(filter);
      } else {
        selectedFilters.add(filter);
      }
      if (widget.filterType == 'Gare de départ') {
        lostObjectsProvider.setSelectedStations(selectedFilters);
      } else if (widget.filterType == 'Nature de l\'objet') {
        lostObjectsProvider.setSelectedNatures(selectedFilters);
      } else if (widget.filterType == 'Type d\'objet') {
        lostObjectsProvider.setSelectedTypes(selectedFilters);
      }
    });
  }

  void resetFilter(LostObjectsProvider lostObjectsProvider) {
    setState(() {
      if (widget.filterType == 'Gare de départ') {
        lostObjectsProvider.setSelectedStations([]);
      } else if (widget.filterType == 'Nature de l\'objet') {
        lostObjectsProvider.setSelectedNatures([]);
      } else if (widget.filterType == 'Type d\'objet') {
        lostObjectsProvider.setSelectedTypes([]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lostObjectsProvider =
        Provider.of<LostObjectsProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).colorScheme.inversePrimary
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '${widget.filterType} (${selectedFilters.length})',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedFilters.clear();
              });
              resetFilter(lostObjectsProvider);
            },
            child: Text(
              'Réinitialiser',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            height: 2.0,
          ),
        ),
      ),
      body: Column(
        children: [
          TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              border: InputBorder.none,
              hintText: 'Saisir ${widget.filterType.toLowerCase()}',
              hintStyle: const TextStyle(color: Color(0xFFE0E0E0)),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFFE0E0E0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchedFilters = allFilters
                    .where((filter) =>
                        containsIgnoringCaseAndAccents(filter, value))
                    .toList();
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchedFilters.length,
              itemBuilder: (context, index) {
                String filter = searchedFilters[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        filter,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: selectedFilters.contains(filter)
                          ? Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary)
                          : null,
                      selected: selectedFilters.contains(filter),
                      selectedTileColor: Theme.of(context).colorScheme.tertiary,
                      onTap: () => toggleFilter(filter, lostObjectsProvider),
                    ),
                    if (!selectedFilters.contains(filter))
                      Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: SizedBox(
                            height: 1,
                            child: Divider(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ))
                  ],
                );
              },
            ),
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Theme.of(context).primaryColor,
                      shadowColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: !lostObjectsProvider.isLoading
                        ? Text(
                            'Voir ${formatLargeNumber(lostObjectsProvider.lostObjects.length)} résultats',
                            style: const TextStyle(color: Color(0xFFE0E0E0)),
                          )
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )),
              ))
            ],
          )
        ],
      ),
    );
  }
}
