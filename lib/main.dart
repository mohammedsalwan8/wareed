import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lottie/lottie.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fufehwsnpklspqadkrpv.supabase.co',
    anonKey: 'sb_publishable_ey8z9HYorXpf4KIiow_qBQ_VFXWiT2M',
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en'), Locale('ku')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const WareedApp(),
    ),
  );
}

class WareedApp extends StatelessWidget {
  const WareedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wareed',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        ...context.localizationDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate, 
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        if (context.locale.languageCode == 'ku') {
          return Directionality(textDirection: ui.TextDirection.rtl, child: child!);
        }
        return child!;
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.cairo().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE63946), primary: const Color(0xFFE63946)),
        appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0, centerTitle: true, iconTheme: const IconThemeData(color: Colors.black), titleTextStyle: GoogleFonts.cairo(color: const Color(0xFFE63946), fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      home: const SplashScreen(),
    );
  }
}

class DefaultMaterialLocalizations extends LocalizationsDelegate<MaterialLocalizations> {
  const DefaultMaterialLocalizations();
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';
  @override
  Future<MaterialLocalizations> load(Locale locale) async => await GlobalMaterialLocalizations.delegate.load(const Locale('ar'));
  @override
  bool shouldReload(DefaultMaterialLocalizations old) => false;
  static const delegate = DefaultMaterialLocalizations();
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/animations/splash_anim.json',
          width: 300, height: 300, fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.favorite_rounded, color: Color(0xFFE63946), size: 100),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(flexibleSpace: SafeArea(child: Center(child: Directionality(textDirection: ui.TextDirection.ltr, child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset('assets/images/logo.png', height: 45), const SizedBox(width: 10), const Text('وريد', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFFE63946)))]))))),
      body: Padding(padding: const EdgeInsets.all(24.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))]), child: Column(children: [Text('welcome', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center).tr(), const SizedBox(height: 8), Text("choose_language", style: TextStyle(color: Colors.grey[500], fontSize: 14), textAlign: TextAlign.center).tr()])), const SizedBox(height: 30), _buildModernButton(context, "العربية", "🇮🇶", const Locale('ar')), const SizedBox(height: 15), _buildModernButton(context, "کوردی", "🇹🇯", const Locale('ku')), const SizedBox(height: 15), _buildModernButton(context, "English", "🇺🇸", const Locale('en')), const Spacer(), SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE63946), foregroundColor: Colors.white, elevation: 5, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("start_journey", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).tr(), const SizedBox(width: 10), const Icon(Icons.arrow_forward_rounded)]))), const SizedBox(height: 20)])),
    );
  }
  Widget _buildModernButton(BuildContext context, String title, String flag, Locale locale) {
    bool isSelected = context.locale == locale;
    return GestureDetector(onTap: () => context.setLocale(locale), child: AnimatedContainer(duration: const Duration(milliseconds: 250), padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), decoration: BoxDecoration(color: isSelected ? const Color(0xFFE63946) : Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: isSelected ? const Color(0xFFE63946) : Colors.grey.shade200), boxShadow: isSelected ? [BoxShadow(color: const Color(0xFFE63946).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))] : []), child: Row(children: [Text(flag, style: const TextStyle(fontSize: 24)), const SizedBox(width: 15), Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)), const Spacer(), if (isSelected) const Icon(Icons.check_circle_rounded, color: Colors.white)])));
  }
}