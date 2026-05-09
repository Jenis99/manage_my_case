// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/customer_model.dart';
//
// class FirebaseService {
//   final CollectionReference _customersCollection =
//       FirebaseFirestore.instance.collection('customers');
//
//   // Create a new customer record
//   Future<void> addCustomer(CustomerModel customer) async {
//     await _customersCollection.add(customer.toMap());
//   }
//
//   // Get stream of all customers ordered by date (latest first)
//   // Stream<List<CustomerModel>> getCustomersStream() {
//   //   return _customersCollection
//   //       .orderBy('visitDate', descending: true)
//   //       .snapshots()
//   //       .map((snapshot) {
//   //     return snapshot.docs
//   //         .map((doc) => CustomerModel.fromFirestore(doc))
//   //         .toList();
//   //   });
//   // }
//
//   // Update customer record
//   Future<void> updateCustomer(CustomerModel customer) async {
//     if (customer.id != null) {
//       await _customersCollection.doc(customer.id).update(customer.toMap());
//     }
//   }
//
//   // Delete customer record
//   Future<void> deleteCustomer(String id) async {
//     await _customersCollection.doc(id).delete();
//   }
// }
