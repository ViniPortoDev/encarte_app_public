import 'package:app_prod_atacado/app/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FilialFilter extends StatefulWidget {
  const FilialFilter({super.key});

  @override
  State<FilialFilter> createState() => _FilialFilterState();
}

class _FilialFilterState extends State<FilialFilter> {
  HomeStore store = Modular.get<HomeStore>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(fontSize: width < 400 ? 8 : 12);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Filial:'),
        const SizedBox(width: 5),
        SegmentedButton<int>(
          segments: [
            ButtonSegment<int>(
              value: 14,
              label: Text(
                '14',
                style: style,
              ),
            ),
            ButtonSegment<int>(
              value: 15,
              label: Text(
                '15',
                style: style,
              ),
            ),
          ],
          selected: {store.filial},
          onSelectionChanged: (value) {
            setState(() {
              store.filial = value.first;
            });
          },
        ),
      ],
    );
  }
}
