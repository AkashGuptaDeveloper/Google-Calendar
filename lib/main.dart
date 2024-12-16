import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'ToDo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Appointment> _appointments = <Appointment>[];
  late AppointmentDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = AppointmentDataSource(_appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Calendar view (left half of screen)
          Expanded(
            flex: 1,
            child: SfCalendar(
              backgroundColor: Colors.white,
              allowAppointmentResize: true,
              allowDragAndDrop: true,
              view: CalendarView.workWeek,
              initialDisplayDate: DateTime.now(),
              dataSource: _dataSource,
              onTap: _onCalendarTap,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Event list view (right half of screen)
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = _appointments[index];
                return ListTile(
                  title: Text(appointment.subject),
                  subtitle: Text(
                      'Start: ${appointment.startTime}\nEnd: ${appointment.endTime}'),
                  leading: CircleAvatar(
                    backgroundColor: appointment.color,
                  ),
                  onTap: () => _onEventTap(appointment, index),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _onCalendarTap(CalendarTapDetails details) {
    // Check if the tap is on an event or on an empty cell
    if (details.targetElement == CalendarElement.appointment) {
      // If it's an event, get the clicked event
      Appointment clickedAppointment = details.appointments!.first;

      // Show the event details dialog
      _showEventDetailsDialog(clickedAppointment);
    } else if (details.targetElement == CalendarElement.calendarCell) {
      // If it's an empty cell, allow user to add a new event
      DateTime selectedDate = details.date!;
      DateTime? startDate;
      DateTime? endDate;

      TextEditingController eventController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Add Event'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: eventController,
                        decoration:
                            InputDecoration(hintText: 'Enter Event Title'),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        title: Text(
                          startDate == null
                              ? 'Select Start Date & Time'
                              : 'Start: ${startDate.toString()}',
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
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
                      ),
                      ListTile(
                        title: Text(
                          endDate == null
                              ? 'Select End Date & Time'
                              : 'End: ${endDate.toString()}',
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
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
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (eventController.text.isNotEmpty &&
                          startDate != null &&
                          endDate != null &&
                          startDate!.isBefore(endDate!)) {
                        setState(() {
                          _appointments.add(Appointment(
                            startTime: startDate!,
                            endTime: endDate!,
                            subject: eventController.text,
                            color: Colors.blue,
                          ));

                          // Update the data source and refresh the calendar
                          _updateCalendar();
                        });
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all fields correctly'),
                          ),
                        );
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  void _showEventDetailsDialog(Appointment appointment) {
    TextEditingController eventController =
        TextEditingController(text: appointment.subject);
    DateTime? startDate = appointment.startTime;
    DateTime? endDate = appointment.endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Event Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: eventController,
                      decoration: InputDecoration(hintText: 'Event Title'),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text(
                        startDate == null
                            ? 'Select Start Date & Time'
                            : 'Start: ${startDate.toString()}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
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
                    ),
                    ListTile(
                      title: Text(
                        endDate == null
                            ? 'Select End Date & Time'
                            : 'End: ${endDate.toString()}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
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
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (eventController.text.isNotEmpty &&
                        startDate != null &&
                        endDate != null &&
                        startDate!.isBefore(endDate!)) {
                      setState(() {
                        appointment.subject = eventController.text;
                        appointment.startTime = startDate!;
                        appointment.endTime = endDate!;
                      });

                      // Update the data source and refresh the calendar
                      _updateCalendar();
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill all fields correctly'),
                        ),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _appointments.remove(appointment);
                      _updateCalendar();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onEventTap(Appointment appointment, int index) {
    TextEditingController eventController =
        TextEditingController(text: appointment.subject);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: eventController,
                decoration: InputDecoration(hintText: 'Enter Event Title'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _appointments[index] = Appointment(
                    startTime: appointment.startTime,
                    endTime: appointment.endTime,
                    subject: eventController.text,
                    color: Colors.blue,
                  );
                  _updateCalendar();
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _appointments.removeAt(index);
                  _updateCalendar();
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _updateCalendar() {
    setState(() {
      _dataSource = AppointmentDataSource(_appointments);
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
