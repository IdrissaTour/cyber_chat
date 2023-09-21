import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImage extends StatelessWidget{
  String imageUrl;
  String intiale;
  double radius;

  CustomImage({required this.imageUrl, required this.intiale, required this.radius});
  @override
  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      ImageProvider provider = CachedNetworkImageProvider(imageUrl);
      if (radius == null) {
        // Image dans un chat
        imageWidget = InkWell(
          child: Image(image: provider, width: 250,),
          onTap: () {
            // Montrer l'image en grand
          },
        );
      } else {
        imageWidget = InkWell(
          child: CircleAvatar(
            radius: radius,
            backgroundImage: provider,
          ),
          onTap: () {
            // Action au clic sur l'image avec un rayon
          },
        );
      }
    } else {
      // Aucune imageUrl valide, utilisez un widget par défaut
      imageWidget = CircleAvatar(
        radius: radius,
        backgroundColor: Colors.indigo,
        child: Text(
          intiale ?? "",
          style: TextStyle(color: Colors.white, fontSize: radius),
        ),
      );
    }

    return imageWidget;
  }

  Future<void> takeimage( ImageSource source) async{
    XFile? xFile = await ImagePicker().pickImage(source: source);
  }
}