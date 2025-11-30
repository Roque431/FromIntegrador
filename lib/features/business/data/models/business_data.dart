class BusinessData {
  final String businessName;
  final String ownerName;
  final String businessType;
  final String businessSize;
  final String email;
  final String phone;
  final String address;
  final String postalCode;
  final String? website;
  final List<String> services;
  final String serviceDescription;
  final List<String> workingDays;
  final String openingTime;
  final String closingTime;
  final String billingPeriod;

  const BusinessData({
    required this.businessName,
    required this.ownerName,
    required this.businessType,
    required this.businessSize,
    required this.email,
    required this.phone,
    required this.address,
    required this.postalCode,
    this.website,
    required this.services,
    required this.serviceDescription,
    required this.workingDays,
    required this.openingTime,
    required this.closingTime,
    required this.billingPeriod,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'ownerName': ownerName,
      'businessType': businessType,
      'businessSize': businessSize,
      'email': email,
      'phone': phone,
      'address': address,
      'postalCode': postalCode,
      'website': website,
      'services': services,
      'serviceDescription': serviceDescription,
      'workingDays': workingDays,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'billingPeriod': billingPeriod,
    };
  }
}
