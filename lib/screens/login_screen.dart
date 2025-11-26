import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى إدخال البيانات"), backgroundColor: Colors.orange));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final fakeEmail = "${_phoneController.text.trim()}@wareed.app";
      final AuthResponse res = await Supabase.instance.client.auth.signInWithPassword(email: fakeEmail, password: _passwordController.text.trim());
      if (res.user != null && mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (route) => false);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("بيانات الدخول غير صحيحة أو حدث خطأ"), backgroundColor: Colors.red));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black), onPressed: () => Navigator.pop(context))),
      body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24.0), child: Column(children: [
        Image.asset('assets/images/logo.png', height: 100), const SizedBox(height: 20),
        Text("login_title", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFFE63946), fontFamily: GoogleFonts.cairo().fontFamily)).tr(),
        const SizedBox(height: 40),
        _buildTextField(controller: _phoneController, labelKey: "phone_label", icon: Icons.phone_android_rounded, isNumber: true),
        const SizedBox(height: 20),
        _buildTextField(controller: _passwordController, labelKey: "password_hint", icon: Icons.lock_outline, isPassword: true),
        const SizedBox(height: 40),
        SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE63946), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: _isLoading ? null : _login, child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text("login_button", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.cairo().fontFamily)).tr())),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("no_account", style: TextStyle(color: Colors.grey[600], fontFamily: GoogleFonts.cairo().fontFamily)).tr(), const SizedBox(width: 5), GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())), child: Text("register_now", style: TextStyle(color: const Color(0xFFE63946), fontWeight: FontWeight.bold, fontFamily: GoogleFonts.cairo().fontFamily)).tr())]),
      ]))),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelKey, required IconData icon, bool isPassword = false, bool isNumber = false}) {
    return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]), child: TextField(controller: controller, obscureText: isPassword ? _obscurePassword : false, keyboardType: isNumber ? TextInputType.phone : TextInputType.text, decoration: InputDecoration(labelText: tr(labelKey), prefixIcon: Icon(icon, color: const Color(0xFFE63946)), suffixIcon: isPassword ? IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)) : null, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), filled: true, fillColor: Colors.white)));
  }
}