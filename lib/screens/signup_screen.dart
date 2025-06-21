import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // --- STATE & CONTROLLERS ---
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _signUpController = SignUpController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---

  Future<void> _signUpUser() async {
    // Hentikan jika form tidak valid
    if (!_formKey.currentState!.validate()) return;

    // Validasi tambahan untuk konfirmasi password
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Konfirmasi password tidak cocok');
      return;
    }

    // Mulai proses loading
    setState(() => _isLoading = true);

    try {
      final user = await _signUpController.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (user != null) {
        // TODO: Simpan nama lengkap ke database/Firestore menggunakan user.uid
        // await ProfileController().saveUserProfile(user.uid, _fullNameController.text.trim());

        _showSuccessSnackBar(AppStrings.signupSuccess);

        // Navigasi setelah jeda singkat
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Gagal mendaftar: ${e.toString()}');
        print(e);
      }
    } finally {
      // Pastikan loading berhenti, apa pun hasilnya
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // --- UI HELPER METHODS ---

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: AppColors.iconColor),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  // --- UI BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildFormFields(),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo_tanavue.png',
          width: 150,
          height: 150,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.eco, size: 80, color: AppColors.primary);
          },
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.createAccount,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.signUpMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _fullNameController,
          decoration: _buildInputDecoration(
            labelText: AppStrings.fullName,
            hintText: AppStrings.hintFullName,
            prefixIcon: Icons.person_outline,
          ),
          keyboardType: TextInputType.name,
          validator: (value) => (value == null || value.isEmpty)
              ? 'Nama lengkap tidak boleh kosong'
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: _buildInputDecoration(
            labelText: AppStrings.email,
            hintText: AppStrings.hintEmail,
            prefixIcon: Icons.email_outlined,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => (value == null || !value.contains('@'))
              ? 'Masukkan email yang valid'
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _buildInputDecoration(
            labelText: AppStrings.password,
            hintText: AppStrings.hintPassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: (value) => (value == null || value.length < 6)
              ? 'Password minimal 6 karakter'
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: _buildInputDecoration(
            labelText: AppStrings.confirmPassword,
            hintText: AppStrings.hintConfirmPassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Harap konfirmasi password';
            if (value != _passwordController.text)
              return 'Password tidak cocok';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: _isLoading ? null : _signUpUser,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 3, color: Colors.white),
                )
              : const Text(AppStrings.signUp),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text("atau", style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed:
              _isLoading ? null : () {/* TODO: Implement Google Sign-In */},
          icon: Image.asset('assets/images/logo_google.png',
              height: 20.0, width: 20.0),
          label: const Text(AppStrings.googleSignUp),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            elevation: 1,
            side: BorderSide(color: Colors.grey.shade300, width: 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: AppStrings.alreadyHaveAccount,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
          children: <TextSpan>[
            TextSpan(
              text: AppStrings.loginLink,
              style: const TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (!_isLoading) {
                    Navigator.of(context).pop();
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}
