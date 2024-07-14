import 'package:flutter/material.dart';
import 'package:frontend/models/mess_menu_model.dart';
import 'package:frontend/services/analytics_service.dart';
import 'package:frontend/widgets/mess_menu_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessMenuScreen extends StatelessWidget {
  final MessMenuModel messMenu;
  const MessMenuScreen({
    super.key,
    required this.messMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mess Menu',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: SingleChildScrollView(
                  child: MessMenuPage(
            messMenu: messMenu,
          ))),
        ]),
      ),
    );
  }
}

class MessMenuPage extends StatefulWidget {
  final MessMenuModel messMenu;
  const MessMenuPage({
    super.key,
    required this.messMenu,
  });

  @override
  State<MessMenuPage> createState() => _MessMenuPageState();
}

class _MessMenuPageState extends State<MessMenuPage> {
  String whichDay = 'Sunday';
  final List<bool> selectedOption = [true, false];
  final List<Widget> messToggleButtons = [
    Text(
      'UDH',
      style: GoogleFonts.inter(
          fontSize: 19.0, fontWeight: FontWeight.w700, color: Colors.black),
    ),
    Text(
      'LDH',
      style: GoogleFonts.inter(
          fontSize: 19.0, fontWeight: FontWeight.w700, color: Colors.black),
    )
  ];

  String getCurrentDay() {
    DateTime now = DateTime.now();
    String day = DateFormat('EEEE').format(now);
    return day;
  }

  final analyticsService = FirebaseAnalyticsService();

  @override
  void initState() {
    whichDay = getCurrentDay();
    super.initState();
    analyticsService.logScreenView(screenName: "Mess Menu Screen");
  }

  @override
  Widget build(BuildContext context) {
    final meals = selectedOption[0]
        ? widget.messMenu.udh[whichDay]
        : widget.messMenu.ldh[whichDay];

    final extras = widget.messMenu.udhAdditional[whichDay];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 3, 0, 0),
              child: DropdownButton<String>(
                elevation: 0,
                underline: Container(),
                value: whichDay,
                items: <String>[
                  'Sunday',
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    whichDay = value!;
                  });
                },
                focusColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 30, 0),
              child: ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (index) {
                    setState(() {
                      for (var i = 0; i < selectedOption.length; i++) {
                        selectedOption[i] = i == index;
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  fillColor: const Color.fromARGB(255, 198, 198, 198),
                  constraints: const BoxConstraints(
                    minHeight: 38.0,
                    minWidth: 85.0,
                  ),
                  isSelected: selectedOption,
                  children: messToggleButtons),
            )
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 40.0,
            ),
            if (meals != null) ...[
              ShowMessMenu(
                extras: extras?.breakfast ?? [],
                whichMeal: 'Breakfast',
                time: '7:30AM-10:30AM',
                meals: meals.breakfast,
              ),
              ShowMessMenu(
                extras: extras?.lunch ?? [],
                whichMeal: 'Lunch',
                time: '12:30PM-2:45PM',
                meals: meals.lunch,
              ),
              ShowMessMenu(
                extras: extras?.snacks ?? [],
                whichMeal: 'Snacks',
                time: '5:00PM-6:00PM',
                meals: meals.snacks,
              ),
              ShowMessMenu(
                extras: extras?.dinner ?? [],
                whichMeal: 'Dinner',
                time: '7:30PM-9:30PM',
                meals: meals.dinner,
              ),
            ] else
              const Center(child: Text('No meals available for today')),
          ],
        ),
      ],
    );
  }
}