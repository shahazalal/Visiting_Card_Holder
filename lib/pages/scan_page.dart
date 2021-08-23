import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visiting_card_holder/models/contact_model.dart';
import 'package:visiting_card_holder/pages/add_contact_page.dart';

var _temp = [];

class ScanPage extends StatefulWidget {
  static final String routeName = '/scan_page';

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  var imageSource = ImageSource.camera;
  final contactModel = ContactModel();
  List<String> lines = [];
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan your card'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () => Navigator.pushNamed(
                context, AddContactPage.routeName,
                arguments: contactModel),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            scanSection(),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.black,
              height: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: lines.length,
                itemBuilder: (context, i) => LineItem(lines[i]),
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildPropertyButton('Contact Name'),
                  buildPropertyButton('Designation'),
                  buildPropertyButton('Company'),
                  buildPropertyButton('Address'),
                  buildPropertyButton('Email'),
                  buildPropertyButton('Phone'),
                  buildPropertyButton('Web Site'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPropertyButton(String property) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              _assignPropertiesToContactModel(property);
            },
            child: Text(property)),
      );

  Widget scanSection() {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(12)),
          child: imagePath == null
              ? Text('No Image')
              : Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  imageSource = ImageSource.camera;
                  _scanImage();
                },
                child: Text('Capture')),
            ElevatedButton(
                onPressed: () {
                  imageSource = ImageSource.gallery;
                  _scanImage();
                },
                child: Text('Select')),
          ],
        )
      ],
    );
  }

  void _scanImage() async {
    XFile? file = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      imagePath = file?.path;
    });
    if (imagePath != null) {
      // set image to contact
      contactModel.image = imagePath;
      final inputImage = InputImage.fromFilePath(imagePath!);
      final textDetector = GoogleMlKit.vision.textDetector();
      final recognizedText = await textDetector.processImage(inputImage);
      var temp = <String>[];
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          temp.add(line.text);
        }
      }
      setState(() {
        lines = temp;
      });
      //print(recognizedText.text);
    }
    // print(file?.path);
  }

  void _assignPropertiesToContactModel(String property) {
    final item = _temp.join(' ');
    switch (property) {
      case 'Contact Name':
        contactModel.contactName = item;
        break;

      case 'Designation':
        contactModel.designation = item;
        break;
      case 'Company':
        contactModel.company = item;
        break;
      case 'Address':
        contactModel.streetAddress = item;
        break;
      case 'Email':
        contactModel.email = item;
        break;
      case 'Phone':
        contactModel.phone = item;
        break;
      case 'Web Site':
        contactModel.website = item;
        break;
    }
    _temp = [];
    print(contactModel);
  }
}

class LineItem extends StatefulWidget {
  final String line;

  LineItem(this.line);

  @override
  _LineItemState createState() => _LineItemState();
}

class _LineItemState extends State<LineItem> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.line),
      trailing: Checkbox(
        value: checked,
        onChanged: (value) {
          setState(() {
            checked = value!;
          });
          value! ? _temp.add(widget.line) : _temp.remove(widget.line);
        },
      ),
    );
  }
}
