mixin Assets {
  final String path = 'assets';
}

class AnimationAssets with Assets {
  AnimationAssets._();

  static final AnimationAssets _instance = AnimationAssets._();

  static AnimationAssets get instance => _instance;

  @override
  String get path => "${super.path}/animations";

  String get walkingMan => "$path/among_us_walking.riv";
}

class ImageAssets with Assets {
  ImageAssets._();

  static final ImageAssets _instance = ImageAssets._();

  static ImageAssets get instance => _instance;

  @override
  String get path => "${super.path}/images";
}
