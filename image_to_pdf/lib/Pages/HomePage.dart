import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image2pdf_flutter/image_to_pdf.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_pdf/Pages/viewPdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  // Future<void> _pickImages() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickMultiImage();

  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFiles = File(pickedFile.path);
  //     });
  //   }
  // }


  File? _pdfPath;

  Future<void> _convertImageToPdf() async {
    if (_imageFile == null) return;

    final pdf = pw.Document();

    final image = pw.MemoryImage(_imageFile!.readAsBytesSync());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/.pdf");
    await file.writeAsBytes(await pdf.save());
    setState(() {
      _pdfPath = file;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF Saved: ${file.path}')),
    );
  }

  // List<XFile>? _imageFiles;
  // Future<void> _convertImagesToPdf() async {
  //   if (_imageFiles == null) return;

  //   final pdf = pw.Document();

  //   final image = pw.MemoryImage(_imageFiles!..readAsBytesSync());

  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Center(
  //           child: pw.Image(image),
  //         );
  //       },
  //     ),
  //   );
  //   final output = await getTemporaryDirectory();
  //   final file = File("${output.path}/.pdf");
  //   await file.writeAsBytes(await pdf.save());
  //   setState(() {
  //     _pdfPath = file;
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('PDF Saved: ${file.path}')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF SNAPPER"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.pink[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(),
              child: Container(
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: _imageFile == null
                    ? Center(
                        child: Column(
                        children: [
                          Icon(
                            Icons.add,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text('Upload Image')
                        ],
                      ))
                    : Image.file(File(_imageFile!.path)),
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                _convertImageToPdf();
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                minimumSize: WidgetStatePropertyAll(Size(double.infinity, 55)),
                foregroundColor: WidgetStatePropertyAll(Colors.pink[50]),
                backgroundColor: WidgetStatePropertyAll(Colors.pink),
              ),
              child: Text('Convert to Pdf'),
            ),
            SizedBox(height: 10),
            _pdfPath != null
                ? OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPdf(pdfUrl: _pdfPath!),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      minimumSize:
                          WidgetStatePropertyAll(Size(double.infinity, 55)),
                      foregroundColor: WidgetStatePropertyAll(Colors.pink),
                      backgroundColor: WidgetStatePropertyAll(Colors.pink[50]),
                    ),
                    child: Text('View And Download'),
                  )
                : Text('')
          ],
        ),
      ),
    );
  }
}
