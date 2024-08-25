import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/screens/gallery_page.dart';

class SetView extends StatefulWidget {
  final String setName;
  final List<dynamic> imageList;
  const SetView({super.key, required this.imageList, required this.setName});

  @override
  State<SetView> createState() => _SetViewState();
}

class _SetViewState extends State<SetView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.setName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final snack = SnackBar(
                  content: Text('Cards Count: ${widget.imageList.length}'));
              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
            icon: const Icon(Icons.numbers_rounded),
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: widget.imageList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return GalleryPage(
                        imageList: widget.imageList, index: index);
                  },
                ),
              );
            },
            child: Card(
              child: CachedNetworkImage(
                imageUrl: widget.imageList[index],
                fit: BoxFit.contain,
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
            ),
          );
        },
      ),
    );
  }
}
