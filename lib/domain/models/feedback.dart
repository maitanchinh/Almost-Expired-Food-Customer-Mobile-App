import 'package:appetit/domain/models/account.dart';

class Feedback {
  Pagination? pagination;
  List<Comment>? data;

  Feedback({this.pagination, this.data});

  Feedback.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <Comment>[];
      json['data'].forEach((v) {
        data!.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

class Comment {
  String? id;
  int? star;
  String? message;
  Account? customer;
  String? createAt;

  Comment({this.id, this.star, this.message, this.customer, this.createAt});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    star = json['star'];
    message = json['message'];
    customer = json['customer'] != null
        ? new Account.fromJson(json['customer'])
        : null;
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['star'] = this.star;
    data['message'] = this.message;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}

