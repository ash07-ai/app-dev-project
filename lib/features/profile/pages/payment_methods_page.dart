import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/payment_method.dart';
import '../../../data/providers/payment_method_provider.dart';
import '../../../core/services/firebase_auth_service.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = context.read<FirebaseAuthService>();
      final provider = PaymentMethodProvider(authService);
      provider.loadPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<FirebaseAuthService>();
    final provider = PaymentMethodProvider(authService);

    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Methods'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddEditPaymentDialog(context, provider),
            ),
          ],
        ),
        body: Consumer<PaymentMethodProvider>(
          builder: (context, paymentProvider, child) {
            if (paymentProvider.paymentMethods.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No payment methods saved',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a payment method to get started',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditPaymentDialog(context, paymentProvider),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Payment Method'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: paymentProvider.paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentProvider.paymentMethods[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      _getPaymentIcon(method.type),
                      color: method.isDefault ? AppColors.primary : Colors.grey,
                    ),
                    title: Text(
                      method.displayName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (method.cardHolderName != null) ...[
                          const SizedBox(height: 4),
                          Text('Cardholder: ${method.cardHolderName}'),
                        ],
                        if (method.expiryDate != null) ...[
                          const SizedBox(height: 4),
                          Text('Expires: ${method.expiryDate}'),
                        ],
                        if (method.isDefault) ...[
                          const SizedBox(height: 4),
                          Chip(
                            label: const Text('Default', style: TextStyle(fontSize: 10)),
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showAddEditPaymentDialog(context, paymentProvider, method: method),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(context, paymentProvider, method),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String type) {
    switch (type) {
      case 'credit_card':
      case 'debit_card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  void _showAddEditPaymentDialog(
    BuildContext context,
    PaymentMethodProvider provider, {
    PaymentMethod? method,
  }) {
    final isEdit = method != null;
    final cardNumberController = TextEditingController(text: method?.cardNumber ?? '');
    final cardHolderController = TextEditingController(text: method?.cardHolderName ?? '');
    final expiryController = TextEditingController(text: method?.expiryDate ?? '');
    final billingAddressController = TextEditingController(text: method?.billingAddress ?? '');
    bool isDefault = method?.isDefault ?? false;
    String selectedType = method?.type ?? 'credit_card';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEdit ? 'Edit Payment Method' : 'Add Payment Method'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Payment Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'credit_card', child: Text('Credit Card')),
                    DropdownMenuItem(value: 'debit_card', child: Text('Debit Card')),
                    DropdownMenuItem(value: 'paypal', child: Text('PayPal')),
                  ],
                  onChanged: (value) => setState(() => selectedType = value ?? 'credit_card'),
                ),
                if (selectedType != 'paypal') ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Card Number (Last 4 digits)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: cardHolderController,
                    decoration: const InputDecoration(
                      labelText: 'Cardholder Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 5,
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: billingAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Billing Address (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Set as default payment method'),
                  value: isDefault,
                  onChanged: (value) => setState(() => isDefault = value ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedType != 'paypal' &&
                    (cardNumberController.text.isEmpty ||
                        cardHolderController.text.isEmpty ||
                        expiryController.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields')),
                  );
                  return;
                }

                final newMethod = PaymentMethod(
                  id: method?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  type: selectedType,
                  cardNumber: cardNumberController.text.trim().isEmpty
                      ? null
                      : cardNumberController.text.trim(),
                  cardHolderName: cardHolderController.text.trim().isEmpty
                      ? null
                      : cardHolderController.text.trim(),
                  expiryDate: expiryController.text.trim().isEmpty
                      ? null
                      : expiryController.text.trim(),
                  billingAddress: billingAddressController.text.trim().isEmpty
                      ? null
                      : billingAddressController.text.trim(),
                  isDefault: isDefault,
                );

                try {
                  if (isEdit) {
                    await provider.updatePaymentMethod(newMethod);
                  } else {
                    await provider.addPaymentMethod(newMethod);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEdit ? 'Payment method updated successfully' : 'Payment method added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    PaymentMethodProvider provider,
    PaymentMethod method,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text('Are you sure you want to delete ${method.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await provider.deletePaymentMethod(method.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment method deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

