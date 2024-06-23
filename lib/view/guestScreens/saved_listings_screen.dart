import 'package:bn_diplomapp/model/posting_model.dart';
import 'package:bn_diplomapp/view/guest_home_screen.dart';
import 'package:bn_diplomapp/view/view_posting_screen.dart';
import 'package:bn_diplomapp/view/widgets/posting_grid_tile_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/app_constants.dart';

class SavedListingsScreen extends StatefulWidget {
  const SavedListingsScreen({super.key});

  @override
  State<SavedListingsScreen> createState() => _SavedListingsScreenState();
}

class _SavedListingsScreenState extends State<SavedListingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favorited'),
            Tab(text: 'Viewed'),
          ],
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritedTab(),
          _buildViewedTab(),
        ],
      ),
    );
  }

  Widget _buildFavoritedTab() {
    if (AppConstants.currentUser.savedPostings!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/images/fav.png',   //image to your assets
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 10),
            const Text(
              'There are no favorite dorms yet',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
      child: GridView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: AppConstants.currentUser.savedPostings!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          PostingModel currentPosting = AppConstants.currentUser.savedPostings![index];

          return Stack(
            children: [
              InkResponse(
                enableFeedback: true,
                child: PostingGridTileUI(posting: currentPosting),
                onTap: () {
                  Get.to(ViewPostingScreen(posting: currentPosting));
                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      onPressed: () {
                        AppConstants.currentUser.removeSavedPosting(currentPosting);
                        setState(() {});
                      },
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildViewedTab() {
    // Add your logic for the viewed tab here
    return Center(
      child: const Text(
        'Viewed dorms will appear here',
        style: TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }
}
