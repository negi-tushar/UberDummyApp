import 'package:firebase_database/firebase_database.dart';

class Users {
  late String fname;
  late String email;
  late String phone;
  late String id;

  Users({
    required this.email,
    required this.fname,
    required this.id,
    required this.phone,
  });
  Users.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key!;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fname = snapshot.value['fullName'];
  }
}
