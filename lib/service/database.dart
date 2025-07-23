import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add user details during sign-up
  Future<void> addUserDetails(Map<String, dynamic> userInfoMap, String userId) async {
    try {
      await _firestore.collection("users").doc(userId).set(userInfoMap);
    } catch (e) {
      print("❌ Error adding user details: $e");
      rethrow;
    }
  }

  /// Add order details under user's collection
  Future<void> addUserOrderDetails(Map<String, dynamic> userOrderMap, String userId, String orderId) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("Orders")
          .doc(orderId)
          .set(userOrderMap);
    } catch (e) {
      print("❌ Error adding user order: $e");
      rethrow;
    }
  }

  /// Add order to admin collection
  Future<void> addAdminOrderDetails(Map<String, dynamic> userOrderMap, String orderId) async {
    try {
      await _firestore.collection("Orders").doc(orderId).set(userOrderMap);
    } catch (e) {
      print("❌ Error adding admin order: $e");
      rethrow;
    }
  }

  /// Get all orders for a user
  Future<Stream<QuerySnapshot>> getUserOrders(String userId) async {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("Orders")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  /// Get all orders for admin
  Future<Stream<QuerySnapshot>> getAdminOrders() async {
    return _firestore
        .collection("Orders")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  /// Update admin order status
  Future<void> updateAdminOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection("Orders").doc(orderId).update({"status": status});
    } catch (e) {
      print("❌ Error updating admin order status: $e");
      rethrow;
    }
  }

  /// Update user order status
  Future<void> updateUserOrderStatus(String userId, String orderId, String status) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("Orders")
          .doc(orderId)
          .update({"status": status});
    } catch (e) {
      print("❌ Error updating user order status: $e");
      rethrow;
    }
  }

  /// Optional: Delete user order
  Future<void> deleteUserOrder(String userId, String orderId) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("Orders")
          .doc(orderId)
          .delete();
    } catch (e) {
      print("❌ Error deleting user order: $e");
      rethrow;
    }
  }

  /// Optional: Delete admin order
  Future<void> deleteAdminOrder(String orderId) async {
    try {
      await _firestore.collection("Orders").doc(orderId).delete();
    } catch (e) {
      print("❌ Error deleting admin order: $e");
      rethrow;
    }
  }
}
