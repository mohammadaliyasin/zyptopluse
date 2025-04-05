import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthToggle extends StatefulWidget {
  final int selectedIndex;

  const AuthToggle({super.key, required this.selectedIndex});

  @override
  State<AuthToggle> createState() => _AuthToggleState();
}

class _AuthToggleState extends State<AuthToggle> {
  late int _selectedIndex = widget.selectedIndex;

  void _onToggle(int index) {
    if (_selectedIndex == index) return;

    setState(() => _selectedIndex = index);

    // Use GoRouter for navigation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (index == 0) {
        context.go('/login'); // Navigate to the login screen
      } else {
        context.go('/signup'); // Navigate to the signup screen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xff161C22),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: ['Sign in', 'Sign up'].asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => _onToggle(index),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xff1B232A) : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? const Color(0xffC1C7CD) : const Color(0xff777777),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}