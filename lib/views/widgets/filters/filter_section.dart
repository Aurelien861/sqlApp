import 'package:flutter/material.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:myapp/views/pages/filter_page.dart';
import 'package:myapp/views/widgets/filters/date_picker_filter.dart';

class FilterSection extends StatelessWidget {
  final LostObjectsProvider lostObjectsProvider;

  const FilterSection({
    Key? key,
    required this.lostObjectsProvider,
  }) : super(key: key);

  Widget _buildDateFilterButton(BuildContext context, lostObjectsProvider) {
    String selectedDate =
        formatDate(lostObjectsProvider.dateFilter.toString(), "d MMM yyyy");
    String butonLabel = selectedDate != 'Date invalide' ? selectedDate : 'Date';
    return ElevatedButton.icon(
        onPressed: () {
          CustomDatePickerDialog.show(context, lostObjectsProvider);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 1),
          ),
        ),
        icon: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.inversePrimary),
        label: Text(butonLabel, style: Theme.of(context).textTheme.bodyMedium));
  }

  Widget _buildNatureFilterButton(
      BuildContext context, LostObjectsProvider lostObjectsProvider) {
    int numberOfNatures = lostObjectsProvider.natureFilter.length;
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(
                filterType: 'Nature de l\'objet',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 1),
          ),
        ),
        child: Row(
          children: [
            Text('Nature de l\'objet',
                style: Theme.of(context).textTheme.bodyMedium),
            if (numberOfNatures > 0) ...[
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  numberOfNatures.toString(),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
            ]
          ],
        ));
  }

  Widget _buildTypeFilterButton(
      BuildContext context, LostObjectsProvider lostObjectsProvider) {
    int numberOfTypes = lostObjectsProvider.typeFilter.length;
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(
                filterType: 'Type d\'objet',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 1),
          ),
        ),
        child: Row(
          children: [
            Text('Type d\'objet',
                style: Theme.of(context).textTheme.bodyMedium),
            if (numberOfTypes > 0) ...[
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  numberOfTypes.toString(),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
            ]
          ],
        ));
  }

  Widget _buildStationFilterButton(
      BuildContext context, LostObjectsProvider lostObjectsProvider) {
    int numberOfStations = lostObjectsProvider.stationFilter.length;
    return ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(
                filterType: 'Gare de départ',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 1),
          ),
        ),
        icon: Icon(Icons.location_city, color: Theme.of(context).colorScheme.inversePrimary),
        label: Row(
          children: [
            Text('Gare de départ',
                style: Theme.of(context).textTheme.bodyMedium),
            if (numberOfStations > 0) ...[
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  numberOfStations.toString(),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
            ]
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildDateFilterButton(context, lostObjectsProvider),
          const SizedBox(width: 8.0),
          _buildStationFilterButton(context, lostObjectsProvider),
          const SizedBox(width: 8.0),
          _buildTypeFilterButton(context, lostObjectsProvider),
          const SizedBox(width: 8.0),
          _buildNatureFilterButton(context, lostObjectsProvider),
        ],
      ),
    );
  }
}
