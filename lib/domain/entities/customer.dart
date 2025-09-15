class BillingInfo {
  final String? billingName;
  final String? billingAddress;
  final String? billingCity;
  final String? billingState;
  final String? billingZip;
  final String? billingCountry;
  final String? billingPhone;

  BillingInfo({this.billingName, this.billingAddress, this.billingCity, this.billingState, this.billingZip, this.billingCountry, this.billingPhone});

  factory BillingInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BillingInfo();
    return BillingInfo(
      billingName: json['billing_name']?.toString(),
      billingAddress: json['billing_address']?.toString(),
      billingCity: json['billing_city']?.toString(),
      billingState: json['billing_state']?.toString(),
      billingZip: json['billing_zip']?.toString(),
      billingCountry: json['billing_country']?.toString(),
      billingPhone: json['billing_phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'billing_name': billingName,
        'billing_address': billingAddress,
        'billing_city': billingCity,
        'billing_state': billingState,
        'billing_zip': billingZip,
        'billing_country': billingCountry,
        'billing_phone': billingPhone,
      };
}

class ShippingInfo {
  final String? shippingName;
  final String? shippingAddress;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingZip;
  final String? shippingCountry;
  final String? shippingPhone;

  ShippingInfo({this.shippingName, this.shippingAddress, this.shippingCity, this.shippingState, this.shippingZip, this.shippingCountry, this.shippingPhone});

  factory ShippingInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ShippingInfo();
    return ShippingInfo(
      shippingName: json['shipping_name']?.toString(),
      shippingAddress: json['shipping_address']?.toString(),
      shippingCity: json['shipping_city']?.toString(),
      shippingState: json['shipping_state']?.toString(),
      shippingZip: json['shipping_zip']?.toString(),
      shippingCountry: json['shipping_country']?.toString(),
      shippingPhone: json['shipping_phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'shipping_name': shippingName,
        'shipping_address': shippingAddress,
        'shipping_city': shippingCity,
        'shipping_state': shippingState,
        'shipping_zip': shippingZip,
        'shipping_country': shippingCountry,
        'shipping_phone': shippingPhone,
      };
}

class CompanyInfo {
  final String? totalInvoiceSum;
  final int? totalInvoice;
  final String? averageSale;
  final String? balance;
  final String? overdue;
  final String? dateOfCreation;

  CompanyInfo({this.totalInvoiceSum, this.totalInvoice, this.averageSale, this.balance, this.overdue, this.dateOfCreation});

  factory CompanyInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CompanyInfo();
    return CompanyInfo(
      totalInvoiceSum: json['total_invoice_sum']?.toString(),
      totalInvoice: json['total_invoice'] is int ? json['total_invoice'] as int : int.tryParse(json['total_invoice']?.toString() ?? ''),
      averageSale: json['average_sale']?.toString(),
      balance: json['balance']?.toString(),
      overdue: json['overdue']?.toString(),
      dateOfCreation: json['date_of_creation']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_invoice_sum': totalInvoiceSum,
        'total_invoice': totalInvoice,
        'average_sale': averageSale,
        'balance': balance,
        'overdue': overdue,
        'date_of_creation': dateOfCreation,
      };
}

class Invoice {
  final String? invoiceId;
  final String? issueDate;
  final String? dueDate;
  final String? dueAmount;
  final String? status;

  Invoice({this.invoiceId, this.issueDate, this.dueDate, this.dueAmount, this.status});

  factory Invoice.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Invoice();
    return Invoice(
      invoiceId: json['invoice_id']?.toString(),
      issueDate: json['issue_date']?.toString(),
      dueDate: json['due_date']?.toString(),
      dueAmount: json['due_amount']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'invoice_id': invoiceId,
        'issue_date': issueDate,
        'due_date': dueDate,
        'due_amount': dueAmount,
        'status': status,
      };
}

class Customer {
  final String id;
  final int? customerId;
  final String? name;
  final String? email;
  final String? contact;
  final BillingInfo billingInfo;
  final ShippingInfo shippingInfo;
  final CompanyInfo companyInfo;
  final List<Invoice> invoices;

  Customer({required this.id, this.customerId, this.name, this.email, this.contact, required this.billingInfo, required this.shippingInfo, required this.companyInfo, required this.invoices});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'].toString(),
      customerId: json['customer_id'] is int ? json['customer_id'] as int : int.tryParse(json['customer_id']?.toString() ?? ''),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      contact: json['contact']?.toString(),
      billingInfo: BillingInfo.fromJson(json['billing_info'] as Map<String, dynamic>?),
      shippingInfo: ShippingInfo.fromJson(json['shipping_info'] as Map<String, dynamic>?),
      companyInfo: CompanyInfo.fromJson(json['company_info'] as Map<String, dynamic>?),
      invoices: (json['invoices'] is List) ? (json['invoices'] as List).map((e) => Invoice.fromJson(e as Map<String, dynamic>?)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'name': name,
        'email': email,
        'contact': contact,
        'billing_info': billingInfo.toJson(),
        'shipping_info': shippingInfo.toJson(),
        'company_info': companyInfo.toJson(),
        'invoices': invoices.map((i) => i.toJson()).toList(),
      };
}

