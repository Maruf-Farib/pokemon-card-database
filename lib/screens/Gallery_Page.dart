import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pokemon/screens/image_details_page.dart';

class GalleryPage extends StatefulWidget {
  final List<dynamic> imageList;
  final int index;
  const GalleryPage({super.key, required this.imageList, required this.index});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ImageDetailsPage(
                      url: widget.imageList[currentIndex],
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.info_rounded),
          ),
          const SizedBox(
            width: 3,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              downloadImage(widget.imageList[currentIndex], context);
            },
          ),
        ],
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: PhotoViewGallery.builder(
        itemCount: widget.imageList.length,
        pageController: PageController(initialPage: widget.index),
        onPageChanged: _onPageChanged,
        scrollDirection: Axis.horizontal,
        enableRotation: true,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions.customChild(
            minScale: PhotoViewComputedScale.covered,
            child: CachedNetworkImage(
              imageUrl: widget.imageList[index],
              progressIndicatorBuilder: (context, url, progress) {
                return Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                );
              },
              errorWidget: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error));
              },
            ),
          );
        },
      ),
    );
  }

  downloadImage(String imageUrl, context) async {
    try {
      String devicePathToSaveImage = "";
      var time = DateTime.now().microsecondsSinceEpoch;
      if (Platform.isAndroid) {
        devicePathToSaveImage = "/storage/emulated/0/Download/image-$time.jpg";
      } else {
        var downloadDirectoryPath = await getApplicationDocumentsDirectory();
        devicePathToSaveImage = "${downloadDirectoryPath.path}/image-$time.jpg";
      }

      File file = File(devicePathToSaveImage);
      //print('File path: $devicePathToSaveImage');
      // Make the HTTP GET request
      var res = await get(Uri.parse(imageUrl));
      if (res.statusCode == 200) {
        // Save the image
        await file.writeAsBytes(res.bodyBytes);
        await ImageGallerySaver.saveFile(devicePathToSaveImage);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Yay! Downloading Completed'),
        ));
      }
    } catch (error) {
      //print("Error: $error");
    }
  }
}
