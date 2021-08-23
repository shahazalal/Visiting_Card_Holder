import 'package:flutter/material.dart';
import 'package:visiting_card_holder/db/db_sqlite.dart';
import 'package:visiting_card_holder/models/contact_model.dart';
import 'package:visiting_card_holder/pages/contact_list_page.dart';

class AddContactPage extends StatefulWidget {
  static final String routeName = '/add_contact';

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final nameController = TextEditingController();
  final designationController = TextEditingController();
  final companyController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final webController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ContactModel? contactModel;
  @override
  void didChangeDependencies() {
    contactModel = ModalRoute.of(context)!.settings.arguments as ContactModel;
    _setTextFieldValues();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    companyController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    webController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Information'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveContact,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Contact Name', border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide a valid name';
                }
                return null;
              },
              onSaved: (value) {
                contactModel!.contactName = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: designationController,
              decoration: InputDecoration(
                  labelText: 'Designation', border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide a valid designation';
                }
                return null;
              },
              onSaved: (value) {
                contactModel!.designation = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: companyController,
              decoration: InputDecoration(
                  labelText: 'Company', border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide a valid company';
                }
                return null;
              },
              onSaved: (value) {
                contactModel!.company = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                  labelText: 'Address', border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide a valid address';
                }
                return null;
              },
              onSaved: (value) {
                contactModel!.streetAddress = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide a valid email';
                }
                return null;
              },
              onSaved: (value) {
                contactModel!.email = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                  labelText: 'Phone', border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide a valid phone';
                }
                return null;
              },
              onSaved: (value) {
                contactModel!.phone = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: webController,
              decoration: InputDecoration(
                  labelText: 'WebSite', border: OutlineInputBorder()),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Provide a valid website';
                }
                return null;
              },
              onSaved: (value) {
                contactModel!.website = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(contactModel);
      DBSQLite.insertNewContact(contactModel!).then((id) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Saved')));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ContactListPage()),
            (Route<dynamic> route) => false);
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Fail to Saved')));
        throw error;
      });
    }
  }

  void _setTextFieldValues() {
    setState(() {
      nameController.text = contactModel!.contactName ?? 'Unknown';
      designationController.text = contactModel!.designation ?? 'Unknown';
      companyController.text = contactModel!.company ?? 'Unknown';
      addressController.text = contactModel!.streetAddress ?? 'Unknown';
      emailController.text = contactModel!.email ?? 'Unknown';
      phoneController.text = contactModel!.phone ?? 'Unknown';
      webController.text = contactModel!.website ?? 'Unknown';
    });
  }
}
