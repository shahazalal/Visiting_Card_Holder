import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visiting_card_holder/db/db_sqlite.dart';
import 'package:visiting_card_holder/models/contact_model.dart';

class ContactDetailsPage extends StatefulWidget {
  static final String routeName = '/contact_details';

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  int contactId = -1;
  ContactModel? contactModel;
  String? contactName;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments as List;
    contactId = args[0];
    contactName = args[1];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactName!),
      ),
      body: Center(
        child: FutureBuilder<ContactModel>(
          future: DBSQLite.getContactById(contactId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              contactModel = snapshot.data;
              return Column(
                children: [
                  contactModel!.image == null
                      ? Image.asset(
                          'images/image1.png',
                          width: double.maxFinite,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(
                            contactModel!.image!,
                          ),
                          width: double.maxFinite,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                  Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text(contactModel!.contactName!),
                      subtitle: Text(contactModel!.designation!),
                    ),
                  ),
                  ListTile(
                      title: Text(contactModel!.phone!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                _makeSms();
                              },
                              icon: Icon(Icons.sms)),
                          IconButton(
                              onPressed: () {
                                _callNumber();
                              },
                              icon: Icon(Icons.call))
                        ],
                      )),
                  ListTile(
                    title: Text(contactModel!.email!),
                    trailing: IconButton(
                      icon: Icon(Icons.email),
                      onPressed: () {},
                    ),
                  ),
                  ListTile(
                    title: Text(contactModel!.streetAddress!),
                    trailing: IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {
                        _showMap();
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(contactModel!.website!),
                    trailing: IconButton(
                      icon: Icon(Icons.web),
                      onPressed: () {},
                    ),
                  )
                ],
              );
            }
            if (snapshot.hasError) {
              return Text('Failed to Fetch Data');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _callNumber() async {
    final url = 'tel:${contactModel!.phone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'can not launch';
    }
  }

  void _makeSms() async {
    final url = 'sms:${contactModel!.phone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'can not launch';
    }
  }

  void _showMap() async {
    final url = Platform.isIOS
        ? 'https://maps.apple.com/?query=${contactModel!.streetAddress}'
        : 'geo:0,0?q=${contactModel!.streetAddress}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'can not launch';
    }
  }
}
