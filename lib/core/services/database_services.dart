import 'package:cloud_firestore/cloud_firestore.dart';

const String TODO_COLLECTION_REF = 'appointments';

class DatabaseServices {
  final _firestore = FirebaseFirestore.instance;
}
