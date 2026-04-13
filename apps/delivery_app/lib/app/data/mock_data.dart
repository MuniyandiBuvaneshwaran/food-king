class DeliveryOrder {
  DeliveryOrder({
    required this.id,
    required this.customer,
    required this.status,
    required this.amount,
    required this.address,
  });

  final String id;
  final String customer;
  final String status;
  final double amount;
  final String address;
}

class DeliveryMockData {
  static final assignedOrders = List<DeliveryOrder>.generate(
    20,
    (index) {
      final statuses = ['Assigned', 'Picked', 'On the way'];
      return DeliveryOrder(
        id: 'DB-${5000 + index}',
        customer: 'Customer ${index + 1}',
        status: statuses[index % statuses.length],
        amount: 11 + index * 1.2,
        address: '${90 + index} Market Street, City',
      );
    },
  );

  static final deliveredOrders = List<DeliveryOrder>.generate(
    26,
    (index) {
      final statuses = ['Delivered', 'Failed', 'Returned'];
      return DeliveryOrder(
        id: 'HIS-${4000 + index}',
        customer: 'Customer ${index + 2}',
        status: statuses[index % statuses.length],
        amount: 10 + index * 0.9,
        address: '${30 + index} Station Road, City',
      );
    },
  );
}
