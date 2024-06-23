import 'package:bn_diplomapp/model/posting_model.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';

class PostingGridTileUI extends StatefulWidget {
  final PostingModel? posting;

  const PostingGridTileUI({super.key, this.posting});

  @override
  State<PostingGridTileUI> createState() => _PostingGridTileUIState();
}

class _PostingGridTileUIState extends State<PostingGridTileUI> {
  PostingModel? posting;

  updateUI() async {
    if (posting != null) {
      await posting!.getFirstImageFromStorage();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
    updateUI();
  }

  @override
  Widget build(BuildContext context) {
    if (posting == null) {
      return Container(); // Return an empty container if posting is null
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 3 / 2,
          child: posting!.displayImages == null || posting!.displayImages!.isEmpty
              ? Container()
              : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: posting!.displayImages!.first,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Text(
          "${posting!.type ?? ''} - ${posting!.city ?? ''}, ${posting!.country ?? ''}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          posting!.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          '\₸${posting!.price?.toStringAsFixed(2) ?? ''} / night',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        RatingBar.readOnly(
          size: 25.0,
          maxRating: 5,
          initialRating: posting!.getCurrentRating(),
          filledIcon: Icons.star,
          emptyIcon: Icons.star_border,
          filledColor: Colors.amberAccent,
        ),
      ],
    );
  }
}
