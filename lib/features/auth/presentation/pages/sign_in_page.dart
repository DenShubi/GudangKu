import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../main_screen.dart';
import '../providers/auth_provider.dart';

// [PENTING] Import Shared Components
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isSignIn = true; // True = Sign In, False = Sign Up

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              
              // 1. Logo
              Center(
                child: Image.asset(
                  'assets/images/logo_box.png',
                  width: 50,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),

              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isSignIn = true),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isSignIn ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _isSignIn ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                          ),
                          child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isSignIn = false),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !_isSignIn ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: !_isSignIn ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                          ),
                          child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              
              // Input Nama (Hanya muncul jika Sign Up)
              if (!_isSignIn)
                CustomTextField(
                  label: "Nama",
                  hint: "Nama Lengkap",
                  controller: _nameController,
                ),

              // Input Email
              CustomTextField(
                label: "Email",
                hint: "Contoh: user@email.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              // Input Password (Pakai CustomTextField dengan obscureText)
              CustomTextField(
                label: "Password",
                hint: "********",
                controller: _passwordController,
                obscureText: true, // Fitur rahasia aktif
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: _isSignIn ? "Sign In" : "Sign Up",
                isLoading: isLoading,
                onPressed: () async {
                  // Validasi
                  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email & Password are required")));
                    return;
                  }
                  if (!_isSignIn && _nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name is required")));
                    return;
                  }

                  final authProvider = Provider.of<AuthProvider>(context, listen: false);

                  bool success = await authProvider.authenticate(
                    _emailController.text,
                    _passwordController.text,
                    _nameController.text,
                    _isSignIn,
                  );

                  if (success && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(authProvider.errorMessage ?? "Failed")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}