import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create storage
  final storage = new FlutterSecureStorage();

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    // Write value
    await storage.write(
        key: "token", value: userCredential.user?.uid.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    // Read value
    return await storage.read(key: "token");
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await storage.delete(key: "token");
    } catch (error) {}
  }
}
