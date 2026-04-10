import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_spacing.dart';
import '../utils/validation_utils.dart';
import '../widgets/bottom_nav_placeholder.dart';
import '../widgets/profile_avatar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Step 3: GlobalKey to control and validate the Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables to store form values via onSaved
  String _email = '';

  // Controls whether password text is visible
  bool _obscurePassword = true;

  // Step 3: Called when Login button is pressed
  void _onLoginPressed() {
    // Trigger validation on all TextFormFields
    if (_formKey.currentState!.validate()) {
      // Save all field values
      _formKey.currentState!.save();

      // Step 3: Show AlertDialog on successful validation
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Successful'),
          content: Text('Welcome back, $_email!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                // Navigate to home screen (placeholder)
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // Step 3: AppBar with back arrow and title
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.primary, width: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Student', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: ProfileAvatar(),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.large,

            // --- Title Area ---
            Text('Welcome Back', style: AppTextStyles.pageTitle),
            AppSpacing.small,
            Text(
              'Login to access your campus life hub',
              style: AppTextStyles.subtitle,
            ),

            const SizedBox(height: 20),

            // Step 3: Form widget wrapping all input fields
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- Email Field ---
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'name@sabanciuniv.edu',
                      prefixIcon: const Icon(Icons.person_outline,
                          color: AppColors.primary),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.inputBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    // Step 3: Inline validation
                    validator: ValidationUtils.validateEmail,
                    onSaved: (value) => _email = value ?? '',
                  ),

                  AppSpacing.medium,

                  // --- Password Field ---
                  TextFormField(
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.primary),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      // Toggle password visibility
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.subtitle,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.inputBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    // Step 3: Inline validation
                    validator: ValidationUtils.validatePassword,
                  ),

                  const SizedBox(height: 8),

                  // --- Forgot Password link (aligned right) ---
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Placeholder: no action required by Step 2/3
                        },
                        child: Text('Forgot Password?', style: AppTextStyles.link),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 44),

            // --- Login Button ---
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _onLoginPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Login', style: AppTextStyles.buttonLabel),
              ),
            ),

            AppSpacing.medium,

            // --- Sign Up link at bottom ---
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: AppTextStyles.body),
                  GestureDetector(
                    // Step 3: Named route navigation
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: Text('Sign Up', style: AppTextStyles.link),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // --- Bottom Navigation Bar (visual placeholder only) ---
            const BottomNavPlaceholder(),
          ],
        ),
      ),
    );
  }
}
