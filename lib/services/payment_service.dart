import 'dart:async';
import 'dart:math';

/// Dummy payment service — replace API calls with real endpoints when ready.
class PaymentService {
  PaymentService._();

  static final _random = Random();

  /// Simulates submitting a payment order.
  /// Returns an [OrderResult] after a fake network delay.
  static Future<OrderResult> submitOrder({
    required String paymentMethod,
    required int totalAmount,
    required List<OrderItem> items,
  }) async {
    // Simulate network latency (1.5 – 2.5 s)
    await Future.delayed(Duration(milliseconds: 1500 + _random.nextInt(1000)));

    // Dummy: always succeeds and returns a pending order
    final orderId =
        'INV-${DateTime.now().year}-${(1000 + _random.nextInt(8999)).toString()}';

    return OrderResult(
      orderId: orderId,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      items: items,
      createdAt: DateTime.now(),
      status: PaymentStatus.pending,
    );
  }

  /// Simulates polling the payment status.
  /// In real life this hits GET /payments/:orderId
  static Future<PaymentStatus> checkStatus(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    // Dummy logic: randomly advance status for demo purposes
    final roll = _random.nextInt(10);
    if (roll < 5) return PaymentStatus.pending;
    if (roll < 8) return PaymentStatus.verifying;
    if (roll < 9) return PaymentStatus.success;
    return PaymentStatus.failed;
  }

  /// Simulates re-triggering payment (e.g. redirect to payment gateway).
  static Future<bool> retryPayment(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true; // always succeeds in dummy
  }
}

// ── Models ────────────────────────────────────────────────────────────────────

enum PaymentStatus { pending, verifying, success, failed }

class OrderItem {
  final String nama;
  final String model;
  final String seller;
  final int harga;
  final int qty;

  const OrderItem({
    required this.nama,
    required this.model,
    required this.seller,
    required this.harga,
    required this.qty,
  });
}

class OrderResult {
  final String orderId;
  final String paymentMethod;
  final int totalAmount;
  final List<OrderItem> items;
  final DateTime createdAt;
  PaymentStatus status;

  OrderResult({
    required this.orderId,
    required this.paymentMethod,
    required this.totalAmount,
    required this.items,
    required this.createdAt,
    required this.status,
  });
}
