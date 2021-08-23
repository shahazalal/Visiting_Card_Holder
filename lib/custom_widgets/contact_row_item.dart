import 'package:flutter/material.dart';
import 'package:visiting_card_holder/db/db_sqlite.dart';
import 'package:visiting_card_holder/helpers.dart';
import 'package:visiting_card_holder/models/contact_model.dart';
import 'package:visiting_card_holder/pages/contact_details_page.dart';

class ContactRowItem extends StatefulWidget {
  final ContactModel contactModel;
  final int index;

  ContactRowItem(this.contactModel, this.index);

  @override
  _ContactRowItemState createState() => _ContactRowItemState();
}

class _ContactRowItemState extends State<ContactRowItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.green,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) {
        DBSQLite.deleteContact(widget.contactModel.contactId!).then((value) {
          showMessage(context, 'Deleted');
        });
      },
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Delete ${widget.contactModel.contactName}?'),
                  content: Text('Are You Sure To Delete This Item'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text('Cancel')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('Delete'))
                  ],
                ));
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, ContactDetailsPage.routeName,
                arguments: [
                  widget.contactModel.contactId,
                  widget.contactModel.contactName
                ]);
          },
          // tileColor: widget.index.isEven ? Colors.green : Colors.greenAccent,
          title: Text(widget.contactModel.contactName!),
          subtitle: Text(widget.contactModel.designation!),
          leading: CircleAvatar(
            backgroundImage: AssetImage('images/image1.png'),
          ),
          trailing: IconButton(
            icon: Icon(widget.contactModel.favorite!
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () {
              final value = widget.contactModel.favorite! ? 0 : 1;
              DBSQLite.updateFavorite(widget.contactModel.contactId!, value)
                  .then((value) {
                setState(() {
                  widget.contactModel.favorite = !widget.contactModel.favorite!;
                });
              });
            },
          ),
        ),
      ),
    );
  }
}
