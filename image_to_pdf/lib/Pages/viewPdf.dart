import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  final File? pdfUrl;
  const ViewPdf({super.key, required this.pdfUrl});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  @override
  void initState() {
    super.initState();
    // _loadPdf();
  }

  Future<void> _downloadPdf() async {
    if (widget.pdfUrl == null) return;

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final downloadsDir = await getExternalStorageDirectory();
      final newPath = "${downloadsDir!.path}/DownloadedImage.pdf";
      final newFile = await widget.pdfUrl!.copy(newPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF Downloaded: ${newFile.path}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission Denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        appBar: AppBar(
          title: Text('View Pdf'),
          centerTitle: true,
          backgroundColor: Colors.pink,
          foregroundColor: Colors.pink[50],
          actions: [
            IconButton(
              onPressed: () => {_downloadPdf()},
              icon: Icon(Icons.download),
            )
          ],
        ),
        body: SfPdfViewer.file(widget.pdfUrl!));
  }
}
