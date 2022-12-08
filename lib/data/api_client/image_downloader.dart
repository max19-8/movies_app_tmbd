import 'package:movies_app_tmbd/library/config/configuration.dart';

class ImageDownloader{
 static  String imageUrl(String path) => Configuration.imageUrl + path;
}