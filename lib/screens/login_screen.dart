import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanavue/controllers/auth_controller.dart';
import 'package:tanavue/screens/home_screen.dart';
import '../utils/app_colors.dart'; // Pastikan import ini benar
import '../utils/app_strings.dart'; // Pastikan import ini benar
import '../utils/custom_page_route.dart'; // Untuk FadePageRoute

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _loginUser() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      print('Login attempt with Email: $email, Password: $password');

      // Ganti dengan navigasi yang menggunakan FadePageRoute jika diinginkan
      Navigator.of(context).pushReplacement(
        FadePageRoute(
            page: HomeScreen()), // Ganti Placeholder() dengan HomePage Anda
      );
      // atau Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background, // Misal: Colors.white
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    48), // Kurangi padding vertikal SafeArea
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenHeight * 0.01),
                    Center(
                      child: Image.asset(
                        'assets/images/logo_tanavue.png',
                        width: 180, // Sedikit diperbesar agar sesuai desain
                        height: 180,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.eco,
                              size: 80, color: AppColors.primary);
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppStrings.login, // "Masuk Akun"
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary // Warna teks utama
                                ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppStrings.message, // "Memasukkan Email..."
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium // Menggunakan bodyMedium agar lebih pas
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Username", // Sesuai desain
                        hintText:
                            AppStrings.hintEmail, // Bisa diubah ke hintUsername
                        prefixIcon:
                            const Icon(Icons.person_outline, // Icon username
                                color: AppColors.iconColor),
                        border: OutlineInputBorder(
                          // Ini untuk border default
                          borderRadius:
                              BorderRadius.circular(25.0), // <-- BorderRadius
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          // Border saat tidak aktif
                          borderRadius:
                              BorderRadius.circular(25.0), // <-- BorderRadius
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // Border saat aktif
                          borderRadius:
                              BorderRadius.circular(25.0), // <-- BorderRadius
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                      ),
                      keyboardType: TextInputType.text, // Untuk username
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan Username Anda'; // Disesuaikan
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: AppStrings.password,
                        hintText: AppStrings.hintPassword,
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.iconColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.iconColor,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // <-- BorderRadius
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // <-- BorderRadius
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // <-- BorderRadius
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan Password Anda'; // Disesuaikan
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter'; // Disesuaikan
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                          text: AppStrings.forgotPassword,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                          children: <TextSpan>[
                            TextSpan(
                              text: " ${AppStrings.forgotButton}",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Ganti Password Tapped');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // <-- BorderRadius
                        ),
                        elevation: 2,
                      ),
                      child: const Text('Masuk'), // Sesuai desain
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: AppStrings.dontHaveAccount,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                          children: <TextSpan>[
                            TextSpan(
                              text: AppStrings.signUpLink,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed('/signup');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 0.8,
                            endIndent: 10,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "atau",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 0.8,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Google Login Tapped');
                      },
                      icon: Image.asset(
                        'assets/images/logo_google.png', // Pastikan aset ini ada
                        height: 20.0, // Ukuran ikon disesuaikan
                        width: 20.0,
                      ),
                      label: Text(AppStrings.googleLogin),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                          foregroundColor:
                              AppColors.textPrimary, // Warna teks lebih gelap
                          elevation: 1,
                          side:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25.0), // <-- BorderRadius
                          ),
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 20),
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
