import 'package:bn_diplomapp/model/booking_model.dart';
import 'package:bn_diplomapp/model/contact_model.dart';
import 'package:bn_diplomapp/model/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../global.dart';
import 'app_constants.dart';

class PostingModel {
  String? id;
  String? name;
  String? type;
  double? price;
  String? description;
  String? address;
  String? city;
  String? country;
  double? rating;

  ContactModel? host;

  List<String>? imageNames;
  List<MemoryImage>? displayImages;
  List<String>? amenities;

  Map<String, int>? beds;
  Map<String, int>? bathrooms;

  List<BookingModel>? bookings;
  List<ReviewModel>? reviews;

  PostingModel({
    this.id = "",
    this.name = "",
    this.type = "",
    this.price = 0,
    this.description = "",
    this.address = "",
    this.city = "",
    this.country = "",
    this.rating = 0,
    this.host,
  }) {
    displayImages = [];
    amenities = [];
    beds = {};
    bathrooms = {};
    bookings = [];
    reviews = [];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'description': description,
      'address': address,
      'city': city,
      'country': country,
      'rating': rating,
      'hostID': host?.id,
      'imageNames': imageNames,
      'amenities': amenities,
      'beds': beds,
      'bathrooms': bathrooms,
    };
  }

  factory PostingModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostingModel(
      id: doc.id,
      name: data['name'],
      type: data['type'],
      price: data['price'].toDouble(),
      description: data['description'],
      address: data['address'],
      city: data['city'],
      country: data['country'],
      rating: data['rating'].toDouble(),
    );
  }

  setImagesNames() {
    imageNames = [];
    for (int i = 0; i < displayImages!.length; i++) {
      imageNames!.add("image${i}.png");
    }
  }

  Future<void> getPostingInfoFromFirestore() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('postings').doc(id).get();
    getPostingInfoFromSnapshot(snapshot);
  }

  getPostingInfoFromSnapshot(DocumentSnapshot snapshot) {
    address = snapshot['address'] ?? "";
    amenities = List<String>.from(snapshot['amenities'] ?? []);
    bathrooms = Map<String, int>.from(snapshot['bathrooms'] ?? {});
    beds = Map<String, int>.from(snapshot['beds'] ?? {});
    city = snapshot['city'] ?? "";
    country = snapshot['country'] ?? "";
    description = snapshot['description'] ?? "";

    String hostID = snapshot['hostID'] ?? "";
    host = ContactModel(id: hostID);

    imageNames = List<String>.from(snapshot['imageNames'] ?? []);
    name = snapshot['name'] ?? "";
    price = snapshot['price'].toDouble() ?? 0.0;
    rating = snapshot['rating'].toDouble() ?? 2.5;
    type = snapshot['type'] ?? "";
  }

  Future<void> getAllImagesFromStorage() async {
    displayImages = [];
    for (int i = 0; i < imageNames!.length; i++) {
      final imageData = await FirebaseStorage.instance.ref().child("postingImages").child(id!).child(imageNames![i]).getData(1024 * 1024);
      displayImages!.add(MemoryImage(imageData!));
    }
  }

  Future<MemoryImage?> getFirstImageFromStorage() async {
    if (displayImages != null && displayImages!.isNotEmpty) {
      return displayImages!.first;
    }
    if (imageNames != null && imageNames!.isNotEmpty) {
      final imageData = await FirebaseStorage.instance.ref().child("postingImages").child(id!).child(imageNames!.first).getData(1024 * 1024);
      displayImages = [MemoryImage(imageData!)];
      return displayImages!.first;
    }
    return null;
  }

  String getAmenitiesString() {
    if (amenities!.isEmpty) {
      return "";
    }
    String amenitiesString = amenities.toString();
    return amenitiesString.substring(1, amenitiesString.length - 1);
  }

  double getCurrentRating() {
    if (reviews!.isEmpty) {
      return 4;
    }
    double rating = 0;
    for (var review in reviews!) {
      rating += review.rating!;
    }
    rating /= reviews!.length;
    return rating;
  }

  Future<void> getHostFromFirestore() async {
    if (host != null) {
      await host!.getContactInfoFromFirestore();
      await host!.getImageFromStorage();
    }
  }

  int getGuestsNumber() {
    int numGuests = 0;
    numGuests = numGuests + (beds!['small'] ?? 0);
    numGuests = numGuests + (beds!['medium'] ?? 0) * 2;
    numGuests = numGuests + (beds!['large'] ?? 0) * 2;
    return numGuests;
  }

  String getBedroomText() {
    String text = "";
    if (beds!["small"] != 0) {
      text = text + beds!["small"].toString() + " single/twin ";
    }
    if (beds!["medium"] != 0) {
      text = text + beds!["medium"].toString() + " double ";
    }
    if (beds!["large"] != 0) {
      text = text + beds!["large"].toString() + " queen/king ";
    }
    return text;
  }

  String getBathroomText() {
    String text = "";
    if (bathrooms!["full"] != 0) {
      text = text + bathrooms!["full"].toString() + " full ";
    }
    if (bathrooms!["half"] != 0) {
      text = text + bathrooms!["half"].toString() + " half ";
    }
    return text;
  }

  String getFullAddress() {
    return address! + ", " + city! + ", " + country!;
  }

  getAllBookingsFromFirestore() async {
    bookings = [];

    QuerySnapshot snapshots = await FirebaseFirestore.instance.collection('postings')
        .doc(id).collection('bookings').get();

    for (var snapshot in snapshots.docs) {
      BookingModel newBooking = BookingModel();
      await newBooking.getBookingInfoFromFirestoreFromPosting(this, snapshot);
      bookings!.add(newBooking);
    }
  }

  List<DateTime> getAllBookedDates() {
    List<DateTime> dates = [];
    for (var booking in bookings!) {
      dates.addAll(booking.dates!);
    }
    return dates;
  }

  Future<void> makeNewBooking(List<DateTime> dates, context, String hostID) async {
    Map<String, dynamic> bookingData = {
      'dates': dates,
      'name': AppConstants.currentUser.getFullNameOfUser(),
      'userID': AppConstants.currentUser.id,
      'payment': bookingPrice,
    };

    DocumentReference reference = await FirebaseFirestore.instance.collection('postings')
        .doc(id).collection('bookings').add(bookingData);

    BookingModel newBooking = BookingModel();

    newBooking.createBooking(this, AppConstants.currentUser.createUserFromContact(), dates);
    newBooking.id = reference.id;

    bookings!.add(newBooking);
    await AppConstants.currentUser.addBookingToFirestore(newBooking, bookingPrice!, hostID);

    Get.snackbar("Listing", "Booked successfully.");
  }

  Future<void> addToHistory(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('history')
        .doc(id)
        .set(toMap());
  }
}
