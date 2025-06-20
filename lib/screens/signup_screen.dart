import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // Corrected import
import '../utils/app_strings.dart'; // Corrected import

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _signUpUser() {
    if (_formKey.currentState!.validate()) {
      // Process sign up
      String fullName = _fullNameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      print(
          'SignUp attempt with Full Name: $fullName, Email: $email, Password: $password');

      // Simulate signup success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.signupSuccess)),
      );
      // Navigate to login or home after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      // If signup fails:
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text(AppStrings.signupFailed)),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey, // Pastikan _formKey didefinisikan
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start, // Dihapus agar Center bekerja
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
                    const SizedBox(height: 20), // Margin

                    // --- JUDUL RATA TENGAH ---
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppStrings.createAccount, // "Masuk Akun"
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
                        AppStrings.signUpMessage, // "Memasukkan Email..."
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium // Menggunakan bodyMedium agar lebih pas
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    // -------------------------

                    const SizedBox(height: 30), // Margin lebih besar

                    // --- TEXTFORMFIELD DENGAN BORDER ROUNDED ---
                    TextFormField(
                      controller:
                          _fullNameController, // Pastikan _fullNameController didefinisikan
                      decoration: InputDecoration(
                        // Terapkan style baru
                        labelText: AppStrings.fullName,
                        hintText: AppStrings.hintFullName,
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColors.iconColor),
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
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {/* ... validator Anda ... */},
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller:
                          _emailController, // Pastikan _emailController didefinisikan
                      decoration: InputDecoration(
                        // Terapkan style baru
                        labelText: AppStrings.email,
                        hintText: AppStrings.hintEmail,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.iconColor),
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
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {/* ... validator Anda ... */},
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller:
                          _passwordController, // Pastikan _passwordController didefinisikan
                      decoration: InputDecoration(
                        // Terapkan style baru
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
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      obscureText:
                          _obscurePassword, // Pastikan _obscurePassword didefinisikan
                      validator: (value) {/* ... validator Anda ... */},
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller:
                          _confirmPasswordController, // Pastikan _confirmPasswordController didefinisikan
                      decoration: InputDecoration(
                        // Terapkan style baru
                        labelText: AppStrings.confirmPassword,
                        hintText: AppStrings.hintConfirmPassword,
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
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      obscureText:
                          _obscureConfirmPassword, // Pastikan _obscureConfirmPassword didefinisikan
                      validator: (value) {/* ... validator Anda ... */},
                    ),
                    // --- AKHIR TEXTFORMFIELD ---

                    const SizedBox(
                        height: 30), // Margin lebih besar sebelum tombol

                    // --- TOMBOL DAFTAR DENGAN STYLE BARU ---
                    ElevatedButton(
                      onPressed:
                          _signUpUser, // Pastikan _signUpUser didefinisikan
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: AppColors.primary, // Warna hijau
                          foregroundColor: Colors.white, // Teks putih
                          shape: RoundedRectangleBorder(
                            // Bentuk rounded
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      child: const Text(AppStrings.signUp),
                    ),
                    // --- AKHIR TOMBOL DAFTAR ---

                    const Spacer(), // <-- Gunakan Spacer untuk mendorong link ke bawah ATAU ganti dengan SizedBox

                    // --- LINK LOGIN RATA TENGAH ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                      child: Center(
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
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .pop(); // Kembali ke login
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Separator "atau"
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                            endIndent: 10,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "atau", // CATATAN: 'atau' tidak ada di AppStrings
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Tombol Google
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Google Login Tapped');
                      },
                      icon: Image.asset(
                        'assets/images/logo_google.png', // Pastikan aset ini ada
                        height: 20.0, // Ukuran ikon disesuaikan
                        width: 20.0,
                      ),
                      label: Text(AppStrings.googleSignUp),
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
                    const SizedBox(height: 20), // Padding bawah
                    // --- AKHIR LINK LOGIN ---
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
