import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/foundation.dart';
import '../models/shipping_address.dart';
import '../../core/services/firebase_auth_service.dart';

class ShippingAddressProvider extends ChangeNotifier {
  final _firestore = firestore.FirebaseFirestore.instance;
  final FirebaseAuthService _authService;

  List<ShippingAddress> _addresses = [];
  List<ShippingAddress> get addresses => [..._addresses];

  ShippingAddressProvider(this._authService);

  Future<void> loadAddresses() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('shipping_addresses')
          .get();

      _addresses = snapshot.docs
          .map((doc) => ShippingAddress.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    }
  }

  Future<void> addAddress(ShippingAddress address) async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      // If this is set as default, unset others
      if (address.isDefault) {
        for (var addr in _addresses) {
          if (addr.isDefault && addr.id != address.id) {
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('shipping_addresses')
                .doc(addr.id)
                .update({'isDefault': false});
          }
        }
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('shipping_addresses')
          .doc(address.id)
          .set(address.toMap());

      _addresses.add(address);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding address: $e');
      rethrow;
    }
  }

  Future<void> updateAddress(ShippingAddress address) async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      // If this is set as default, unset others
      if (address.isDefault) {
        for (var addr in _addresses) {
          if (addr.isDefault && addr.id != address.id) {
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('shipping_addresses')
                .doc(addr.id)
                .update({'isDefault': false});
          }
        }
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('shipping_addresses')
          .doc(address.id)
          .update(address.toMap());

      final index = _addresses.indexWhere((a) => a.id == address.id);
      if (index >= 0) {
        _addresses[index] = address;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('shipping_addresses')
          .doc(addressId)
          .delete();

      _addresses.removeWhere((a) => a.id == addressId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting address: $e');
      rethrow;
    }
  }

  ShippingAddress? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }
}

