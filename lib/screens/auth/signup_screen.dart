import 'package:flutter/material.dart';

import '../../widgets/labeled_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // Errors stay hidden until the user taps Sign Up for the first time.
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'Please enter your $label';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  bool get _isFormValid =>
      _validateRequired(_firstNameController.text, 'first name') == null &&
      _validateRequired(_lastNameController.text, 'last name') == null &&
      _validateEmail(_emailController.text) == null &&
      _validatePassword(_passwordController.text) == null &&
      _validateConfirm(_confirmPasswordController.text) == null;

  String get _passwordStrength {
    final p = _passwordController.text;
    if (p.isEmpty) return 'None';
    var score = 0;
    if (p.length >= 8) score++;
    if (RegExp(r'[a-z]').hasMatch(p) && RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'\d').hasMatch(p)) score++;
    if (RegExp(r'[^\w\s]').hasMatch(p)) score++;
    if (score <= 1) return 'Weak';
    if (score <= 3) return 'Medium';
    return 'Strong';
  }

  Color get _strengthColor {
    switch (_passwordStrength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  Future<void> _submitSignup() async {
    if (!_formKey.currentState!.validate()) {
      // After the first attempt, errors update live as the user fixes fields.
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed up successfully'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                onChanged: () => setState(() {}), // refresh strength + button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // First name / Last name row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: 'First name',
                            hint: 'First name',
                            controller: _firstNameController,
                            validator: (v) => _validateRequired(v, 'first name'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LabeledTextField(
                            label: 'Last name',
                            hint: 'Last name',
                            controller: _lastNameController,
                            validator: (v) => _validateRequired(v, 'last name'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Email
                    LabeledTextField(
                      label: 'Email address',
                      hint: 'yours@gmail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    LabeledTextField(
                      label: 'Enter your password',
                      hint: 'Min 8 characters',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF64748B),
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Password strength
                    Text.rich(
                      TextSpan(
                        text: 'Password strength: ',
                        children: [
                          TextSpan(
                            text: _passwordStrength,
                            style: TextStyle(color: _strengthColor),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 24),

                    // Confirm password
                    LabeledTextField(
                      label: 'Confirm password',
                      hint: 'Re-enter your password',
                      controller: _confirmPasswordController,
                      obscureText: _obscurePassword,
                      validator: _validateConfirm,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),

                    // Sign Up button
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitSignup,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          // Light blue while the form is incomplete, but still tappable
                          backgroundColor: _isFormValid
                              ? const Color(0xFF2F8FE8)
                              : const Color(0xFF8EC3EE),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF8EC3EE),
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Link to login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text('Log in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}