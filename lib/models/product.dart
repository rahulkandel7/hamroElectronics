class Product {
  final int id;
  final String name;
  final String sku;
  final String photoPath1;
  final String? photoPath2;
  final String? photoPath3;
  final int categoryId;
  final String bandname;
  final int? subCategoryId;
  final int? subSubCategoryId;
  final int price;
  final int? discountedPrice;
  final String? description;
  final String? color;
  final String? size;
  final int status;
  final int stock;
  final int flashSale;
  final int deleted;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.sku,
    required this.photoPath1,
    this.photoPath2,
    this.photoPath3,
    required this.categoryId,
    required this.bandname,
    this.subCategoryId,
    this.subSubCategoryId,
    this.description,
    this.color,
    this.size,
    required this.status,
    required this.stock,
    required this.flashSale,
    required this.deleted,
    this.discountedPrice,
  });
}
