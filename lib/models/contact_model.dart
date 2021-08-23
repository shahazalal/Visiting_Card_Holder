final String tableContact = 'tbl_contact';
final String colContactName = 'contact_name';
final String colContactDesignation = 'contact_designation';
final String colContactCompany = 'contact_company';
final String colContactAddress = 'contact_address';
final String colContactEmail = 'contact_email';
final String colContactPhone = 'contact_phone';
final String colContactWeb = 'contact_web';
final String colContactId = 'id';
final String colContactImage = 'image';
final String colContactFavorite = 'favorite';

class ContactModel {
  int? contactId;
  String? contactName;
  String? designation;
  String? company;
  String? streetAddress;
  String? phone;
  String? email;
  String? website;
  String? image;
  bool? favorite;

  ContactModel(
      {this.contactId,
      this.contactName,
      this.designation,
      this.company,
      this.streetAddress,
      this.favorite = false,
      this.phone,
      this.email,
      this.website = 'www.pencilbox.com',
      this.image});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colContactName: contactName,
      colContactDesignation: designation,
      colContactCompany: company,
      colContactAddress: streetAddress,
      colContactEmail: email,
      colContactPhone: phone,
      colContactWeb: website,
      colContactFavorite: favorite! ? 1 : 0,
      colContactImage: image
    };
    if (contactId != null) {
      map[colContactId] = contactId;
    }
    return map;
  }

  ContactModel.fromMap(Map<String, dynamic> map) {
    contactId = map[colContactId];
    contactName = map[colContactName];
    designation = map[colContactDesignation];
    company = map[colContactCompany];
    streetAddress = map[colContactAddress];
    phone = map[colContactPhone];
    email = map[colContactEmail];
    website = map[colContactWeb];
    image = map[colContactImage];
    favorite = map[colContactFavorite] == 1 ? true : false;
  }

  @override
  String toString() {
    return 'ContactModel{contactId: $contactId, contactName: $contactName, designation: $designation, company: $company, streetAddress: $streetAddress, phone: $phone, email: $email, website: $website, image: $image,}';
  }
}
