import 'package:flutter/material.dart';
import 'package:myapp/providers/lost_objects_provider.dart';

class CustomDatePickerDialog extends StatelessWidget {
  final LostObjectsProvider lostObjectsProvider;

  const CustomDatePickerDialog({
    Key? key,
    required this.lostObjectsProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? dateFilter = lostObjectsProvider.dateFilter;

    return AlertDialog(
      actionsPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.all(8),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      title: const Text(
        'Quand avez-vous perdu votre bien ?',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      content: SizedBox(
        width: 1000,
        child: CalendarDatePicker(
          initialDate: dateFilter,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          onDateChanged: (picked) {
            dateFilter = picked;
          },
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                lostObjectsProvider.resetDate();
                Navigator.pop(context);
              },
              child: Text(
                'Réinitialiser',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Annuler',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (dateFilter != null) {
                      lostObjectsProvider.setSelectedDate(dateFilter!);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static void show(BuildContext context, LostObjectsProvider lostObjectsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePickerDialog(
          lostObjectsProvider: lostObjectsProvider,
        );
      },
    );
  }
}
