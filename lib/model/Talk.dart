class Talk {

  String _name;
  String _message;
  String _imagePath;

  Talk(this._name, this._message, this._imagePath);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get message => _message;

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }

  set message(String value) {
    _message = value;
  }
}