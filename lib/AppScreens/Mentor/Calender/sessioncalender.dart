import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/mentorhomepage.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final PageController _pageController;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _loadEvents(); // Load events when the widget is initialized
  }

  void _loadEvents() {
    // Fetch events from Firebase Firestore and update the _events map
    // Assuming events are stored in a collection 'meetings' under the mentor's document
    // Update the collection path and structure according to your Firestore setup
    FirebaseFirestore.instance
        .collection('mentors')
        .doc(SessionManager.getUserId())
        .collection('meetings')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        DateTime date = (doc.data() as Map)['date'].toDate();
        if (_events[date] != null) {
          _events[date]!.add(doc.data());
        } else {
          _events[date] = [doc.data()];
        }
      });
      setState(() {});
    });
  }

  void _showAddEventDialog(DateTime selectedDay) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    bool showError = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Schedule Meeting',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                if (showError)
                  Text(
                    'Please fill in all fields',
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(
                    height:
                        showError ? 8 : 0), // Spacer if error message is shown
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      timeController.text = time.format(context);
                    }
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    String title = titleController.text.trim();
                    String time = timeController.text.trim();

                    if (title.isEmpty || time.isEmpty) {
                      setState(() {
                        showError = true;
                      });
                    } else {
                      // Save the event to Firebase Firestore
                      _saveEvent(
                          selectedDay, title, descriptionController.text, time);
                      // Update the events map
                      if (_events[selectedDay] != null) {
                        _events[selectedDay]!.add({
                          'title': title,
                          'description': descriptionController.text,
                          'time': time,
                        });
                      } else {
                        _events[selectedDay] = [
                          {
                            'title': title,
                            'description': descriptionController.text,
                            'time': time,
                          }
                        ];
                      }
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveEvent(
      DateTime date, String title, String description, String time) async {
    // Get the current user's ID using SessionManager
    final String userId = SessionManager.getUserId();

    if (userId.isEmpty) {
      // Handle error: user ID is not set
      print("User ID is not set.");
      return;
    }

    final CollectionReference mentors =
        FirebaseFirestore.instance.collection('mentors');

    await mentors.doc(userId).collection('meetings').add({
      'date': date,
      'title': title,
      'description': description,
      'time': time,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calendar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MentorHomePage(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showAddEventDialog(selectedDay);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
