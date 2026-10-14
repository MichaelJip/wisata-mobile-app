import 'dart:convert';

class QrisStatusResponseModel {
    final String? statusCode;
    final String? transactionId;
    final String? grossAmount;
    final String? currency;
    final String? orderId;
    final String? paymentType;
    final String? signatureKey;
    final String? transactionStatus;
    final String? fraudStatus;
    final String? statusMessage;
    final String? merchantId;
    final String? transactionTime;
    final String? expiryTime;

    QrisStatusResponseModel({
        this.statusCode,
        this.transactionId,
        this.grossAmount,
        this.currency,
        this.orderId,
        this.paymentType,
        this.signatureKey,
        this.transactionStatus,
        this.fraudStatus,
        this.statusMessage,
        this.merchantId,
        this.transactionTime,
        this.expiryTime,
    });

    factory QrisStatusResponseModel.fromJson(String str) => QrisStatusResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory QrisStatusResponseModel.fromMap(Map<String, dynamic> json) => QrisStatusResponseModel(
        statusCode: json["status_code"],
        transactionId: json["transaction_id"],
        grossAmount: json["gross_amount"],
        currency: json["currency"],
        orderId: json["order_id"],
        paymentType: json["payment_type"],
        signatureKey: json["signature_key"],
        transactionStatus: json["transaction_status"],
        fraudStatus: json["fraud_status"],
        statusMessage: json["status_message"],
        merchantId: json["merchant_id"],
        transactionTime: json["transaction_time"],
        expiryTime: json["expiry_time"],
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "transaction_id": transactionId,
        "gross_amount": grossAmount,
        "currency": currency,
        "order_id": orderId,
        "payment_type": paymentType,
        "signature_key": signatureKey,
        "transaction_status": transactionStatus,
        "fraud_status": fraudStatus,
        "status_message": statusMessage,
        "merchant_id": merchantId,
        "transaction_time": transactionTime,
        "expiry_time": expiryTime,
    };
}
