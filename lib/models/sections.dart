import '../models/product.dart';
// TODO: change this for the singular
class Sections {
  Sections({
    this.type,
    this.moreUrl,
    this.products,
  });

  final String type;
  final String moreUrl;
  final List<Product> products;
}
