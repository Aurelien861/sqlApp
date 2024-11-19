import 'package:flutter/material.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/utils/map_nature_img.dart';
import 'package:myapp/utils/util_functions.dart';

class ObjectCard extends StatelessWidget {
  final LostObject lostObject;
  final double width;
  final double height;

  const ObjectCard({
    super.key,
    required this.lostObject,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    double imageSpace = 0.8 * width;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        pathForObjectNature(lostObject.nature ?? ''),
                        fit: BoxFit.cover,
                        width: imageSpace,
                      ),
                    ),
                  ]),
            ),
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                Text(
                  lostObject.startStation ?? 'Gare introuvée',
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                Text(
                  lostObject.nature ?? "Nature de l'objet introuvée",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            )
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    formatDate(lostObject.date, 'dd MMM yyyy'),
                    style: TextStyle(
                        fontSize: 10, color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
