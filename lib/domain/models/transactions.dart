class Transactions {
  Pagination? pagination;
  List<Transaction>? transactions;

  Transactions({this.pagination, this.transactions});

  Transactions.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      transactions = <Transaction>[];
      json['data'].forEach((v) {
        transactions!.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.transactions != null) {
      data['data'] = this.transactions!.map((v) => v.toJson()).toList();
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

class Transaction {
  String? id;
  String? createAt;
  int? amount;
  String? type;
  String? status;

  Transaction({this.id, this.createAt, this.amount, this.type, this.status});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createAt = json['createAt'];
    amount = json['amount'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['status'] = this.status;
    return data;
  }
}
