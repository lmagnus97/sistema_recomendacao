class User {
  String _userId;
  String _name;
  String _phone;
  String _email;
  String _createdAt;

  User(this._userId, this._name, this._phone, this._email, this._createdAt);

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'phone': phone,
    'email': email,
    'createdAt': createdAt
  };

  String get createdAt => _createdAt;

  set createdAt(String value) {
    _createdAt = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }
}
