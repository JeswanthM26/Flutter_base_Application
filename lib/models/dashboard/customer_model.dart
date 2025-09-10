class CustomerModel {
  final String customerId;
  final String customerName;
  final String customerType;
  final String dateOfBirth;
  final String mobileNo;
  final String emailId;
  final String permAddress;
  final String communicationAddress;

  CustomerModel({
    required this.customerId,
    required this.customerName,
    required this.customerType,
    required this.dateOfBirth,
    required this.mobileNo,
    required this.emailId,
    required this.permAddress,
    required this.communicationAddress,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerType: json['customerType'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      emailId: json['emailId'] ?? '',
      permAddress: json['permAddress'] ?? '',
      communicationAddress: json['communicationAddress'] ?? '',
    );
  }
}
