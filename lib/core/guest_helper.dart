import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'constants.dart';

void showGuestLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Sign in Required',
          style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text('You need to sign in to save favorites and meal plans. Would you like to sign in now?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: kTextSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.pop(ctx);
            context.read<AuthProvider>().signOut();
          },
          child: const Text('Sign In', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
