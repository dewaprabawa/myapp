import 'package:flutter/material.dart';

class NotificationIcons extends StatelessWidget {
  const NotificationIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Badge(
        backgroundColor: Colors.blue,
        label: Text('1'),
        child: IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: const Color(0xFF6B7280),
          onPressed: () {},
        ),
      ),
    );
  }
}
