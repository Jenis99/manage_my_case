class AppStrings {
  // App
  static const String appName = 'Mahadev Associates';

  // Screen Titles
  static const String customerVisits = 'Customer Visits';
  static const String addRecord = 'Add Record';
  static const String addNewRecord = 'Add New Record';
  static const String editRecord = 'Edit Record';
  static const String deleteRecord = 'Delete Record';

  // Labels & Hints
  static const String searchHint = 'Search by name, number or case type';
  static const String customerDetails = 'Customer Details';
  static const String customerName = 'Customer Name *';
  static const String mobileNumber = 'Mobile Number';
  static const String visitInformation = 'Visit Information';
  static const String visitPurpose = 'Case Type';
  static const String visitDate = 'Visit Date';
  static const String notes = 'Notes';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String saveRecord = 'Save Record';
  static const String updateRecord = 'Update Record';
  static const String feesAmount = 'Fees Amount';
  static const String filterByDate = 'Filter by Date';
  static const String selectDate = 'Select Date';
  static const String filterActive = 'Filter Active: ';
  static const String clearFilter = 'Clear Filter';

  // Messages
  static const String noRecordsYet =
      'No customer records yet.\nTap the + button to add one.';
  static const String noMatchesFound = 'No matches found';
  static const String noPurposeSpecified = 'No case type specified';
  static const String deleteConfirmation =
      'Are you sure you want to delete the record for ';
  static const String deleteSuccess = ' deleted successfully';
  static const String deleteError = 'Failed to delete: ';
  static const String saveSuccess = 'Record added successfully!';
  static const String updateSuccess = 'Record updated successfully!';
  static const String saveError = 'Error saving record: ';

  // Validators
  static const String nameRequired = 'Please enter customer name';
  static const String mobileRequired = 'Please enter mobile number';
  static const String mobileInvalid = 'Please enter a valid mobile number';
  static const String purposeRequired = 'Please enter case type';
  static const String visitDateRequired = 'Please select a visit date';
  static const String feesRequired = 'Please enter fees amount';
  static const String feesInvalid = 'Please enter a valid number';
}
