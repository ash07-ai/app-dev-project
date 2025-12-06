import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/foundation.dart';
import '../models/payment_method.dart';
import '../../core/services/firebase_auth_service.dart';

class PaymentMethodProvider extends ChangeNotifier {
  final _firestore = firestore.FirebaseFirestore.instance;
  final FirebaseAuthService _authService;

  List<PaymentMethod> _paymentMethods = [];
  List<PaymentMethod> get paymentMethods => [..._paymentMethods];

  PaymentMethodProvider(this._authService);

  Future<void> loadPaymentMethods() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('payment_methods')
          .get();

      _paymentMethods = snapshot.docs
          .map((doc) => PaymentMethod.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading payment methods: $e');
    }
  }

  Future<void> addPaymentMethod(PaymentMethod method) async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      // If this is set as default, unset others
      if (method.isDefault) {
        for (var pm in _paymentMethods) {
          if (pm.isDefault && pm.id != method.id) {
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('payment_methods')
                .doc(pm.id)
                .update({'isDefault': false});
          }
        }
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('payment_methods')
          .doc(method.id)
          .set(method.toMap());

      _paymentMethods.add(method);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding payment method: $e');
      rethrow;
    }
  }

  Future<void> updatePaymentMethod(PaymentMethod method) async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      // If this is set as default, unset others
      if (method.isDefault) {
        for (var pm in _paymentMethods) {
          if (pm.isDefault && pm.id != method.id) {
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('payment_methods')
                .doc(pm.id)
                .update({'isDefault': false});
          }
        }
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('payment_methods')
          .doc(method.id)
          .update(method.toMap());

      final index = _paymentMethods.indexWhere((pm) => pm.id == method.id);
      if (index >= 0) {
        _paymentMethods[index] = method;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating payment method: $e');
      rethrow;
    }
  }

  Future<void> deletePaymentMethod(String methodId) async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('payment_methods')
          .doc(methodId)
          .delete();

      _paymentMethods.removeWhere((pm) => pm.id == methodId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting payment method: $e');
      rethrow;
    }
  }

  PaymentMethod? get defaultPaymentMethod {
    try {
      return _paymentMethods.firstWhere((pm) => pm.isDefault);
    } catch (e) {
      return _paymentMethods.isNotEmpty ? _paymentMethods.first : null;
    }
  }
}

