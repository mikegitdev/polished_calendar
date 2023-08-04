import 'package:flutter/material.dart';

import 'config.dart';
import 'data.dart';

final today = DateUtils.dateOnly(DateTime.now());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dock a Boat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dock a Boat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DateTime?> _rangeDatePickerWithActionButtonsWithValue = [];
  List<List<DateTime?>> listOfDates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 375,
          child: ListView(
            children: <Widget>[
              _buildCalendarWithActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  Widget _buildCalendarWithActionButtons() {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      selectableDayPredicate: (day) {
        for (List<DateTime?> range in listOfDates) {
          if (range.length == 1) {
            if (day.isAtSameMomentAs(range[0]!)) {
              return false;
            }
          } else if ((day.isAfter(range[0]!) ||
                  day.isAtSameMomentAs(range[0]!)) &&
              (day.isBefore(range[1]!) || day.isAtSameMomentAs(range[1]!))) {
            return false;
          }
        }

        return true;
      },
      disableModePicker: true,
      centerAlignModePicker: true,
      selectedRangeHighlightColor: const Color(0xFF0E5CCD),
      controlsTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      dayTextStyle: const TextStyle(
        color: Color.fromARGB(255, 228, 225, 225),
      ),
      disabledDayTextStyle: const TextStyle(color: Color(0xFF848EA1)),
      weekdayLabelTextStyle: const TextStyle(
        color: Color(0xFF848EA1),
      ),
      dayBorderRadius: BorderRadius.circular(8),
      selectedDayHighlightColor: const Color(0xFF0E5CCD),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
      ),
      gapBetweenCalendarAndButtons: 20,
      selectedRangeDayTextStyle: const TextStyle(
        color: Colors.white,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker2WithActionButtons(
          config: config,
          value: _rangeDatePickerWithActionButtonsWithValue,
          onValueChanged: (dates) {
            setState(() {
              _rangeDatePickerWithActionButtonsWithValue = dates;
              listOfDates.add(_rangeDatePickerWithActionButtonsWithValue);
              // print(listOfDates);
            });
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                _getValueText(
                  config.calendarType,
                  _rangeDatePickerWithActionButtonsWithValue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
