import 'db_helper.dart';
import '/domain/user.dart';

class UserDao {
  Future<bool> login(String username, String password) async {
    final db = await DbHelper().initDB();
    final result = await db.query(
      'USER',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<bool> existe(String username) async {
    final db = await DbHelper().initDB();
    final result = await db.query(
      'USER',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<int> cadastrar(User user) async {
    final db = await DbHelper().initDB();
    return db.insert('USER', user.toJson());
  }
}
