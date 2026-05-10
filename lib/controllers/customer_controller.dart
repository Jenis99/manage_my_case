import 'package:flutter/material.dart';
import '../models/customer_model.dart';

class CustomerController extends ChangeNotifier {
  // In-memory list for demo purposes
  final List<CustomerModel> _customers = [];
  String _searchQuery = '';
  DateTime? _selectedDate;

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
    List<CustomerModel> filteredList = _customers;

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
    // Generate a simple unique ID
    customer.id = DateTime.now().millisecondsSinceEpoch.toString();
    _customers.add(customer);
    notifyListeners();
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String id) async {
    _customers.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
