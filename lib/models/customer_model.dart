class CustomerModel {
  String? id;
  String name;
  String mobile;
  String purpose;
  DateTime visitDate;
  String notes;
  int feesAmount;

  CustomerModel({
    this.id,
    required this.name,
    required this.mobile,
    required this.purpose,
    required this.visitDate,
    required this.notes,
    this.feesAmount = 0,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> data, String docId) {
    final visitDate = data['visitDate'] != null
        ? DateTime.parse(data['visitDate'])
        : DateTime.now();

    final rawFees = data['feesAmount'] ?? 0;
    final int parsedFees = rawFees is num
        ? rawFees.toInt()
        : int.tryParse(rawFees.toString()) ?? 0;

    return CustomerModel(
      id: docId,
      name: data['name'] ?? '',
      mobile: data['mobile'] ?? '',
      purpose: data['purpose'] ?? '',
      visitDate: visitDate,
      notes: data['notes'] ?? '',
      feesAmount: parsedFees,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'purpose': purpose,
      'visitDate': visitDate.toIso8601String(),
      'notes': notes,
      'feesAmount': feesAmount,
    };
  }
}
