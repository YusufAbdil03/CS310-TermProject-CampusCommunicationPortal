import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_spacing.dart';
import '../utils/user_profile_state.dart';
import '../utils/validation_utils.dart';
import '../widgets/bottom_nav_placeholder.dart';
import '../widgets/profile_avatar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Step 3: GlobalKey to control and validate the Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables to store form values via onSaved
  String _fullName = '';
  String _email = '';

  // Used to pass the password value into confirmPassword validator
  final TextEditingController _passwordController = TextEditingController();

  // Controls visibility toggles
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // Step 3: Called when Create Account button is pressed
  void _onCreateAccountPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Step 3: Show AlertDialog on success
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account Created!'),
          content: Text(
            'Welcome, $_fullName!\nRegistered email: $_email',
          ),
          actions: [
            TextButton(
              onPressed: () {
                UserProfileState.setInitialFromFullName(_fullName);
                Navigator.pop(context); // close dialog
                // Navigate to home screen (placeholder)
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Get Started'),
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

      // Step 3: AppBar with back arrow
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
            Text('Create Account', style: AppTextStyles.pageTitle),
            AppSpacing.small,
            Text(
              'Sign up for your campus life hub',
              style: AppTextStyles.subtitle,
            ),

            const SizedBox(height: 20),

            // Step 3: Form widget wrapping all input fields
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- Full Name Field ---
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Full Name',
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
                    validator: ValidationUtils.validateFullName,
                    onSaved: (value) => _fullName = value ?? '',
                  ),

                  AppSpacing.medium,

                  // --- School Email Field ---
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'School Email\nname@sabanciuniv.edu',
                      hintStyle: const TextStyle(height: 1.15),
                      prefixIcon: const Icon(Icons.email_outlined,
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
                    validator: ValidationUtils.validateEmail,
                    onSaved: (value) => _email = value ?? '',
                  ),

                  AppSpacing.medium,

                  // --- Password Field ---
                  TextFormField(
                    controller: _passwordController, // needed for confirm match
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.primary),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
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
                    validator: ValidationUtils.validatePassword,
                  ),

                  AppSpacing.medium,

                  // --- Confirm Password Field ---
                  TextFormField(
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.primary),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.subtitle,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
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
                    // Step 3: Confirm password must match the password field
                    validator: (value) => ValidationUtils.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Create Account Button ---
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _onCreateAccountPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Create Account', style: AppTextStyles.buttonLabel),
              ),
            ),

            AppSpacing.medium,

            // --- Already have an account link ---
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: AppTextStyles.body),
                  GestureDetector(
                    // Step 3: Named route navigation back to login
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Text('Login', style: AppTextStyles.link),
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
