import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/customer_controller.dart';
import '../utils/app_strings.dart';
import '../widgets/customer_card.dart';
import 'add_edit_customer_screen.dart';
import 'customer_details_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.customerVisits,
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        actions: [
          Consumer<CustomerController>(
            builder: (context, controller, child) {
              return IconButton(
                icon: Icon(
                  Icons.calendar_month,
                  color: controller.selectedDate != null
                      ? Theme.of(context).primaryColor
                      : null,
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    controller.setSelectedDate(picked);
                  }
                },
                tooltip: AppStrings.filterByDate,
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Consumer<CustomerController>(
                  builder: (context, controller, child) {
                return Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: AppStrings.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  controller.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        controller.setSearchQuery(value);
                      },
                    ),
                    if (controller.selectedDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Chip(
                              label: Text(
                                '${AppStrings.filterActive}${controller.selectedDate!.day}/${controller.selectedDate!.month}/${controller.selectedDate!.year}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              onDeleted: () {
                                controller.setSelectedDate(null);
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }),
            ),
            Expanded(
              child: Consumer<CustomerController>(
                builder: (context, controller, child) {
                  final customers = controller.customers;

                  if (customers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_alt_outlined,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            (controller.searchQuery.isEmpty &&
                                    controller.selectedDate == null)
                                ? AppStrings.noRecordsYet
                                : AppStrings.noMatchesFound,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 80),
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        final customer = customers[index];
                        return CustomerCard(
                          customer: customer,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CustomerDetailsScreen(customer: customer),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditCustomerScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addRecord),
        tooltip: AppStrings.addRecord,
      ),
    );
  }
}
