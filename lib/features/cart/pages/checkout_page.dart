// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // // import '../../../core/constants/app_constants.dart';
// // // import '../../../core/constants/colors.dart';
// // // import '../../../core/utils/routes.dart';
// // // import '../../../core/services/auth_service.dart';
// // // import '../../../data/providers/cart_provider.dart';
// // // import '../../../data/providers/order_provider.dart';
// // // import '../../../data/models/order.dart';
// // // import '../../../data/models/cart_item.dart';

// // // class CheckoutPage extends StatefulWidget {
// // //   const CheckoutPage({super.key});

// // //   @override
// // //   State<CheckoutPage> createState() => _CheckoutPageState();
// // // }

// // // class _CheckoutPageState extends State<CheckoutPage> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   String _selectedPaymentMethod = 'Credit Card';
// // //   bool _isProcessing = false;

// // //   // Form controllers
// // //   final _nameController = TextEditingController();
// // //   final _addressController = TextEditingController();
// // //   final _cityController = TextEditingController();
// // //   final _zipController = TextEditingController();
// // //   final _phoneController = TextEditingController();

// // //   // void _placeOrder() {
// // //   //   if (_formKey.currentState!.validate()) {
// // //   //     setState(() {
// // //   //       _isProcessing = true;
// // //   //     });

// // //   //     // Get providers
// // //   //     final cartProvider = Provider.of<CartProvider>(context, listen: false);
// // //   //     final orderProvider = Provider.of<OrderProvider>(context, listen: false);
// // //   //     final authService = Provider.of<AuthService>(context, listen: false);

// // //   //     // Check if cart is empty
// // //   //     if (cartProvider.items.isEmpty) {
// // //   //       setState(() {
// // //   //         _isProcessing = false;
// // //   //       });
// // //   //       ScaffoldMessenger.of(context).showSnackBar(
// // //   //         const SnackBar(content: Text('Your cart is empty')),
// // //   //       );
// // //   //       return;
// // //   //     }

// // //   //     // Calculate totals
// // //   //     final subtotal = cartProvider.totalAmount;
// // //   //     final shipping = 10.00;
// // //   //     final tax = subtotal * 0.08;
// // //   //     final total = subtotal + shipping + tax;

// // //   //     // Create shipping address string
// // //   //     final shippingAddress = '${_addressController.text}, ${_cityController.text}, ${_zipController.text}';

// // //   //     // Create order
// // //   //     final order = Order(
// // //   //       id: DateTime.now().millisecondsSinceEpoch.toString(),
// // //   //       userId: authService.userEmail,
// // //   //       items: List<CartItem>.from(cartProvider.items),
// // //   //       totalAmount: total,
// // //   //       orderDate: DateTime.now(),
// // //   //       status: OrderStatus.pending,
// // //   //       shippingAddress: shippingAddress,
// // //   //       paymentMethod: _selectedPaymentMethod,
// // //   //     );

// // //   //     // Simulate API call
// // //   //     Future.delayed(const Duration(seconds: 2), () {
// // //   //       // Add order to provider
// // //   //       orderProvider.addOrder(order);
        
// // //   //       // Clear cart
// // //   //       cartProvider.clearCart();

// // //   //       setState(() {
// // //   //         _isProcessing = false;
// // //   //       });

// // //   //       // Show success dialog
// // //   //       _showOrderSuccessDialog(order.id);
// // //   //     });
// // //   //   }
// // //   // }

// // //   Future<void> _placeOrder() async {
// // //   if (!_formKey.currentState!.validate()) return;

// // //   final cartProvider = context.read<CartProvider>();
// // //   final orderProvider = context.read<OrderProvider>();
// // //   final auth = FirebaseAuth.instance;

// // //   final user = auth.currentUser;
// // //   if (user == null) {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       const SnackBar(content: Text('You must be logged in to place an order.')),
// // //     );
// // //     return;
// // //   }

// // //   setState(() {
// // //     _isProcessing = true;         // 🔵 show spinner
// // //   });

