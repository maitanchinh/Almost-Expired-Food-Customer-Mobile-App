class Account {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? address;
  String? avatarUrl;
  String? status;

  Account(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.address,
      this.avatarUrl,
      this.status});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    avatarUrl = json['avatarUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['avatarUrl'] = this.avatarUrl;
    data['status'] = this.status;
    return data;
  }
}
