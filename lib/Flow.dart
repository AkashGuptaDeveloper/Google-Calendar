// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
//----------------------------------------------------------------------------//
class TodoWidget extends StatefulWidget {
  const TodoWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}
//----------------------------------------------------------------------------//
class _TodoWidgetState extends State<TodoWidget> {
  final List<Appointment> _appointments = <Appointment>[];
  late AppointmentDataSource _dataSource;
  int selectedIndex = 0; // 0 for Day, 1 for Month

  CalendarView calendarView = CalendarView.day;
  CalendarController calendarController = CalendarController();
//----------------------------------------------------------------------------//
  @override
  void initState() {
    super.initState();
    _dataSource = AppointmentDataSource(_appointments);
  }
//----------------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3788D3),
        title: Text(
          "Todo",
          style: TextStyle(
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: 1),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Calendar view (left half of screen)
          Expanded(
            child: SfCalendar(
              todayHighlightColor: Colors.green,
              controller: calendarController,
              backgroundColor: Colors.transparent,
              allowAppointmentResize: true,
              allowDragAndDrop: true,
              view: calendarView, // If Month is selected
              initialDisplayDate: DateTime.now(),
              dataSource: _dataSource,
              onTap: _onCalendarTap,
              monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  showAgenda: true),
              blackoutDates: [
                DateTime.now().subtract(Duration(hours: 48)),
                DateTime.now().subtract(Duration(hours: 28)),
              ],
              selectionDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  shape: BoxShape.rectangle),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
//----------------------------------------------------------------------------//
  void _onCalendarTap(CalendarTapDetails details) {
    setState(() {
      if (details.targetElement == CalendarElement.appointment) {
        Appointment clickedAppointment = details.appointments!.first;
        _showEventDetailsDialog(clickedAppointment);
      } else if (details.targetElement == CalendarElement.calendarCell) {
        DateTime selectedDate = details.date!;
        DateTime? startDate;
        DateTime? endDate;
        Color selectedColor = const Color(0xFF3788D3); // Default color
        TextEditingController eventController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => PopScope(
            canPop: false,
            onPopInvoked: (didPop) async => false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            child: Text(
                              "Add Activity",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  letterSpacing: 1),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.3,
                          ),
                          SizedBox(height: 5.0),
                          CupertinoTextField(
                            controller: eventController,
                            keyboardType: TextInputType.name,
                            enabled: true,
                            placeholder: 'Task Name',
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                            placeholderStyle: TextStyle(
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                letterSpacing: 0.5),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            padding: EdgeInsets.all(16.0),
                          ),
                          SizedBox(height: 13.0),
                          CupertinoTextField(
                            controller: descriptionController,
                            keyboardType: TextInputType.name,
                            enabled: true,
                            placeholder: 'Task Description',
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                            placeholderStyle: TextStyle(
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                letterSpacing: 0.5),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            padding: EdgeInsets.all(16.0),
                          ),
                          SizedBox(height: 13.0),
                          GestureDetector(
                            onTap: () async {
                              hideKeyboard(context);
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  setState(() {
                                    startDate = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                  });
                                }
                              }
                            },
                            child: _buildDatePickerField(startDate, 'Start'),
                          ),
                          SizedBox(height: 13.0),
                          GestureDetector(
                            onTap: () async {
                              hideKeyboard(context);
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  setState(() {
                                    endDate = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                  });
                                }
                              }
                            },
                            child: _buildDatePickerField(endDate, 'End'),
                          ),
                          SizedBox(height: 13.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedColor,
                              // Customize button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the value for rounded corners
                              ),
                            ),
                            onPressed: () {
                              hideKeyboard(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Pick a color',
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          letterSpacing: 0.5,
                                        )),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                        pickerColor: selectedColor,
                                        onColorChanged: (Color color) {
                                          setState(() {
                                            selectedColor = color;
                                          });
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Done',
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontStyle: FontStyle.normal,
                                            color:
                                            Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Select Color',
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                )),
                          ),
                          SizedBox(height: 13.0),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3788D3),
                                    // Customize button color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the value for rounded corners
                                    ),
                                  ),
                                  onPressed: () {
                                    hideKeyboard(context);
                                    if (eventController.text.isNotEmpty &&
                                        descriptionController.text.isNotEmpty &&
                                        startDate != null &&
                                        endDate != null &&
                                        startDate!.isBefore(endDate!)) {
                                      setState(() {
                                        _appointments.add(Appointment(
                                          startTime: startDate!,
                                          endTime: endDate!,
                                          subject: eventController.text,
                                          notes: descriptionController.text,
                                          color: selectedColor,
                                        ));
                                      });
                                      _updateCalendar();
                                      Navigator.of(context).pop();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please fill all fields correctly'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Create Task",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        letterSpacing: 1),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: SizedBox(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        hideKeyboard(context);
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Colors.black.withOpacity(0.6),
                                        // Customize button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Adjust the value for rounded corners
                                        ),
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            letterSpacing: 1),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  Widget _buildDatePickerField(DateTime? date, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date == null
                ? 'Select $label Date & Time'
                : '$label: ${DateFormat('dd MMM yy hh:mm a').format(date)}',
          ),
          Icon(Icons.arrow_forward_ios_outlined, size: 20),
        ],
      ),
    );
  }

