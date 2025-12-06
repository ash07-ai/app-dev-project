import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('OR'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              context,
              icon: Icons.g_mobiledata_rounded,
              color: Colors.red,
              onTap: () {
                // Implement Google login
              },
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              context,
              icon: Icons.facebook,
              color: Colors.blue,
              onTap: () {
                // Implement Facebook login
              },
            ),
            const SizedBox(width: 20),
            _buildSocialButton(
              context,
              icon: Icons.apple,
              color: Colors.black,
              onTap: () {
                // Implement Apple login
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }
}