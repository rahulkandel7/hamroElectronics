class Order {
  final String pname;
  final String image;
  final int pid;
  final String status;
  final String? cancelReason;

  Order({
    required this.pid,
    required this.pname,
    required this.status,
    required this.image,
    this.cancelReason,
  });
}
