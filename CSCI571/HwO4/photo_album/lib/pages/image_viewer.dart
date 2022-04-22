import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget {
  late Future<ImageInfo> imageInfo;

  Future<ImageInfo> getImageInfo(Image img) async {
    final c = Completer<ImageInfo>();
    img.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo i, bool _) {
      c.complete(i);
    }));
    return c.future;
  }

  Widget imageInfoLoader(
      BuildContext context, AsyncSnapshot<ImageInfo> snapshot) {
    final Widget errorMessage =
        Row(mainAxisSize: MainAxisSize.min, children: const [
      Icon(
        Icons.error,
        color: Colors.red,
      ),
      Text(
        '  Error loading image information.',
        style: TextStyle(color: Colors.red),
      )
    ]);

    if (!snapshot.hasData) {
      return errorMessage;
    } else {
      ImageInfo? imageInfo = snapshot.data;
      if (imageInfo == null) {
        return errorMessage;
      }
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text('Image Width: ${imageInfo.image.width}'),
        Text('Image Height: ${imageInfo.image.height}')
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final imagePath = args['imagePath'];
    final Image image = Image.file(
      File(imagePath),
      fit: BoxFit.contain,
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Fullscreen Image'),
        ),
        body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                  child: Center(
                child: image,
              )),
              const SizedBox(height: 8.0),
              FutureBuilder<ImageInfo>(
                  future: getImageInfo(image), builder: imageInfoLoader),
            ],
          ),
        ));
  }
}