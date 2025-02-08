abstract class RoomRouter {
  String _adminUsername;
  String _adminPassword;

  RoomRouter(this._adminUsername, this._adminPassword);

  void changeAdminCredentials(String username, String password) {
    _adminUsername = username;
    _adminPassword = password;
  }

  String get adminUsername => _adminUsername;
  String get adminPassword => _adminPassword;

  Future<void> login() async {
    throw UnimplementedError();
  }

  Future<String> getUserInfo() async {
    throw UnimplementedError();
  }

  Future<void> setUserInfo(String username, String password) async {
    throw UnimplementedError();
  }
}
