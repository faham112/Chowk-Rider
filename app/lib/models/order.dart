enum CrOrderStatus {
  draft,
  open,
  accepted,
  shopping,
  billed,
  onTheWay,
  arrived,
  delivered,
  cancelled,
  disputed,
}

enum CrDeliveryType { stop, home }

enum CrPayMethod { cod, jazzcash }

class CrOrder {
  CrOrder({
    required this.id,
    required this.publicId,
    required this.customerPhone,
    required this.itemsText,
    required this.deliveryType,
    required this.deliveryFee,
    required this.payMethod,
    required this.status,
    required this.createdAt,
    this.stopId,
    this.stopName,
    this.homeNote,
    this.notes,
    this.allowBatch = true,
    this.riderName,
    this.shopName,
    this.subtotal = 0,
    this.billPhotoLabel,
  });

  final String id;
  final String publicId;
  final String customerPhone;
  String itemsText;
  CrDeliveryType deliveryType;
  int deliveryFee;
  CrPayMethod payMethod;
  CrOrderStatus status;
  DateTime createdAt;
  String? stopId;
  String? stopName;
  String? homeNote;
  String? notes;
  bool allowBatch;
  String? riderName;
  String? shopName;
  int subtotal;
  String? billPhotoLabel;

  int get total => subtotal + deliveryFee;

  CrOrder copy() => CrOrder(
        id: id,
        publicId: publicId,
        customerPhone: customerPhone,
        itemsText: itemsText,
        deliveryType: deliveryType,
        deliveryFee: deliveryFee,
        payMethod: payMethod,
        status: status,
        createdAt: createdAt,
        stopId: stopId,
        stopName: stopName,
        homeNote: homeNote,
        notes: notes,
        allowBatch: allowBatch,
        riderName: riderName,
        shopName: shopName,
        subtotal: subtotal,
        billPhotoLabel: billPhotoLabel,
      );
}

String statusLabel(CrOrderStatus s) {
  switch (s) {
    case CrOrderStatus.draft:
      return 'Draft';
    case CrOrderStatus.open:
      return 'Open';
    case CrOrderStatus.accepted:
      return 'Accepted';
    case CrOrderStatus.shopping:
      return 'Shopping';
    case CrOrderStatus.billed:
      return 'Billed';
    case CrOrderStatus.onTheWay:
      return 'On the way';
    case CrOrderStatus.arrived:
      return 'Arrived';
    case CrOrderStatus.delivered:
      return 'Delivered';
    case CrOrderStatus.cancelled:
      return 'Cancelled';
    case CrOrderStatus.disputed:
      return 'Disputed';
  }
}
