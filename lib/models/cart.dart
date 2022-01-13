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

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      userid: json["userid"],
      productid: json["productid"],
      quantity: json["quantity"],
      id: json["id"],
      size: json["size"],
      color: json["color"],
    );
  }
}
