import 'package:bn_diplomapp/view/guestScreens/account_screen.dart';
import 'package:bn_diplomapp/view/guestScreens/explore_screen.dart';
import 'package:bn_diplomapp/view/guestScreens/inbox_screen.dart';
import 'package:bn_diplomapp/view/guestScreens/saved_listings_screen.dart';
import 'package:bn_diplomapp/view/guestScreens/trips_screen.dart';
import 'package:bn_diplomapp/view/hostScreens/bookings_screen.dart';
import 'package:bn_diplomapp/view/hostScreens/my_postings_screen.dart';
import 'package:flutter/material.dart';


class HostHomeScreen extends StatefulWidget
{
  int? index;
  HostHomeScreen({super.key, this.index,});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}



class _HostHomeScreenState extends State<HostHomeScreen>
{
  int selectedIndex = 0;

  final List<String> screenTitles = [
    'Bookings',
    'My Postings',
    'Inbox',
    'Profile',
  ];

  final List<Widget> screens = [
    BookingsScreen(),
    MyPostingsScreen(),
    InboxScreen(),
    AccountScreen(),
  ];

  BottomNavigationBarItem customNavigationBarItem(int index, IconData iconData, String title) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: Colors.grey,
      ),
      activeIcon: Icon(
        iconData,
        color: Colors.green,
      ),
      label: title,
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedIndex = widget.index ?? 3;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i)
        {
          setState(() {
            selectedIndex = i;
          });
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>
        [
          customNavigationBarItem(0, Icons.calendar_today, screenTitles[0]),
          customNavigationBarItem(1, Icons.home, screenTitles[1]),
          customNavigationBarItem(2, Icons.message, screenTitles[2]),
          customNavigationBarItem(3, Icons.person_outline, screenTitles[3]),
        ],
      ),
    );
  }
}
