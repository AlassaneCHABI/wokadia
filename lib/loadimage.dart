import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LocalImagesPage extends StatefulWidget {
  const LocalImagesPage({super.key});

  @override
  State<LocalImagesPage> createState() => _LocalImagesPageState();
}

class _LocalImagesPageState extends State<LocalImagesPage> {
  List<FileSystemEntity> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync(); // récupère tous les fichiers
    setState(() {
      _files = files.where((f) => f.path.endsWith(".png") || f.path.endsWith(".jpg") || f.path.endsWith(".jpeg")).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📂 Images locales")),
      body: _files.isEmpty
          ? const Center(child: Text("Aucune image trouvée"))
          : ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          final file = File(_files[index].path);
          return Card(
            child: ListTile(
              leading: Image.file(file, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(file.path.split('/').last),
              subtitle: Text(file.path),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImagePreviewPage(imageFile: file),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final File imageFile;
  const ImagePreviewPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(imageFile.path.split('/').last)),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
