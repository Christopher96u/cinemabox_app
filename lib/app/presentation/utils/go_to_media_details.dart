import 'package:flutter/material.dart';

import '../../domain/models/media/media.dart';
import '../routes/routes.dart';

Future<void> goToMediaDetails(BuildContext context, Media media) async {
  await Navigator.pushNamed(
    context,
    Routes.movie,
    arguments: media.id,
  );
}
