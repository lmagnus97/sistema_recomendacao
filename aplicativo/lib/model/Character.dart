class Character{

  String _character;
  String _name;
  String _profilePath;

  Character(this._character, this._name, this._profilePath);

  Character.fromJson(Map<String, dynamic> json)
      : _character = json['character'],
        _name = json['name'],
        _profilePath = json['profile_path'];

  String get profilePath => _profilePath;

  set profilePath(String value) {
    _profilePath = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get character => _character;

  set character(String value) {
    _character = value;
  }
}