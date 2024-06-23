import 'package:flutter/material.dart';
import '../../model/app_constants.dart';

class CalenderUI extends StatefulWidget {
  final int? monthIndex;
  final List<DateTime>? bookedDates;
  final Function? selectDate;
  final Function? getSelectedDates;

  const CalenderUI({
    super.key,
    this.getSelectedDates,
    this.selectDate,
    this.monthIndex,
    this.bookedDates,
  });

  @override
  State<CalenderUI> createState() => _CalenderUIState();
}

class _CalenderUIState extends State<CalenderUI> {
  List<DateTime> _selectedDates = [];
  List<MonthTileWidget> _monthTiles = [];
  int? _currentMonthInt;
  int? _currentYearInt;

  _setUpMonthTiles() {
    _monthTiles = [];

    int daysInMonth = AppConstants.daysInMonths![_currentMonthInt]!;
    DateTime firstDayOfMonth = DateTime(_currentYearInt!, _currentMonthInt!, 1);
    int firstWeekOfMonth = firstDayOfMonth.weekday;

    if (firstWeekOfMonth != 7) {
      for (int i = 0; i < firstWeekOfMonth; i++) {
        _monthTiles.add(MonthTileWidget(dateTime: null));
      }
    }

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(_currentYearInt!, _currentMonthInt!, i);
      _monthTiles.add(MonthTileWidget(dateTime: date));
    }
  }

  _selectDate(DateTime date) {
    if (_selectedDates.contains(date)) {
      _selectedDates.remove(date);
    } else {
      _selectedDates.add(date);
    }

    widget.selectDate!(date);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _currentMonthInt = (DateTime.now().month + widget.monthIndex!) % 12;

    if (_currentMonthInt == 0) {
      _currentMonthInt = 12;
    }

    _currentYearInt = DateTime.now().year;

    if (_currentMonthInt! < DateTime.now().month) {
      _currentYearInt = _currentYearInt! + 1;
    }

    _selectedDates.sort();
    _selectedDates.addAll(widget.getSelectedDates!());

    _setUpMonthTiles();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
                onPressed: () {
                  setState(() {
                    _currentMonthInt = (_currentMonthInt! - 1) % 12;
                    if (_currentMonthInt == 0) {
                      _currentMonthInt = 12;
                      _currentYearInt = _currentYearInt! - 1;
                    }
                    _setUpMonthTiles();
                  });
                },
              ),
              Text(
                "${AppConstants.monthDict[_currentMonthInt]} - $_currentYearInt",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.green),
                onPressed: () {
                  setState(() {
                    _currentMonthInt = (_currentMonthInt! + 1) % 12;
                    if (_currentMonthInt == 1) {
                      _currentYearInt = _currentYearInt! + 1;
                    }
                    _setUpMonthTiles();
                  });
                },
              ),
            ],
          ),
        ),
        const Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('SUN'),
            Text('MON'),
            Text('TUE'),
            Text('WED'),
            Text('THU'),
            Text('FRI'),
            Text('SAT'),
          ],
        ),
        GridView.builder(
          itemCount: _monthTiles.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1 / 1,
          ),
          itemBuilder: (context, index) {
            MonthTileWidget monthTile = _monthTiles[index];

            if (monthTile.dateTime == null) {
              return const SizedBox.shrink();
            }

            bool isBooked = widget.bookedDates!.contains(monthTile.dateTime);
            bool isSelected = _selectedDates.contains(monthTile.dateTime);
            bool isToday = DateTime.now().day == monthTile.dateTime!.day &&
                DateTime.now().month == monthTile.dateTime!.month &&
                DateTime.now().year == monthTile.dateTime!.year;

            return MaterialButton(
              onPressed: isBooked
                  ? null
                  : () {
                _selectDate(monthTile.dateTime!);
              },
              color: isBooked
                  ? Colors.yellow
                  : isSelected
                  ? Colors.green[200]
                  : Colors.white,
              disabledColor: Colors.yellow,
              shape: CircleBorder(
                side: BorderSide(
                  color: isToday ? Colors.green : Colors.transparent,
                  width: 2,
                ),
              ),
              child: monthTile,
            );
          },
        ),
      ],
    );
  }
}

class MonthTileWidget extends StatelessWidget {
  final DateTime? dateTime;

  const MonthTileWidget({super.key, this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        dateTime == null ? "" : dateTime!.day.toString(),
        style: const TextStyle(
          fontSize: 11,
        ),
      ),
    );
  }
}
