import 'package:dashbaord/extensions.dart';
import 'package:flutter/material.dart';
import 'package:dashbaord/models/mess_menu_model.dart';
import 'package:dashbaord/widgets/home_mess_component.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreenMessMenu extends StatelessWidget {
  final MessMenuModel? messMenu;
  const HomeScreenMessMenu({
    super.key,
    this.messMenu,
  });

  bool isWeekend() {
    DateTime today = DateTime.now();
    return today.weekday == DateTime.saturday ||
        today.weekday == DateTime.sunday;
  }

  @override
  Widget build(BuildContext context) {
    if (messMenu == null) {
      return noMealToday("Failed to fetch mess menu", context);
    }

    final String today = DateFormat('EEEE').format(DateTime.now());
    final meals = messMenu?.ldh[today]; // or use messMenu.udh[today]
    final additional = messMenu?.ldhAdditional[today];

    if (meals == null) {
      return noMealToday("Failed to fetch mess menu", context);
    }

    final currentTime = TimeOfDay.now();
    String currentMeal;
    List<String> currentMealData;
    List<String> extras;
    String mealTime;

    if (currentTime.hour < 10 ||
        (currentTime.hour == 10 && currentTime.minute <= 30)) {
      currentMeal = 'Breakfast';
      currentMealData = meals.breakfast;
      mealTime = isWeekend() ? '8:00AM-10:30AM' : '7:30AM-10:00AM';
      extras = additional?.breakfast ?? [];
    } else if (currentTime.hour < 14 ||
        (currentTime.hour == 14 && currentTime.minute <= 45)) {
      currentMeal = 'Lunch';
      currentMealData = meals.lunch;
      mealTime = '12:30PM-2:45PM';
      extras = additional?.lunch ?? [];
    } else if (currentTime.hour < 18 ||
        (currentTime.hour == 18 && currentTime.minute <= 0)) {
      currentMeal = 'Snacks';
      currentMealData = meals.snacks;
      mealTime = '5:00PM-6:00PM';
      extras = additional?.snacks ?? [];
    } else if (currentTime.hour < 21 ||
        (currentTime.hour == 21 && currentTime.minute <= 30)) {
      currentMeal = 'Dinner';
      currentMealData = meals.dinner;
      mealTime = '7:30PM-9:30PM';
      extras = additional?.dinner ?? [];
    } else {
      return noMealToday('No meals available for today', context);
    }

    return InkWell(
      onTap: () {
        if (messMenu == null) {
          return;
        }
        context.push('/mess', extra: {'messMenu': messMenu!});
        // Navigator.of(context).push(
        //   CustomPageRoute(child: MessMenuScreen(messMenu: messMenu!)),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColors.customContainerColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: context.customColors.customShadowColor, // Shadow color
              offset: const Offset(0, 4), // Offset in the x, y direction
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 18, top: 15),
                child: Text(
                  'Mess Menu',
                  style: GoogleFonts.inter(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            HomeMessMenu(
              extras: extras,
              whichMeal: currentMeal,
              meals: currentMealData,
              time: mealTime,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget noMealToday(String msg, BuildContext context) {
    return InkWell(
      onTap: () {
        if (messMenu == null) {
          return;
        }
        context.push('/mess', extra: {'messMenu': messMenu!});
        // Navigator.of(context).push(
        //   CustomPageRoute(child: MessMenuScreen(messMenu: messMenu!)),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColors.customContainerColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: context.customColors.customShadowColor, // Shadow color
              offset: const Offset(0, 4), // Offset in the x, y direction
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 18, top: 15),
                child: Text(
                  'Mess Menu',
                  style: GoogleFonts.inter(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              msg,
              style: GoogleFonts.inter(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