// // //   try {
// // //     final order = Order(
// // //       id: '',                      // let provider/Firestore generate id
// // //       userId: user.uid,
// // //       items: List<CartItem>.from(cartProvider.items),
// // //       totalAmount: cartProvider.totalAmount,
// // //       status: OrderStatus.pending,
// // //       orderDate: DateTime.now(),
// // //       paymentMethod: _selectedPaymentMethod,               // use your variable
// // //       shippingAddress: _addressController.text.trim(),     // use your address field
// // //     );

// // //     // 🔴 VERY IMPORTANT: only one call, and we await it.
// // //     await orderProvider.addOrder(order);

// // //     // clear cart
// // //     cartProvider.clear();

// // //     if (!mounted) return;

// // //     // go to success / orders screen
// // //     Navigator.pushReplacementNamed(context, AppRoutes.orderSuccess);
// // //   } catch (e) {
// // //     if (!mounted) return;
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(content: Text('Failed to place order: $e')),
// // //     );
// // //   } finally {
// // //     if (!mounted) return;
// // //     setState(() {
// // //       _isProcessing = false;      // 🔵 ALWAYS hide spinner
// // //     });
// // //   }
// // // }


// // //   void _showOrderSuccessDialog(String orderId) {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (context) => AlertDialog(
// // //         title: const Text('Order Placed Successfully'),
// // //         content: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             const Icon(
// // //               Icons.check_circle,
// // //               color: Colors.green,
// // //               size: 60,
// // //             ),
// // //             const SizedBox(height: 16),
// // //             const Text(
// // //               'Your order has been placed successfully. You will receive a confirmation email shortly.',
// // //               textAlign: TextAlign.center,
// // //             ),
// // //             const SizedBox(height: 8),
// // //             Text(
// // //               'Order ID: #$orderId',
// // //               style: const TextStyle(
// // //                 fontWeight: FontWeight.bold,
// // //                 fontSize: 12,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () {
// // //               Navigator.pop(context);
// // //               Navigator.pushNamedAndRemoveUntil(
// // //                 context,
// // //                 AppRoutes.home,
// // //                 (route) => false,
// // //               );
// // //             },
// // //             child: const Text('Continue Shopping'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _nameController.dispose();
// // //     _addressController.dispose();
// // //     _cityController.dispose();
// // //     _zipController.dispose();
// // //     _phoneController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final cartProvider = Provider.of<CartProvider>(context);
// // //     final subtotal = cartProvider.totalAmount;
// // //     final shipping = 10.00;
// // //     final tax = subtotal * 0.08;
// // //     final total = subtotal + shipping + tax;

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Checkout'),
// // //       ),
// // //       body: _isProcessing
// // //           ? const Center(
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   CircularProgressIndicator(),
// // //                   SizedBox(height: 16),
// // //                   Text('Processing your order...'),
// // //                 ],
// // //               ),
// // //             )
// // //           : Form(
// // //               key: _formKey,
// // //               child: ListView(
// // //                 padding: const EdgeInsets.all(16),
// // //                 children: [
// // //                   // Shipping information
// // //                   const Text(
// // //                     'Shipping Information',
// // //                     style: TextStyle(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   TextFormField(
// // //                     controller: _nameController,
// // //                     decoration: const InputDecoration(
// // //                       labelText: 'Full Name',
// // //                       border: OutlineInputBorder(),
// // //                     ),
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return 'Please enter your name';
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   TextFormField(
// // //                     controller: _addressController,
// // //                     decoration: const InputDecoration(
// // //                       labelText: 'Address',
// // //                       border: OutlineInputBorder(),
// // //                     ),
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return 'Please enter your address';
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: TextFormField(
// // //                           controller: _cityController,
// // //                           decoration: const InputDecoration(
// // //                             labelText: 'City',
// // //                             border: OutlineInputBorder(),
// // //                           ),
// // //                           validator: (value) {
// // //                             if (value == null || value.isEmpty) {
// // //                               return 'Please enter your city';
// // //                             }
// // //                             return null;
// // //                           },
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 16),
// // //                       Expanded(
// // //                         child: TextFormField(
// // //                           controller: _zipController,
// // //                           decoration: const InputDecoration(
// // //                             labelText: 'ZIP Code',
// // //                             border: OutlineInputBorder(),
// // //                           ),
// // //                           keyboardType: TextInputType.number,
// // //                           validator: (value) {
// // //                             if (value == null || value.isEmpty) {
// // //                               return 'Please enter ZIP code';
// // //                             }
// // //                             return null;
// // //                           },
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   TextFormField(
// // //                     controller: _phoneController,
// // //                     decoration: const InputDecoration(
// // //                       labelText: 'Phone Number',
// // //                       border: OutlineInputBorder(),
// // //                     ),
// // //                     keyboardType: TextInputType.phone,
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return 'Please enter your phone number';
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 24),

// // //                   // Payment method
// // //                   const Text(
// // //                     'Payment Method',
// // //                     style: TextStyle(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 16),
                  
// // //                   // Payment methods
// // //                   _buildPaymentOption(
// // //                     'Credit Card',
// // //                     'Pay with Visa, Mastercard, etc.',
// // //                     Icons.credit_card,
// // //                     _selectedPaymentMethod == 'Credit Card',
// // //                     () => setState(() => _selectedPaymentMethod = 'Credit Card'),
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   _buildPaymentOption(
// // //                     'PayPal',
// // //                     'Pay with your PayPal account',
// // //                     Icons.account_balance_wallet,
// // //                     _selectedPaymentMethod == 'PayPal',
// // //                     () => setState(() => _selectedPaymentMethod = 'PayPal'),
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   _buildPaymentOption(
// // //                     'Cash on Delivery',
// // //                     'Pay when you receive your order',
// // //                     Icons.money,
// // //                     _selectedPaymentMethod == 'Cash on Delivery',
// // //                     () => setState(() => _selectedPaymentMethod = 'Cash on Delivery'),
// // //                   ),
                  
// // //                   const SizedBox(height: 24),

// // //                   // Order summary
// // //                   const Text(
// // //                     'Order Summary',
// // //                     style: TextStyle(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 16),
                  
// // //                   // Price summary
// // //                   Container(
// // //                     padding: const EdgeInsets.all(16),
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.grey.shade50,
// // //                       borderRadius: BorderRadius.circular(8),
// // //                       border: Border.all(color: Colors.grey.shade200),
// // //                     ),
// // //                     child: Column(
// // //                       children: [
// // //                         _buildSummaryRow('Subtotal', subtotal),
// // //                         const SizedBox(height: 8),
// // //                         _buildSummaryRow('Shipping', shipping),
// // //                         const SizedBox(height: 8),
// // //                         _buildSummaryRow('Tax', tax),
// // //                         const Divider(height: 24),
// // //                         _buildSummaryRow(
// // //                           'Total',
// // //                           total,
// // //                           isTotal: true,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
                  
// // //                   const SizedBox(height: 24),

// // //                   // Place order button
// // //                   SizedBox(
// // //                     width: double.infinity,
// // //                     height: 50,
// // //                     child: ElevatedButton(
// // //                       onPressed: _placeOrder,
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: AppColors.primary,
// // //                         foregroundColor: Colors.white,
// // //                       ),
// // //                       child: const Text('Place Order'),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //     );
// // //   }
  
// // //   Widget _buildPaymentOption(
// // //     String title,
// // //     String subtitle,
// // //     IconData icon,
// // //     bool isSelected,
// // //     VoidCallback onTap,
// // //   ) {
// // //     return InkWell(
// // //       onTap: onTap,
// // //       child: Container(
// // //         padding: const EdgeInsets.all(16),
// // //         decoration: BoxDecoration(
// // //           border: Border.all(
// // //             color: isSelected ? AppColors.primary : Colors.grey.shade300,
// // //             width: isSelected ? 2 : 1,
// // //           ),
// // //           borderRadius: BorderRadius.circular(8),
// // //         ),
// // //         child: Row(
// // //           children: [
// // //             Icon(
// // //               icon,
// // //               color: isSelected ? AppColors.primary : Colors.grey,
// // //             ),
// // //             const SizedBox(width: 16),
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     title,
// // //                     style: const TextStyle(
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                   Text(
// // //                     subtitle,
// // //                     style: TextStyle(
// // //                       color: Colors.grey.shade600,
// // //                       fontSize: 12,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //             if (isSelected)
// // //               Icon(
// // //                 Icons.check_circle,
// // //                 color: AppColors.primary,
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
  
// // //   Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
// // //     return Row(
// // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //       children: [
// // //         Text(
// // //           label,
// // //           style: TextStyle(
// // //             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
// // //             fontSize: isTotal ? 16 : 14,
// // //           ),
// // //         ),
// // //         Text(
// // //           '${AppConstants.currencySymbol}${amount.toStringAsFixed(2)}',
// // //           style: TextStyle(
// // //             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
// // //             fontSize: isTotal ? 16 : 14,
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }












// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // import '../../../core/constants/app_constants.dart';
// // import '../../../core/constants/colors.dart';
// // import '../../../core/utils/routes.dart';
// // import '../../../core/services/auth_service.dart';
// // import '../../../data/providers/cart_provider.dart';
// // import '../../../data/providers/order_provider.dart';
// // import '../../../data/models/order.dart';
// // import '../../../data/models/cart_item.dart';

// // class CheckoutPage extends StatefulWidget {
// //   const CheckoutPage({super.key});

// //   @override
// //   State<CheckoutPage> createState() => _CheckoutPageState();
// // }

// // class _CheckoutPageState extends State<CheckoutPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   String _selectedPaymentMethod = 'Credit Card';
// //   bool _isProcessing = false;

// //   // Form controllers
// //   final _nameController = TextEditingController();
// //   final _addressController = TextEditingController();
// //   final _cityController = TextEditingController();
// //   final _zipController = TextEditingController();
// //   final _phoneController = TextEditingController();

// //   Future<void> _placeOrder() async {
// //     // validate form first
// //     if (!_formKey.currentState!.validate())
// //     {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text('Please fill all required fields.')),
// //     );
// //     return;
// //     }

// //     final cartProvider = Provider.of<CartProvider>(context, listen: false);
// //     final orderProvider = Provider.of<OrderProvider>(context, listen: false);
// //     final authService = Provider.of<AuthService>(context, listen: false);

// //     // check empty cart
// //     if (cartProvider.items.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Your cart is empty')),
// //       );
// //       return;
// //     }

// //     setState(() {
// //       _isProcessing = true; // show spinner screen
// //     });

// //     try {
// //       // calculate totals (same as your build method)
// //       final subtotal = cartProvider.totalAmount;
// //       const shipping = 10.00;
// //       final tax = subtotal * 0.08;
// //       final total = subtotal + shipping + tax;

// //       // shipping address string
// //       final shippingAddress =
// //           '${_addressController.text}, ${_cityController.text}, ${_zipController.text}';

// //       // generate a stable order id (like old code)
// //       final orderId = DateTime.now().millisecondsSinceEpoch.toString();

// //       final order = Order(
// //         id: orderId,
// //         userId: authService.userEmail, // same as your old code
// //         items: List<CartItem>.from(cartProvider.items),
// //         totalAmount: total,
// //         orderDate: DateTime.now(),
// //         status: OrderStatus.pending,
// //         shippingAddress: shippingAddress,
// //         paymentMethod: _selectedPaymentMethod,
// //       );

// //       // save order (Firestore via provider)
// //       await orderProvider.addOrder(order);

// //       // clear cart
// //       cartProvider.clearCart();

// //       if (!mounted) return;

// //       // stop spinner before showing dialog
// //       setState(() {
// //         _isProcessing = false;
// //       });

// //       // show success dialog
// //       _showOrderSuccessDialog(orderId);
// //     } catch (e) {
// //       if (!mounted) return;
// //       setState(() {
// //         _isProcessing = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to place order: $e')),
// //       );
// //     }
// //   }

// //   void _showOrderSuccessDialog(String orderId) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Order Placed Successfully'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Icon(
// //               Icons.check_circle,
// //               color: Colors.green,
// //               size: 60,
// //             ),
// //             const SizedBox(height: 16),
// //             const Text(
// //               'Your order has been placed successfully. You will receive a confirmation email shortly.',
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Order ID: #$orderId',
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 12,
// //               ),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               Navigator.pushNamedAndRemoveUntil(
// //                 context,
// //                 AppRoutes.home,
// //                 (route) => false,
// //               );
// //             },
// //             child: const Text('Continue Shopping'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _addressController.dispose();
// //     _cityController.dispose();
// //     _zipController.dispose();
// //     _phoneController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final cartProvider = Provider.of<CartProvider>(context);
// //     final subtotal = cartProvider.totalAmount;
// //     const shipping = 10.00;
// //     final tax = subtotal * 0.08;
// //     final total = subtotal + shipping + tax;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Checkout'),
// //       ),
// //       body: _isProcessing
// //           ? const Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   CircularProgressIndicator(),
// //                   SizedBox(height: 16),
// //                   Text('Processing your order...'),
// //                 ],
// //               ),
// //             )
// //           : Form(
// //               key: _formKey,
// //               child: ListView(
// //                 padding: const EdgeInsets.all(16),
// //                 children: [
// //                   // Shipping information
// //                   const Text(
// //                     'Shipping Information',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextFormField(
// //                     controller: _nameController,
// //                     decoration: const InputDecoration(
// //                       labelText: 'Full Name',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your name';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextFormField(
// //                     controller: _addressController,
// //                     decoration: const InputDecoration(
// //                       labelText: 'Address',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your address';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 16),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: TextFormField(
// //                           controller: _cityController,
// //                           decoration: const InputDecoration(
// //                             labelText: 'City',
// //                             border: OutlineInputBorder(),
// //                           ),
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please enter your city';
// //                             }
// //                             return null;
// //                           },
// //                         ),
// //                       ),
// //                       const SizedBox(width: 16),
// //                       Expanded(
// //                         child: TextFormField(
// //                           controller: _zipController,
// //                           decoration: const InputDecoration(
// //                             labelText: 'ZIP Code',
// //                             border: OutlineInputBorder(),
// //                           ),
// //                           keyboardType: TextInputType.number,
// //                           validator: (value) {
// //                             if (value == null || value.isEmpty) {
// //                               return 'Please enter ZIP code';
// //                             }
// //                             return null;
// //                           },
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextFormField(
// //                     controller: _phoneController,
// //                     decoration: const InputDecoration(
// //                       labelText: 'Phone Number',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                     keyboardType: TextInputType.phone,
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your phone number';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 24),

// //                   // Payment method
// //                   const Text(
// //                     'Payment Method',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   _buildPaymentOption(
// //                     'Credit Card',
// //                     'Pay with Visa, Mastercard, etc.',
// //                     Icons.credit_card,
// //                     _selectedPaymentMethod == 'Credit Card',
// //                     () => setState(
// //                         () => _selectedPaymentMethod = 'Credit Card'),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   _buildPaymentOption(
// //                     'PayPal',
// //                     'Pay with your PayPal account',
// //                     Icons.account_balance_wallet,
// //                     _selectedPaymentMethod == 'PayPal',
// //                     () =>
// //                         setState(() => _selectedPaymentMethod = 'PayPal'),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   _buildPaymentOption(
// //                     'Cash on Delivery',
// //                     'Pay when you receive your order',
// //                     Icons.money,
// //                     _selectedPaymentMethod == 'Cash on Delivery',
// //                     () => setState(() =>
// //                         _selectedPaymentMethod = 'Cash on Delivery'),
// //                   ),

// //                   const SizedBox(height: 24),

// //                   // Order summary
// //                   const Text(
// //                     'Order Summary',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   Container(
// //                     padding: const EdgeInsets.all(16),
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.shade50,
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(color: Colors.grey.shade200),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         _buildSummaryRow('Subtotal', subtotal),
// //                         const SizedBox(height: 8),
// //                         _buildSummaryRow('Shipping', shipping),
// //                         const SizedBox(height: 8),
// //                         _buildSummaryRow('Tax', tax),
// //                         const Divider(height: 24),
// //                         _buildSummaryRow(
// //                           'Total',
// //                           total,
// //                           isTotal: true,
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   const SizedBox(height: 24),

// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 50,
// //                     child: ElevatedButton(
// //                       onPressed: _isProcessing ? null : _placeOrder,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: AppColors.primary,
// //                         foregroundColor: Colors.white,
// //                       ),
// //                       child: const Text('Place Order'),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }

// //   Widget _buildPaymentOption(
// //     String title,
// //     String subtitle,
// //     IconData icon,
// //     bool isSelected,
// //     VoidCallback onTap,
// //   ) {
// //     return InkWell(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           border: Border.all(
// //             color: isSelected ? AppColors.primary : Colors.grey.shade300,
// //             width: isSelected ? 2 : 1,
// //           ),
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(
// //               icon,
// //               color: isSelected ? AppColors.primary : Colors.grey,
// //             ),
// //             const SizedBox(width: 16),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     title,
// //                     style: const TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   Text(
// //                     subtitle,
// //                     style: TextStyle(
// //                       color: Colors.grey.shade600,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             if (isSelected)
// //               Icon(
// //                 Icons.check_circle,
// //                 color: AppColors.primary,
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSummaryRow(String label, double amount,
// //       {bool isTotal = false}) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
// //             fontSize: isTotal ? 16 : 14,
// //           ),
// //         ),
// //         Text(
// //           '${AppConstants.currencySymbol}${amount.toStringAsFixed(2)}',
// //           style: TextStyle(
// //             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
// //             fontSize: isTotal ? 16 : 14,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../core/constants/app_constants.dart';
// import '../../../core/constants/colors.dart';
// import '../../../core/utils/routes.dart';
// import '../../../core/services/auth_service.dart';
// import '../../../data/providers/cart_provider.dart';
// import '../../../data/providers/order_provider.dart';
// import '../../../data/models/order.dart';
// import '../../../data/models/cart_item.dart';

// class CheckoutPage extends StatefulWidget {
//   const CheckoutPage({super.key});

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _selectedPaymentMethod = 'Credit Card';
//   bool _isProcessing = false;

//   // Form controllers
//   final _nameController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _zipController = TextEditingController();
//   final _phoneController = TextEditingController();

//   Future<void> _placeOrder() async {
//     // 1) Validate the form
//     final isValid = _formKey.currentState?.validate() ?? false;
//     if (!isValid) {
//       // VERY VISIBLE message if something is empty
//       await showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Missing Information'),
//           content: const Text(
//             'Please fill all required shipping fields before placing the order.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     // 2) Get providers
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);
//     final orderProvider = Provider.of<OrderProvider>(context, listen: false);
//     final authService = Provider.of<AuthService>(context, listen: false);

//     // 3) Cart empty?
//     if (cartProvider.items.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Your cart is empty')),
//       );
//       return;
//     }

//     setState(() {
//       _isProcessing = true; // show spinner screen
//     });

//     try {
//       // 4) Calculate totals (same as UI)
//       final subtotal = cartProvider.totalAmount;
//       const shipping = 10.00;
//       final tax = subtotal * 0.08;
//       final total = subtotal + shipping + tax;

//       // 5) Build shipping address string
//       final shippingAddress =
//           '${_addressController.text}, ${_cityController.text}, ${_zipController.text}';

//       // 6) Simple order id
//       final orderId = DateTime.now().millisecondsSinceEpoch.toString();

//       // 7) Build Order model – IMPORTANT: createdAt, NOT orderDate
//       final order = Order(
//         id: orderId,
//         userId: authService.userEmail, // same as your old logic
//         items: List<CartItem>.from(cartProvider.items),
//         totalAmount: total,
//         status: OrderStatus.pending,
//         createdAt: DateTime.now(),
//         paymentMethod: _selectedPaymentMethod,
//         shippingAddress: shippingAddress,
//       );

//       // 8) Save to Firestore via provider
//       await orderProvider.addOrder(order);

//       // 9) Clear cart
//       cartProvider.clearCart();

//       if (!mounted) return;

//       setState(() {
//         _isProcessing = false;
//       });

//       // 10) Show success dialog
//       _showOrderSuccessDialog(orderId);
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _isProcessing = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to place order: $e')),
//       );
//     }
//   }

//   void _showOrderSuccessDialog(String orderId) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Order Placed Successfully'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.check_circle,
//               color: Colors.green,
//               size: 60,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Your order has been placed successfully. You will receive a confirmation email shortly.',
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Order ID: #$orderId',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 AppRoutes.home,
//                 (route) => false,
//               );
//             },
//             child: const Text('Continue Shopping'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _zipController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final subtotal = cartProvider.totalAmount;
//     const shipping = 10.00;
//     final tax = subtotal * 0.08;
//     final total = subtotal + shipping + tax;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//       ),
//       body: _isProcessing
//           ? const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Processing your order...'),
//                 ],
//               ),
//             )
//           : Form(
//               key: _formKey,
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   // Shipping information
//                   const Text(
//                     'Shipping Information',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Full Name',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _addressController,
//                     decoration: const InputDecoration(
//                       labelText: 'Address',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your address';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: _cityController,
//                           decoration: const InputDecoration(
//                             labelText: 'City',
//                             border: OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your city';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: TextFormField(
//                           controller: _zipController,
//                           decoration: const InputDecoration(
//                             labelText: 'ZIP Code',
//                             border: OutlineInputBorder(),
//                           ),
//                           keyboardType: TextInputType.number,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter ZIP code';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _phoneController,
//                     decoration: const InputDecoration(
//                       labelText: 'Phone Number',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 24),

//                   // Payment method
//                   const Text(
//                     'Payment Method',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   _buildPaymentOption(
//                     'Credit Card',
//                     'Pay with Visa, Mastercard, etc.',
//                     Icons.credit_card,
//                     _selectedPaymentMethod == 'Credit Card',
//                     () => setState(
//                       () => _selectedPaymentMethod = 'Credit Card',
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   _buildPaymentOption(
//                     'PayPal',
//                     'Pay with your PayPal account',
//                     Icons.account_balance_wallet,
//                     _selectedPaymentMethod == 'PayPal',
//                     () => setState(
//                       () => _selectedPaymentMethod = 'PayPal',
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   _buildPaymentOption(
//                     'Cash on Delivery',
//                     'Pay when you receive your order',
//                     Icons.money,
//                     _selectedPaymentMethod == 'Cash on Delivery',
//                     () => setState(
//                       () => _selectedPaymentMethod = 'Cash on Delivery',
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Order summary
//                   const Text(
//                     'Order Summary',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey.shade200),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildSummaryRow('Subtotal', subtotal),
//                         const SizedBox(height: 8),
//                         _buildSummaryRow('Shipping', shipping),
//                         const SizedBox(height: 8),
//                         _buildSummaryRow('Tax', tax),
//                         const Divider(height: 24),
//                         _buildSummaryRow(
//                           'Total',
//                           total,
//                           isTotal: true,
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _isProcessing ? null : _placeOrder,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text('Place Order'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildPaymentOption(
//     String title,
//     String subtitle,
//     IconData icon,
//     bool isSelected,
//     VoidCallback onTap,
//   ) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: isSelected ? AppColors.primary : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? AppColors.primary : Colors.grey,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               Icon(
//                 Icons.check_circle,
//                 color: AppColors.primary,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryRow(
//     String label,
//     double amount, {
//     bool isTotal = false,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             fontSize: isTotal ? 16 : 14,
//           ),
//         ),
//         Text(
//           '${AppConstants.currencySymbol}${amount.toStringAsFixed(2)}',
//           style: TextStyle(
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             fontSize: isTotal ? 16 : 14,
//           ),
//         ),
//       ],
//     );
//   }
// }














import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/routes.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/providers/order_provider.dart';
import '../../../data/models/order.dart';
import '../../../data/models/cart_item.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'Credit Card';
  bool _isProcessing = false;

  // Form controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _placeOrder() async {
    // 1) Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    // 2) Get providers
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();
    final authService = context.read<FirebaseAuthService>();

    // 3) Check cart not empty
    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    setState(() {
      _isProcessing = true; // show spinner
    });

    try {
      // 4) Calculate totals
      final subtotal = cartProvider.totalAmount;
      const shipping = 10.00;
      final tax = subtotal * 0.08;
      final total = subtotal + shipping + tax;

      // 5) Build shipping address text
      final shippingAddress =
          '${_addressController.text}, ${_cityController.text}, ${_zipController.text}';

      // 6) Generate orderId
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // 7) Build Order model  – IMPORTANT: orderDate (your model), not createdAt
      final userId = authService.currentUser?.uid ?? authService.userEmail;
      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to place an order')),
        );
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      final order = Order(
        id: orderId,
        userId: userId,
        items: List<CartItem>.from(cartProvider.items),
        totalAmount: total,
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
        paymentMethod: _selectedPaymentMethod,
        shippingAddress: shippingAddress,
      );

      // 8) Save to Firestore via provider (await once)
      await orderProvider.addOrder(order);

      // 9) Clear cart
      cartProvider.clearCart();

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      // 10) Show success dialog
      _showOrderSuccessDialog(orderId);
    } catch (e, st) {
      // helpful debug log in console
      debugPrint('Error while placing order: $e\n$st');

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to place order. Please try again.'),
        ),
      );
    }
  }

  void _showOrderSuccessDialog(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your order has been placed successfully. You will receive a confirmation email shortly.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Order ID: #$orderId',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final subtotal = cartProvider.totalAmount;
    const shipping = 10.00;
    final tax = subtotal * 0.08;
    final total = subtotal + shipping + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing your order...'),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Shipping information
                  const Text(
                    'Shipping Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter your name'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter your address'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Please enter your city'
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _zipController,
                          decoration: const InputDecoration(
                            labelText: 'ZIP Code',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Please enter ZIP code'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter your phone number'
                            : null,
                  ),
                  const SizedBox(height: 24),

                  // Payment method
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
                    _selectedPaymentMethod == 'Credit Card',
                    () => setState(
                        () => _selectedPaymentMethod = 'Credit Card'),
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentOption(
                    'PayPal',
                    'Pay with your PayPal account',
                    Icons.account_balance_wallet,
                    _selectedPaymentMethod == 'PayPal',
                    () =>
                        setState(() => _selectedPaymentMethod = 'PayPal'),
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentOption(
                    'Cash on Delivery',
                    'Pay when you receive your order',
                    Icons.money,
                    _selectedPaymentMethod == 'Cash on Delivery',
                    () => setState(() =>
                        _selectedPaymentMethod = 'Cash on Delivery'),
                  ),

                  const SizedBox(height: 24),

                  // Order summary
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', subtotal),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Shipping', shipping),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Tax', tax),
                        const Divider(height: 24),
                        _buildSummaryRow(
                          'Total',
                          total,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Place Order'),
                    ),
                  ),
                ],
              ),
            ),
    );
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

  Widget _buildSummaryRow(String label, double amount,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          '${AppConstants.currencySymbol}${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
