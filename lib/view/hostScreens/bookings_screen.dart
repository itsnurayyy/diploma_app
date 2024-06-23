import 'package:bn_diplomapp/model/app_constants.dart';
import 'package:bn_diplomapp/model/posting_model.dart';
import 'package:bn_diplomapp/view/widgets/calendar_ui.dart';
import 'package:bn_diplomapp/view/widgets/posting_list_tile_ui.dart';
import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<DateTime> _bookedDates = [];
  List<DateTime> _allBookedDates = [];
  PostingModel? _selectedPosting;

  List<DateTime> _getSelectedDates() {
    return [];
  }

  _selectDate(DateTime date) {
    // Implement date selection logic if needed
  }

  _selectAPosting(PostingModel posting) {
    setState(() {
      _selectedPosting = posting;
      _bookedDates = posting.getAllBookedDates();
    });
  }

  _clearSelectedPosting() {
    setState(() {
      _bookedDates = _allBookedDates;
      _selectedPosting = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _bookedDates = AppConstants.currentUser.getAllBookedDates();
    _allBookedDates = AppConstants.currentUser.getAllBookedDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 35),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: PageView.builder(
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return CalenderUI(
                        monthIndex: index,
                        bookedDates: _bookedDates,
                        selectDate: _selectDate,
                        getSelectedDates: _getSelectedDates,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter by Listing',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    MaterialButton(
                      onPressed: _clearSelectedPosting,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppConstants.currentUser.myPostings!.length,
                itemBuilder: (context, index) {
                  final posting = AppConstants.currentUser.myPostings![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 26.0),
                    child: InkResponse(
                      onTap: () => _selectAPosting(posting),
                      child: PostingListTileUI(posting: posting),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
