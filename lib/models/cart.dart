class Cart {
  final int? id;
  final int userid;
  final int productid;
  final int quantity;
  final String? color;
  final String? size;

  Cart({
    this.id,
    required this.userid,
    required this.productid,
    required this.quantity,
    this.size,
    this.color,
  });
}
