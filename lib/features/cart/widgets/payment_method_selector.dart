import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class PaymentMethodSelector extends StatefulWidget {
  final Function(String) onMethodSelected;
  final String initialMethod;

  const PaymentMethodSelector({
    super.key,
    required this.onMethodSelected,
    this.initialMethod = 'Credit Card',
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late String _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPaymentOption(
          'Credit Card',
          'Pay with Visa, Mastercard, etc.',
          Icons.credit_card,
          _selectedMethod == 'Credit Card',
          () => _selectMethod('Credit Card'),
        ),
        const SizedBox(height: 8),
        _buildPaymentOption(
          'PayPal',
          'Pay with your PayPal account',
          Icons.account_balance_wallet,
          _selectedMethod == 'PayPal',
          () => _selectMethod('PayPal'),
        ),
        const SizedBox(height: 8),
        _buildPaymentOption(
          'Cash on Delivery',
          'Pay when you receive your order',
          Icons.money,
          _selectedMethod == 'Cash on Delivery',
          () => _selectMethod('Cash on Delivery'),
        ),
      ],
    );
  }

  void _selectMethod(String method) {
    setState(() {
      _selectedMethod = method;
    });
    widget.onMethodSelected(method);
  }

  Widget _buildPaymentOption(
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}