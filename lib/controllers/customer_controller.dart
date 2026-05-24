import 'dart:async';
import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../services/firebase_service.dart';

class CustomerController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<CustomerModel> _customers = [];
  StreamSubscription<List<CustomerModel>>? _customersSubscription;
  String _searchQuery = '';
  DateTime? _selectedDate;

  CustomerController() {
    _initCustomersStream();
  }

  void _initCustomersStream() {
    _customersSubscription = _firebaseService.getCustomersStream().listen((customersList) {
      _customers = customersList;
      notifyListeners();
    });
  }

  String get searchQuery => _searchQuery;
  DateTime? get selectedDate => _selectedDate;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<CustomerModel> get customers {
    List<CustomerModel> filteredList = List.from(_customers);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredList = filteredList.where((customer) {
        return customer.name.toLowerCase().contains(query) ||
            customer.mobile.contains(query) ||
            customer.purpose.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by selected date
    if (_selectedDate != null) {
      filteredList = filteredList.where((customer) {
        return customer.visitDate.year == _selectedDate!.year &&
            customer.visitDate.month == _selectedDate!.month &&
            customer.visitDate.day == _selectedDate!.day;
      }).toList();
    }

    // Sort by visit date (latest first)
    filteredList.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    return filteredList;
  }

  Future<void> addCustomer(CustomerModel customer) async {
    await _firebaseService.addCustomer(customer);
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    await _firebaseService.updateCustomer(customer);
  }

  Future<void> deleteCustomer(String id) async {
    await _firebaseService.deleteCustomer(id);
  }

  @override
  void dispose() {
    _customersSubscription?.cancel();
    super.dispose();
  }
}
