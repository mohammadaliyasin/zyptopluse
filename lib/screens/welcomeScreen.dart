import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B232A),
      body: Stack(
        children: [
          Image.asset('images/sr.png',fit: BoxFit.cover,),
          Center(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Image.asset('images/welcome.png'),
                  SizedBox(height: 20),
                  Text(
                    'Your account has been\nsuccessfully created!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5ED5A8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff171D22),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
