import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(const MyApp());
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
  int selectedIndex = 0; // 0 for Day, 1 for Month

  CalendarView calendarView = CalendarView.day;
  CalendarController calendarController = CalendarController();
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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.circular(12), // Rounded container
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Day Button
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                      calendarView = CalendarView.day;
                      calendarController.view = calendarView;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: selectedIndex == 0
                          ? Colors.blue // Highlight color when selected
                          : Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(10), // Rounded edges
                      boxShadow: [
                        if (selectedIndex == 0)
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                      ],
                    ),
                    child: Text(
                      "Day",
                      style: TextStyle(
                        color: selectedIndex == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Week Button
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                      calendarView = CalendarView.week;
                      calendarController.view = calendarView;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: selectedIndex == 1
                          ? Colors.blue // Highlight color when selected
                          : Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(10), // Rounded edges
                      boxShadow: [
                        if (selectedIndex == 1)
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                      ],
                    ),
                    child: Text(
                      "Week",
                      style: TextStyle(
                        color: selectedIndex == 1 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Month Button
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                      calendarView = CalendarView.month;
                      calendarController.view = calendarView;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: selectedIndex == 2
                          ? Colors.blue // Highlight color when selected
                          : Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(10), // Rounded edges
                      boxShadow: [
                        if (selectedIndex == 3)
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                      ],
                    ),
                    child: Text(
                      "Month",
                      style: TextStyle(
                        color: selectedIndex == 1 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Calendar view (left half of screen)
          Expanded(
            flex: 3,
            child: SfCalendar(
              controller: calendarController,
              backgroundColor: Colors.transparent,
              allowAppointmentResize: true,
              allowDragAndDrop: true,
              onDragStart: dragStart,
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
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void _onCalendarTap(CalendarTapDetails details) {
    setState(() {
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
                                // ignore: use_build_context_synchronously
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
                                // ignore: use_build_context_synchronously
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
                          });

                          // Call _updateCalendar to refresh the calendar
                          _updateCalendar(); // Make sure this updates your calendar's data source

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
    });
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
                            // ignore: use_build_context_synchronously
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        FocusScope.of(context).unfocus();
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: endDate!,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            // ignore: use_build_context_synchronously
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
                    FocusScope.of(context).requestFocus(FocusNode());
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    FocusScope.of(context).unfocus();
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

  void dragStart(AppointmentDragStartDetails appointmentDragStartDetails) {
    dynamic appointment = appointmentDragStartDetails.appointment;
    CalendarResource? resource = appointmentDragStartDetails.resource;
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
