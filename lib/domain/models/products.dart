class Products {
  Pagination? pagination;
  List<Product>? product;

  Products({this.pagination, this.product});

  Products.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      product = <Product>[];
      json['data'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.product != null) {
      data['data'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? pageNumber;
  int? pageSize;
  int? totalRow;

  Pagination({this.pageNumber, this.pageSize, this.totalRow});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalRow = json['totalRow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalRow'] = this.totalRow;
    return data;
  }
}

class Product {
  String? id;
  String? name;
  List<ProductCategories>? productCategories;
  String? description;
  int? sold;
  int? quantity;
  int? price;
  int? promotionalPrice;
  String? expiredAt;
  Null? rated;
  String? createAt;
  String? status;
  String? thumbnailUrl;

  Product(
      {this.id,
      this.name,
      this.productCategories,
      this.description,
      this.sold,
      this.quantity,
      this.price,
      this.promotionalPrice,
      this.expiredAt,
      this.rated,
      this.createAt,
      this.status,
      this.thumbnailUrl});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['productCategories'] != null) {
      productCategories = <ProductCategories>[];
      json['productCategories'].forEach((v) {
        productCategories!.add(new ProductCategories.fromJson(v));
      });
    }
    description = json['description'];
    sold = json['sold'];
    quantity = json['quantity'];
    price = json['price'];
    promotionalPrice = json['promotionalPrice'];
    expiredAt = json['expiredAt'];
    rated = json['rated'];
    createAt = json['createAt'];
    status = json['status'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.productCategories != null) {
      data['productCategories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['sold'] = this.sold;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['promotionalPrice'] = this.promotionalPrice;
    data['expiredAt'] = this.expiredAt;
    data['rated'] = this.rated;
    data['createAt'] = this.createAt;
    data['status'] = this.status;
    data['thumbnailUrl'] = this.thumbnailUrl;
    return data;
  }
}

class ProductCategories {
  Category? category;

  ProductCategories({this.category});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  String? id;
  String? name;
  CategoryGroup? categoryGroup;

  Category({this.id, this.name, this.categoryGroup});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryGroup = json['categoryGroup'] != null
        ? new CategoryGroup.fromJson(json['categoryGroup'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.categoryGroup != null) {
      data['categoryGroup'] = this.categoryGroup!.toJson();
    }
    return data;
  }
}

class CategoryGroup {
  String? id;
  String? name;

  CategoryGroup({this.id, this.name});

  CategoryGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}