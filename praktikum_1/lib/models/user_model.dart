class User {
  final String email;
  final String username;
  final String password;

  User({
    required this.email,
    required this.username,
    required this.password,
  });
}

// "Database" sementara berupa List statis di memori
class UserRepository {
  // static supaya datanya sama walau diakses dari halaman berbeda
  static final List<User> _users = [];

  static void addUser(User user) {
    _users.add(user);
  }

  // Cek apakah email & password cocok dengan salah satu user yang terdaftar
  static User? findUser(String email, String password) {
    try {
      return _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null; // tidak ditemukan
    }
  }

  // Cek apakah email sudah pernah dipakai (untuk validasi register)
  static bool isEmailRegistered(String email) {
    return _users.any((user) => user.email == email);
  }
}