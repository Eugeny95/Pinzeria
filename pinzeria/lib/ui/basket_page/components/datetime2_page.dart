import 'dart:async';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pinzeria/ui/constants.dart';
import 'package:radio_grouped_buttons/custom_buttons/custom_radio_buttons_group.dart';

class DateTime2Page extends StatefulWidget {
  @override
  _DateTime2PageState createState() {
    return _DateTime2PageState();
  }
}

DateTime _dateTime = DateTime.now();

class _DateTime2PageState extends State<DateTime2Page> {
  int selectedIndex = -1; // Индекс выбранной кнопки
  int? selectedButton; // Хранит индекс выбранной кнопки
  bool isButtonEnabled = true; // Состояние кнопки

  // Цвета кнопок
  Color button1Color = kPrimaryColor;
  Color button2Color = Color.fromARGB(153, 140, 140, 140);

  void _onButtonPressed(int buttonIndex) {
    setState(() {
      selectedButton = buttonIndex; // Устанавливаем индекс выбранной кнопки
      // Меняем цвета кнопок в зависимости от нажатой
      if (buttonIndex == 1) {
        button1Color = kPrimaryColor; // Цвет для первой кнопки
        button2Color =
            Color.fromARGB(255, 205, 204, 204); // Цвет для второй кнопки
      } else if (buttonIndex == 2) {
        button1Color =
            Color.fromARGB(255, 209, 209, 209); // Цвет для первой кнопки
        button2Color = kPrimaryColor; // Цвет для второй кнопки
        _selectedDate = DateTime.now();
        List<String> _tempTimeList = generateTimeList(
            startTime: startTime,
            endTime: endTime,
            currentDateTime: DateTime.now(),
            selectedDate: _selectedDate);
        selectedDateTime = updateTimeInDateTime(
            _selectedDate, _tempTimeList.first.split('-').last);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkTime(); // Проверяем время при инициализации
  }

  void _checkTime() {
    DateTime now = DateTime.now();
    // Проверяем, если текущее время больше 23:00 или меньше 12:00
    if (now.hour > 22 || now.hour < 12) {
      setState(() {
        isButtonEnabled = false; // Деактивируем кнопку
      });
    } else {
      setState(() {
        isButtonEnabled = true; // Активируем кнопку
      });
    }
  }

  void _selectButton(int index) {
    setState(() {
      selectedIndex = index; // Устанавливаем индекс выбранной кнопки
    });
  }

  String formatDateTimeTo24Hour(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  DateTime updateTimeInDateTime(DateTime originalDateTime, String timeString) {
    // Разделяем строку на часы и минуты
    final parts = timeString.split(':');
    if (parts.length != 2) {
      throw FormatException('Неверный формат времени. Ожидается "HH:mm".');
    }

    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);

    // Проверяем корректность часов и минут
    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
      throw RangeError('Часы должны быть от 0 до 23, а минуты от 0 до 59.');
    }

    // Создаем новый объект DateTime с измененным временем
    return DateTime(
      originalDateTime.year,
      originalDateTime.month,
      originalDateTime.day,
      hours,
      minutes,
    );
  }

  int compareDates(DateTime date1, DateTime date2) {
    // Сравниваем только даты (без учета времени)
    DateTime dateOnly1 = DateTime(date1.year, date1.month, date1.day);
    DateTime dateOnly2 = DateTime(date2.year, date2.month, date2.day);

    return dateOnly1.compareTo(dateOnly2);
  }

  List<String> generateTimeList(
      {required String startTime,
      required String endTime,
      required DateTime currentDateTime,
      required DateTime selectedDate}) {
    List<String> times = [];
    DateTime timeForGeneration = updateTimeInDateTime(selectedDate, startTime);

    while (timeForGeneration
            .compareTo(updateTimeInDateTime(selectedDate, endTime)) ==
        -1) {
      String time1 = formatDateTimeTo24Hour(timeForGeneration);
      timeForGeneration = timeForGeneration.add(Duration(minutes: 30));
      String time2 = formatDateTimeTo24Hour(timeForGeneration);
      if (updateTimeInDateTime(selectedDate, time1).compareTo(DateTime.now()) ==
          1) {
        times.add(time1 + '-' + time2);
      }
    }
    return times;
  }

  int _selectedMins = 10;
  int _selectedHours = 1;
  String startTime = '12:00';
  String endTime = '22:30';
  Duration timeInterval = Duration(hours: 1);
  DateTime? selectedDateTime = DateTime.now().add(Duration(hours: 1));

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> buttonList = generateTimeList(
        startTime: startTime,
        endTime: endTime,
        currentDateTime: DateTime.now(),
        selectedDate: _selectedDate);

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromARGB(255, 42, 42, 42)),
          backgroundColor: kPrimaryColor,
          title: Text('Выбор времени доставки',
              style: TextStyle(
                  fontFamily: GoogleFonts.merriweather().fontFamily,
                  color: Color.fromARGB(201, 40, 40, 40),
                  fontSize: 18))),
      body: Column(
        children: [
          Container(
            height: height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              _onButtonPressed(1);
                            }
                          : null,
                      child: Text(
                        'Ближайшее время',
                        style: TextStyle(
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            color: const Color.fromARGB(255, 32, 32, 32),
                            fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: button1Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                        elevation: 5,
                        minimumSize: Size(
                            height * 0.15, width * 0.12), // Цвет первой кнопки
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => _onButtonPressed(2),
                      child: Text(
                        'Выбрать время',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 37, 37, 37),
                            fontSize: 12,
                            fontFamily: GoogleFonts.merriweather().fontFamily),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: button2Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                        elevation: 5,
                        minimumSize: Size(
                            height * 0.15, width * 0.12), // Цвет первой кнопки
                        // Цвет второй кнопки
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Отображаем виджет в зависимости от нажатой кнопки
                if (selectedButton == 1)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: height * 0.01),
                      Container(
                        color: Color.fromARGB(0, 120, 120, 120),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          DateFormat('dd.MM.yyyy    HH:mm')
                              .format(DateTime.now().add(Duration(hours: 1)))
                              .toString(),
                          style: TextStyle(
                            fontSize: height * 0.05,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  )
                else if (selectedButton == 2)
                  Column(
                    children: [
                      Container(
                        height: height * 0.1,
                        child: DatePicker(
                          DateTime.now(),
                          initialSelectedDate: DateTime.now(),
                          daysCount: 30,
                          dayTextStyle: TextStyle(
                              color: Color.fromARGB(255, 34, 34, 34),
                              fontSize: 12),
                          dateTextStyle: TextStyle(
                              color: Color.fromARGB(255, 34, 34, 34),
                              fontSize: 20),
                          monthTextStyle: TextStyle(
                              color: Color.fromARGB(255, 34, 34, 34),
                              fontSize: 10),
                          selectionColor: Color.fromARGB(255, 49, 49, 49),
                          selectedTextColor: Colors.white,
                          locale: "ru",
                          onDateChange: (day) {
                            // New date selected
                            setState(() {
                              _selectedDate = day;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      //Выбор времени
                      Center(
                        child: CustomRadioButton(
                          buttonLables: buttonList,
                          buttonValues: buttonList,
                          radioButtonValue: (value, index) {
                            selectedDateTime = updateTimeInDateTime(
                                _selectedDate, value.split('-').last);
                            print("Button value " + value.toString());
                            print("Integer value " + index.toString());
                          },
                          textColor: Colors.black,
                          selectedTextColor: Colors.black,
                          fontSize: height * 0.015,
                          horizontal: true,
                          enableShape: true,
                          buttonSpace: 5,
                          buttonColor: Color.fromARGB(255, 223, 223, 223),
                          selectedColor: kPrimaryColor,
                          buttonWidth: width * 0.3,
                        ),
                      ),
                      // Text(
                      //   selectedIndex == -1
                      //       ? "Не выбрано"
                      //       : "Выбрано: ${buttonLabels[selectedIndex]}",
                      //   style: TextStyle(fontSize: 20),
                      // ),
                      // ToggleButtons(
                      //   borderColor: const Color.fromARGB(255, 96, 96, 96),
                      //   isSelected: List.generate(buttonLabels.length,
                      //       (index) => index == selectedIndex),
                      //   onPressed: _selectButton,
                      //   children: buttonLabels
                      //       .map((label) => Padding(
                      //             padding: const EdgeInsets.all(16.0),
                      //             child: Text(label),
                      //           ))
                      //       .toList(),
                      // ),
                    ],
                  ),

                SizedBox(
                  height: height * 0.02,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
              elevation: 5,
              minimumSize: Size(height * 0.33, width * 0.13),
              backgroundColor: kFourthColor,
            ),
            child: Text('Подтвердить',
                style: (TextStyle(
                    fontSize: 13, color: Color.fromARGB(235, 227, 227, 227)))),
            onPressed: () async {
              Navigator.pop(context, {'selectedDateTime': selectedDateTime});
            },
          ),
        ],
      ),
    );
  }
}
