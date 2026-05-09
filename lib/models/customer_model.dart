class CustomerModel {
  String? id;
  String name;
  String mobile;
  String purpose;
  DateTime visitDate;
  String notes;
  double feesAmount;

  CustomerModel({
    this.id,
    required this.name,
    required this.mobile,
    required this.purpose,
    required this.visitDate,
    required this.notes,
    this.feesAmount = 0.0,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> data, String docId) {
    return CustomerModel(
      id: docId,
      name: data['name'] ?? '',
      mobile: data['mobile'] ?? '',
      purpose: data['purpose'] ?? '',
      visitDate: data['visitDate'] != null
          ? DateTime.parse(data['visitDate'])
          : DateTime.now(),
      notes: data['notes'] ?? '',
      feesAmount: (data['feesAmount'] ?? 0.0).toDouble(),
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
