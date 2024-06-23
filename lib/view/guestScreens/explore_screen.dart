import 'package:bn_diplomapp/model/posting_model.dart';
import 'package:bn_diplomapp/view/view_posting_screen.dart';
import 'package:bn_diplomapp/view/widgets/posting_grid_tile_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController controllerSearch = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  Stream<QuerySnapshot>? stream;
  String searchType = "";
  bool isNameButtonSelected = false;
  bool isCityButtonSelected = false;
  bool isTypeButtonSelected = false;

  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance.collection('postings').snapshots();
    searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  void searchByField() {
    setState(() {
      if (searchType == "name") {
        stream = FirebaseFirestore.instance
            .collection('postings')
            .where('name', isGreaterThanOrEqualTo: controllerSearch.text)
            .where('name', isLessThanOrEqualTo: controllerSearch.text + '\uf8ff')
            .snapshots();
      } else if (searchType == "city") {
        stream = FirebaseFirestore.instance
            .collection('postings')
            .where('city', isGreaterThanOrEqualTo: controllerSearch.text)
            .where('city', isLessThanOrEqualTo: controllerSearch.text + '\uf8ff')
            .snapshots();
      } else if (searchType == "type") {
        stream = FirebaseFirestore.instance
            .collection('postings')
            .where('type', isGreaterThanOrEqualTo: controllerSearch.text)
            .where('type', isLessThanOrEqualTo: controllerSearch.text + '\uf8ff')
            .snapshots();
      } else {
        stream = FirebaseFirestore.instance.collection('postings').snapshots();
      }
    });
  }

  void pressSearchByButton(String searchTypeStr, bool isNameButtonSelectedB, bool isCityButtonSelectedB, bool isTypeButtonSelectedB) {
    setState(() {
      searchType = searchTypeStr;
      isNameButtonSelected = isNameButtonSelectedB;
      isCityButtonSelected = isCityButtonSelectedB;
      isTypeButtonSelected = isTypeButtonSelectedB;
    });
    searchByField(); // Trigger search immediately after selecting filter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Image.asset('images/images/splash1.png', height: 30), // Update this path
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Dorm',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'VibesInDormitory',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Finding and renting a dormitory is easy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search your dormitory?',
                  prefixIcon: Icon(
                    Icons.search,
                    color: searchFocusNode.hasFocus ? Colors.green : Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
                controller: controllerSearch,
                onEditingComplete: searchByField,
              ),
              const SizedBox(height: 20),
              const Text(
                'Or do you want to look for another one?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSearchFilterButton('Name', isNameButtonSelected, () {
                      pressSearchByButton("name", true, false, false);
                    }),
                    const SizedBox(width: 10),
                    _buildSearchFilterButton('City', isCityButtonSelected, () {
                      pressSearchByButton("city", false, true, false);
                    }),
                    const SizedBox(width: 10),
                    _buildSearchFilterButton('Type', isTypeButtonSelected, () {
                      pressSearchByButton("type", false, false, true);
                    }),
                    const SizedBox(width: 10),
                    _buildSearchFilterButton('Clear', false, () {
                      pressSearchByButton("", false, false, false);
                      controllerSearch.clear();
                      searchByField();
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, dataSnapshots) {
                  if (dataSnapshots.hasData && dataSnapshots.data != null) {
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataSnapshots.data!.docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 15,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snapshot = dataSnapshots.data!.docs[index];
                        PostingModel cPosting = PostingModel(id: snapshot.id);
                        cPosting.getPostingInfoFromSnapshot(snapshot);

                        return InkResponse(
                          onTap: () {
                            Get.to(ViewPostingScreen(posting: cPosting));
                          },
                          enableFeedback: true,
                          child: PostingGridTileUI(posting: cPosting),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFilterButton(String title, bool isSelected, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isSelected ? Colors.green : Colors.white,
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black54),
        onTap: () {
          // Add navigation or functionality here
        },
      ),
    );
  }
}
