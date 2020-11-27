class Genre {
  int _id;
  String _name;

  Genre(this._id, this._name);

  Genre.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'];

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'Genre{_id: $_id, _name: $_name}';
  }
}
