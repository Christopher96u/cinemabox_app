import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/models/media/media.dart';
import '../../../../global/utils/get_image_url.dart';
import '../../../../utils/go_to_media_details.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({Key? key, required this.items}) : super(key: key);
  final List<Media> items;

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemBuilder: (_, index) {
        final item = widget.items[index];
        return MaterialButton(
          //padding: const EdgeInsets.all(8.0),
          onPressed: () {
            if (item.type == MediaType.movie) {
              goToMediaDetails(context, item);
            }
          },
          child: Row(
            children: [
              ExtendedImage.network(
                getImageUrl(
                  item.posterPath,
                ),
                width: 60,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      item.overview,
                      maxLines: 4,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: widget.items.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
