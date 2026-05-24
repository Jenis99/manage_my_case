import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/customer_controller.dart';
import '../models/customer_model.dart';
import '../utils/app_strings.dart';
import 'add_edit_customer_screen.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  late CustomerModel _customer;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.customerDetails,
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditCustomerScreen(customer: _customer),
                ),
              );

              // After returning from the edit screen, refresh the customer
              if (!mounted) return;
              final controller =
                  Provider.of<CustomerController>(context, listen: false);
              final id = _customer.id;
              if (id != null) {
                final updated = controller.getCustomerById(id);
                if (updated != null) {
                  setState(() {
                    _customer = updated;
                  });
                } else {
                  if (mounted) Navigator.pop(context);
                }
              } else {
                if (mounted) Navigator.pop(context);
              }
            },
            tooltip: AppStrings.edit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context),
            tooltip: AppStrings.delete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, AppStrings.customerName),
            _buildInfoCard(
              context,
              icon: Icons.person,
              title: _customer.name,
              subtitle: _customer.mobile.isNotEmpty
                  ? _customer.mobile
                  : AppStrings.mobileNumber,
              isAvatar: true,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, AppStrings.visitInformation),
            _buildInfoCard(
              context,
              icon: Icons.calendar_today,
              title: dateFormat.format(_customer.visitDate),
              subtitle: timeFormat.format(_customer.visitDate),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              icon: Icons.info_outline,
              title: AppStrings.visitPurpose,
              subtitle: _customer.purpose.isNotEmpty
                  ? _customer.purpose
                  : AppStrings.noPurposeSpecified,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              icon: Icons.currency_rupee,
              title: AppStrings.feesAmount,
              subtitle: '₹${_customer.feesAmount}',
            ),
            const SizedBox(height: 24),
            if (_customer.notes.isNotEmpty) ...[
              _buildSectionTitle(context, AppStrings.notes),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  _customer.notes,
                  style: TextStyle(
                      fontSize: 15, color: Colors.grey[800], height: 1.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      bool isAvatar = false}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isAvatar
                  ? Text(
                      title.isNotEmpty ? title[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  : Icon(icon, color: Theme.of(context).primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteRecord),
        content: Text('${AppStrings.deleteConfirmation}${_customer.name}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              final controller =
                  Provider.of<CustomerController>(context, listen: false);
              try {
                final id = _customer.id;
                if (id == null) {
                  if (context.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('${AppStrings.deleteError}Invalid ID'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  return;
                }

                await controller.deleteCustomer(id);
                if (context.mounted) {
                  Navigator.pop(dialogContext); // Close dialog
                  Navigator.pop(context); // Go back to list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${_customer.name}${AppStrings.deleteSuccess}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${AppStrings.deleteError}$e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(AppStrings.delete,
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
