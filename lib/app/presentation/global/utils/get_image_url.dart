String getImageUrl(
  String path, {
  ImageQuality imageQuality = ImageQuality.w300,
}) {
  return 'https://image.tmdb.org/t/p/w500$path';
}

enum ImageQuality {
  w300,
  w500,
  original,
}
