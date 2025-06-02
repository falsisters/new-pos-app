import 'dart:ui';

import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/auth/data/providers/auth_provider.dart';
import 'package:falsisters_pos_android/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController accessKeyController = TextEditingController();

  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -20,
      end: 20,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    nameController.dispose();
    accessKeyController.dispose();
    _floatingController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.accent.withOpacity(0.6),
                  AppColors.primaryLight.withOpacity(0.4),
                ],
              ),
            ),
          ),

          // Animated background elements
          ...List.generate(8, (index) => _buildFloatingElement(size, index)),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo section with animation
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.store_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // App title with enhanced typography
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0.8)],
                        ).createShader(bounds),
                        child: const Text(
                          'Falsisters POS',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Modern Point of Sale System',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Glassmorphism login card
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.15),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 0,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: LoginForm(
                              nameController: nameController,
                              accessKeyController: accessKeyController,
                              isLoading: authState.value!.isLoading,
                              errorText: authState.value?.error,
                              onSubmit: (name, accessKey) async {
                                if (name.isNotEmpty && accessKey.isNotEmpty) {
                                  await ref.read(authProvider.notifier).login(
                                        name,
                                        accessKey,
                                      );
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Footer text
                      Text(
                        '© 2024 Falsisters. All rights reserved.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingElement(Size size, int index) {
    final double size1 = 20 + (index % 3) * 30;
    final bool isCircle = index % 2 == 0;

    return AnimatedBuilder(
      animation: Listenable.merge([_floatingAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Positioned(
          left: (size.width * 0.1) + (index % 4) * (size.width * 0.2),
          top: (size.height * 0.1) +
              (index % 3) * (size.height * 0.25) +
              _floatingAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value + (index * 0.5),
            child: Container(
              width: size1,
              height: size1,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isCircle ? null : BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
