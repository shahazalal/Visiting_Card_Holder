import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visiting_card_holder/custom_widgets/contact_row_item.dart';
import 'package:visiting_card_holder/db/db_sqlite.dart';
import 'package:visiting_card_holder/db/temp_db.dart';
import 'package:visiting_card_holder/models/contact_model.dart';
import 'package:visiting_card_holder/pages/contact_details_page.dart';
import 'package:visiting_card_holder/pages/scan_page.dart';

class ContactListPage extends StatefulWidget {
  static final String routeName = '/';
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: Center(
        child: FutureBuilder<List<ContactModel>>(
          future: DBSQLite.getAllContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contactList = snapshot.data!;
              if (contactList.isEmpty)
                return Text(
                  'No Contact Found',
                );
              print(contactList.length);
              return ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) =>
                      ContactRowItem(contactList[index], index));
            }
            if (snapshot.hasError) {
              return Text('Failed to Fetch Data');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, ScanPage.routeName),
      ),
    );
  }
}
