import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../models/stop.dart';

/// In-memory stand-in until Laravel API is live.
class MockStore extends ChangeNotifier {
  MockStore() {
    _seed();
  }

  static const stopFee = 80;
  static const homeFee = 150;
  static const riderPayPerOrder = 40;
  static const companyJazzNumber = '03XX-XXXXXXX';
  static const demoOtp = '1234';

  int _seq = 9;
  int floatPkr = 8000;
  int batchCount = 0;

  final List<CrStop> stops = const [
    CrStop(id: 'daharki-chowk', name: 'Daharki Chowk', landmark: 'Main bazaar chowk', lat: 28.141, lng: 69.728),
    CrStop(id: 'railway', name: 'Railway Station', landmark: 'Station road', lat: 28.145, lng: 69.731),
    CrStop(id: 'hospital', name: 'Civil Hospital', landmark: 'Hospital gate', lat: 28.138, lng: 69.735),
    CrStop(id: 'bypass', name: 'Bypass Adda', landmark: 'National highway adda', lat: 28.150, lng: 69.720),
    CrStop(id: 'colony', name: 'Colony Gate', landmark: 'Housing colony', lat: 28.133, lng: 69.726),
    CrStop(id: 'bus', name: 'New Bus Stand', landmark: 'Coach adda', lat: 28.147, lng: 69.740),
  ];

  final List<CrOrder> orders = [];

  void _seed() {
    orders.addAll([
      CrOrder(
        id: 'o7',
        publicId: 'DHK-20260921-0007',
        customerPhone: '03001234567',
        itemsText: '1 kg cheeni, 2 bread, oil 1 litre',
        deliveryType: CrDeliveryType.stop,
        deliveryFee: stopFee,
        payMethod: CrPayMethod.cod,
        status: CrOrderStatus.open,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        stopId: 'daharki-chowk',
        stopName: 'Daharki Chowk',
        notes: 'gate ke pass wait',
      ),
      CrOrder(
        id: 'o8',
        publicId: 'DHK-20260921-0008',
        customerPhone: '03007654321',
        itemsText: '1 packet dairy milk, 1 cold drink',
        deliveryType: CrDeliveryType.stop,
        deliveryFee: stopFee,
        payMethod: CrPayMethod.cod,
        status: CrOrderStatus.open,
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        stopId: 'colony',
        stopName: 'Colony Gate',
      ),
    ]);
  }

  List<CrOrder> mine(String phone) =>
      orders.where((o) => o.customerPhone == phone).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<CrOrder> get openOrders =>
      orders.where((o) => o.status == CrOrderStatus.open).toList();

  CrOrder? byId(String id) {
    try {
      return orders.firstWhere((o) => o.id == id || o.publicId == id);
    } catch (_) {
      return null;
    }
  }

  String _nextPublicId() {
    _seq += 1;
    final day = DateFormat('yyyyMMdd').format(DateTime.now());
    return 'DHK-$day-${_seq.toString().padLeft(4, '0')}';
  }

  CrOrder createOrder({
    required String phone,
    required String items,
    required CrDeliveryType type,
    required CrPayMethod pay,
    CrStop? stop,
    String? homeNote,
    String? notes,
  }) {
    final order = CrOrder(
      id: 'o$_seq${DateTime.now().millisecondsSinceEpoch}',
      publicId: _nextPublicId(),
      customerPhone: phone,
      itemsText: items,
      deliveryType: type,
      deliveryFee: type == CrDeliveryType.stop ? stopFee : homeFee,
      payMethod: pay,
      status: CrOrderStatus.open,
      createdAt: DateTime.now(),
      stopId: stop?.id,
      stopName: stop?.name,
      homeNote: homeNote,
      notes: notes,
    );
    orders.insert(0, order);
    notifyListeners();
    return order;
  }

  bool accept(CrOrder order, String riderName) {
    if (order.status != CrOrderStatus.open) return false;
    if (batchCount >= 3) return false;
    order.status = CrOrderStatus.accepted;
    order.riderName = riderName;
    batchCount += 1;
    notifyListeners();
    return true;
  }

  void setStatus(CrOrder order, CrOrderStatus status) {
    order.status = status;
    notifyListeners();
  }

  void uploadBill(CrOrder order, {required String shop, required int subtotal}) {
    order.shopName = shop;
    order.subtotal = subtotal;
    order.billPhotoLabel = 'bill-photo.jpg';
    order.status = CrOrderStatus.billed;
    notifyListeners();
  }

  void markDelivered(CrOrder order) {
    order.status = CrOrderStatus.delivered;
    if (batchCount > 0) batchCount -= 1;
    notifyListeners();
  }

  String arrivalSms(CrOrder order) {
    final place = order.stopName ?? order.homeNote ?? 'current location';
    return 'ChowkRider: Saman aa gaya hai — $place';
  }
}

class StoreScope extends InheritedNotifier<MockStore> {
  const StoreScope({
    super.key,
    required MockStore store,
    required super.child,
  }) : super(notifier: store);

  static MockStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StoreScope>();
    assert(scope != null, 'StoreScope missing');
    return scope!.notifier!;
  }
}
