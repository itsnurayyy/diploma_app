import 'package:bn_diplomapp/model/posting_model.dart';
import 'package:flutter/material.dart';

class PostingListTileUI extends StatefulWidget {
  final PostingModel? posting;

  const PostingListTileUI({super.key, this.posting});

  @override
  State<PostingListTileUI> createState() => _PostingListTileUIState();
}

class _PostingListTileUIState extends State<PostingListTileUI> {
  PostingModel? posting;

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10.0),
          leading: AspectRatio(
            aspectRatio: 1,
            child: posting!.displayImages!.isEmpty
                ? Container(color: Colors.grey[200])
                : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: posting!.displayImages!.first,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            posting!.name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "${posting!.type} - ${posting!.city}, ${posting!.country}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: Text(
            '\₸${posting!.price!} / night',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
