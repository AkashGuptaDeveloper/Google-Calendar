// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, await_only_futures, unnecessary_null_comparison, unused_local_variable
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//----------------------------------------------------------------------------//
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(const MyApp());
}
//----------------------------------------------------------------------------//
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
//----------------------------------------------------------------------------//
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//----------------------------------------------------------------------------//
class _MyHomePageState extends State<MyHomePage> {
  final List<Appointment> _appointments = <Appointment>[];
  late AppointmentDataSource _dataSource;
  int selectedIndex = 0; // 0 for Day, 1 for Month

  CalendarView calendarView = CalendarView.day;
  CalendarController calendarController = CalendarController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> SfCalendarKey = GlobalKey<FormState>(); // New GlobalKey
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
        title: Text(widget.title,style: TextStyle(
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: 1),),
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
                          ? Color(0xFF3788D3) // Highlight color when selected
                          :  Color(0xFF3788D3).withOpacity(0.8) ,
                      borderRadius: BorderRadius.circular(10), // Rounded edges
                      boxShadow: [
                        if (selectedIndex == 0)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                      ],
                    ),
                    child: Text(
                      "Day",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          letterSpacing: 1
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
                          ? Color(0xFF3788D3) // Highlight color when selected
                          :  Color(0xFF3788D3).withOpacity(0.8) ,
                      borderRadius: BorderRadius.circular(10), // Rounded edges
                      boxShadow: [
                        if (selectedIndex == 1)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                      ],
                    ),
                    child: Text(
                        "Week",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            letterSpacing: 1
                        )
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
                          ? Color(0xFF3788D3) // Highlight color when selected
                          :  Color(0xFF3788D3).withOpacity(0.8) ,
                      borderRadius: BorderRadius.circular(10), // Rounded edges
                      boxShadow: [
                        if (selectedIndex == 3)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                      ],
                    ),
                    child: Text(
                        "Month",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            letterSpacing: 1
                        )
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
              todayHighlightColor: const Color(0xFF3788D3),
              controller: calendarController,
              backgroundColor: Colors.transparent,
              allowAppointmentResize: true,
              allowDragAndDrop: true,
              view: calendarView, // If Month is selected
              initialDisplayDate: DateTime.now(),
              dataSource: _dataSource,
              onTap: _onCalendarTap,
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment, // Display appointments
                agendaItemHeight: 10, // Height of agenda items
                agendaStyle: AgendaStyle(
                  appointmentTextStyle: TextStyle(
                    fontSize: 16, // Font size for agenda text
                    color: Colors.black,
                  ),
                  dayTextStyle: TextStyle(
                    fontSize: 14, // Font size for day text
                    color: Colors.grey,
                  ),
                ),
              ),
              blackoutDates: [
                DateTime.now().subtract(Duration(hours: 48)),
                DateTime.now().subtract(Duration(hours: 28)),
              ],
              selectionDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  shape: BoxShape.rectangle),
              timeSlotViewSettings: TimeSlotViewSettings(
                timeIntervalHeight: 80, // Adjust height for time slots (default is 60)
                timeTextStyle: TextStyle(
                  fontSize: 14, // Font size for time labels
                  color: Colors.black,
                ),

              ),
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
//----------------------------------------------------------------------------//

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
                                  letterSpacing: 1
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Divider(
                            color:
                            Colors.grey,
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
                            decoration:BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  color: Colors.black, width: 1),
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
                            decoration:BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  color: Colors.black, width: 1),
                            ),
                            padding: EdgeInsets.all(16.0),
                          ),
                          SizedBox(height: 13.0),
                          GestureDetector(
                            onTap: () async {
                              hideKeyboard(
                                  context);
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
                              hideKeyboard(
                                  context);
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
                          /*ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:const Color(0xFF3788D3), // Customize button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the value for rounded corners
                              ),
                            ),
                            onPressed: () {
                              hideKeyboard(
                                  context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Pick a color',style: TextStyle(
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
                                          formKey.currentState?.reset();
                                        },
                                        child: Text('Done',style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          letterSpacing: 0.5,
                                        ),),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Select Color',style: TextStyle(
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            )),
                          ),*/
                          SizedBox(height: 13.0),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:const Color(0xFF3788D3), // Customize button color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the value for rounded corners
                                    ),
                                  ),
                                  onPressed: () {
                                    hideKeyboard(
                                        context);
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
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content:
                                          Text('Please fill all fields correctly'),
                                        ),
                                      );
                                    }
                                    formKey.currentState?.reset();
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
                                    child:  ElevatedButton(
                                      onPressed: () async {
                                        hideKeyboard(
                                            context);
                                        Navigator.pop(context);
                                        formKey.currentState?.reset();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .black.withOpacity(0.6), // Customize button color
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
//----------------------------------------------------------------------------//
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
//----------------------------------------------------------------------------//
  void _updateCalendar() {
    setState(() {
      _dataSource = AppointmentDataSource(_appointments);
    });
  }
//----------------------------------------------------------------------------//
  //-----------------hideKeyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
//----------------------------------------------------------------------------//
}
//----------------------------------------------------------------------------//
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
//----------------------------------------------------------------------------//
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
//----------------------------------------------------------------------------//
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
