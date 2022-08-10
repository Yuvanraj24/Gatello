
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'SnackBar.dart';

Future<void> saveContactInPhone(
    {required String name,
      required String phone,
      required BuildContext context,

      ///* 0->add new; 1->update
      required int state}) async {
  try {
    print("saving Conatct");
    PermissionStatus permission = await Permission.contacts.status;

    if (permission != PermissionStatus.granted) {
      await Permission.contacts.request();
      permission = await Permission.contacts.status;
    }
    if (permission == PermissionStatus.granted) {
      if (state == 0) {
        // Contact updatedContact = new Contact();

        Contact newContact = new Contact();
        newContact.givenName = name;
        newContact.phones = [Item(label: "mobile", value: phone)];
        await ContactsService.addContact(newContact);
        final snackBar = snackbar(content: "Contact Saved");
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = snackbar(content: "Permission Denied");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    print(e);
  }
}