//----------------------------------------------------------------------------//
  void _showEventDetailsDialog(Appointment appointment) {
    TextEditingController eventController =
    TextEditingController(text: appointment.subject);
    TextEditingController descController =
    TextEditingController(text: appointment.notes);
    DateTime? startDate = appointment.startTime;
    DateTime? endDate = appointment.endTime;
    Color selectedColor = appointment.color; // Default color
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) async => false,
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.zero,
                content: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          child: Text(
                            "Event Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                letterSpacing: 1),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.3,
                        ),
                        SizedBox(height: 5.0),
                        CupertinoTextField(
                          controller: eventController,
                          keyboardType: TextInputType.name,
                          enabled: true,
                          placeholder: 'Task Name',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                          placeholderStyle: TextStyle(
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              letterSpacing: 0.5),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          padding: EdgeInsets.all(16.0),
                        ),
                        SizedBox(height: 13.0),
                        CupertinoTextField(
                          controller: descController,
                          keyboardType: TextInputType.name,
                          enabled: true,
                          placeholder: 'Task Description',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                          placeholderStyle: TextStyle(
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              letterSpacing: 0.5),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          padding: EdgeInsets.all(16.0),
                        ),
                        SizedBox(height: 13.0),
                        GestureDetector(
                          onTap: () async {
                            hideKeyboard(context);
                            FocusScope.of(context).requestFocus(FocusNode());
                            FocusScope.of(context).unfocus();
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: startDate!,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(startDate!),
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  startDate = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: _buildDatePickerField(startDate, 'Start'),
                        ),
                        SizedBox(height: 13.0),
                        GestureDetector(
                          onTap: () async {
                            hideKeyboard(context);
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: endDate!,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(endDate!),
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  endDate = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: _buildDatePickerField(endDate, 'End'),
                        ),
                        SizedBox(height: 13.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedColor,
                            // Customize button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the value for rounded corners
                            ),
                          ),
                          onPressed: () {
                            hideKeyboard(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Pick a color',
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black.withOpacity(0.8),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        letterSpacing: 0.5,
                                      )),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                      pickerColor: selectedColor,
                                      onColorChanged: (Color color) {
                                        setState(() {
                                          selectedColor = color;
                                        });
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Done',
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Selected Color',
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                letterSpacing: 0.5,
                              )),
                        ),
                        SizedBox(height: 13.0),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3788D3),
                                  // Customize button color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the value for rounded corners
                                  ),
                                ),
                                onPressed: () {
                                  hideKeyboard(context);
                                  if (eventController.text.isNotEmpty &&
                                      descController.text.isNotEmpty &&
                                      startDate != null &&
                                      endDate != null &&
                                      startDate!.isBefore(endDate!)) {
                                    setState(() {
                                      appointment.subject =
                                          eventController.text;
                                      appointment.startTime = startDate!;
                                      appointment.endTime = endDate!;
                                      appointment.color = selectedColor;
                                      appointment.notes = descController.text;
                                    });

                                    // Update the data source and refresh the calendar
                                    _updateCalendar();
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please fill all fields correctly'),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      hideKeyboard(context);
                                      setState(() {
                                        _appointments.remove(appointment);
                                        _updateCalendar();
                                      });
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Colors.red, // Customize button color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Adjust the value for rounded corners
                                      ),
                                    ),
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          letterSpacing: 1),
                                    ),
                                  )),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      hideKeyboard(context);
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Colors.black.withOpacity(0.6),
                                      // Customize button color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Adjust the value for rounded corners
                                      ),
                                    ),
                                    child: Text(
                                      "Close",
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          letterSpacing: 1),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

//----------------------------------------------------------------------------//
  void _updateCalendar() {
    setState(() {
      _dataSource = AppointmentDataSource(_appointments);
    });
  }

//----------------------------------------------------------------------------//
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}