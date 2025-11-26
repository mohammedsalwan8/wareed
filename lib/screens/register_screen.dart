import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  String? _selectedBloodType;
  String? _selectedCity;
  String? _selectedArea;
  String? _selectedGender; 
  bool _isLoading = false;

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> _genders = ['Male', 'Female']; 

  // قوائم المحافظات الكاملة (AR, EN, KU)
  final Map<String, List<String>> _iraqCitiesAr = {'بغداد': ['الكرادة', 'المنصور', 'الأعظمية', 'الدورة', 'الكاظمية', 'زيونة', 'اليرموك', 'البياع', 'مدينة الصدر', 'الشعب', 'الزعفرانية', 'التاجي', 'أبو غريب', 'المحمودية'], 'أربيل': ['مركز المدينة', 'عينكاوا', 'بختياري', 'سوران', 'شقلاوة', 'كويه (كويسنجق)', 'خبات', 'راوندوز', 'ميركسور'], 'البصرة': ['مركز البصرة', 'العشار', 'القرنة', 'الزبير', 'الفاو', 'أبو الخصيب', 'شط العرب', 'المدينة'], 'نينوى': ['الموصل', 'تلعفر', 'الحمدانية', 'سنجار', 'الشيخان', 'مخمور', 'تلكيف', 'الحضر', 'بعشيقة'], 'السليمانية': ['مركز السليمانية', 'رانية', 'دوكان', 'كلار', 'حلبجة', 'بنجوين', 'دربندخان', 'جمجمال'], 'دهوك': ['مركز دهوك', 'زاخو', 'العمادية', 'سميل', 'شيخان', 'عقرة'], 'كركوك': ['مركز كركوك', 'الحويجة', 'دقوق', 'دبس'], 'الأنبار': ['الرمادي', 'الفلوجة', 'هيت', 'القائم', 'الرطبة', 'حديثة', 'الخالدية', 'عنة'], 'ديالى': ['بعقوبة', 'الخالص', 'المقدادية', 'بلدروز', 'خانقين', 'كفري'], 'صلاح الدين': ['تكريت', 'سامراء', 'بيجي', 'بلد', 'الدجيل', 'طوزخورماتو', 'الشرقاط'], 'بابل': ['الحلة', 'المحاويل', 'المسيب', 'الهاشمية', 'القاسم'], 'كربلاء': ['مركز كربلاء', 'الهندية', 'عين التمر', 'الحر'], 'النجف': ['مركز النجف', 'الكوفة', 'المناذرة', 'المشخاب'], 'واسط': ['الكوت', 'الحي', 'الصويرة', 'النعمانية', 'العزيزية', 'بدرة'], 'القادسية': ['الديوانية', 'عفك', 'الشامية', 'الحمزة'], 'ميسان': ['العمارة', 'المجر الكبير', 'علي الغربي', 'الكحلاء', 'الميمونة'], 'ذي قار': ['الناصرية', 'سوق الشيوخ', 'الشطرة', 'الرفاعي', 'الجبايش'], 'المثنى': ['السماوة', 'الرميثة', 'الخضر', 'الوركاء']};
  final Map<String, List<String>> _iraqCitiesEn = {'Baghdad': ['Karrada', 'Mansour', 'Adhamiya', 'Dora', 'Kadhimiya', 'Zayuna', 'Yarmouk', 'Bayaa', 'Sadr City', 'Shaab', 'Zafraniya', 'Taji', 'Abu Ghraib', 'Mahmoudiya'], 'Erbil': ['City Center', 'Ainkawa', 'Bakhtyari', 'Soran', 'Shaqlawa', 'Koya', 'Khabat', 'Rawanduz', 'Meragasur'], 'Basra': ['Basra Center', 'Ashar', 'Qurna', 'Zubair', 'Fao', 'Abu Al-Khaseeb', 'Shatt Al-Arab', 'Al-Madina'], 'Nineveh': ['Mosul', 'Tal Afar', 'Hamdaniya', 'Sinjar', 'Sheikhan', 'Makhmur', 'Tel Kaif', 'Hatra', 'Bashiqa'], 'Sulaymaniyah': ['Sulaymaniyah Center', 'Ranya', 'Dukan', 'Kalar', 'Halabja', 'Penjwen', 'Darbandikhan', 'Chamchamal'], 'Duhok': ['Duhok Center', 'Zakho', 'Amadiya', 'Sumel', 'Sheikhan', 'Aqrah'], 'Kirkuk': ['Kirkuk Center', 'Hawija', 'Daquq', 'Dibis'], 'Anbar': ['Ramadi', 'Fallujah', 'Hit', 'Al-Qaim', 'Rutba', 'Haditha', 'Khalidiya', 'Ana'], 'Diyala': ['Baqubah', 'Khalis', 'Muqdadiya', 'Balad Ruz', 'Khanaqin', 'Kifri'], 'Saladin': ['Tikrit', 'Samarra', 'Baiji', 'Balad', 'Dujail', 'Tuz Khurmatu', 'Shirqat'], 'Babylon': ['Hilla', 'Mahawil', 'Musayyib', 'Hashimiya', 'Qasim'], 'Karbala': ['Karbala Center', 'Hindiya', 'Ain Al-Tamur', 'Al-Hur'], 'Najaf': ['Najaf Center', 'Kufa', 'Manathera', 'Mishkhab'], 'Wasit': ['Kut', 'Hai', 'Suwaira', 'Numaniya', 'Aziziya', 'Badra'], 'Qadisiyah': ['Diwaniyah', 'Afak', 'Shamiya', 'Hamza'], 'Maysan': ['Amara', 'Majarr Al-Kabir', 'Ali Al-Gharbi', 'Kahla', 'Maimouna'], 'Dhi Qar': ['Nasiriyah', 'Suq Al-Shoyokh', 'Shatra', 'Rifa\'i', 'Chibayish'], 'Muthanna': ['Samawah', 'Rumaitha', 'Khidhir', 'Warka']};
  final Map<String, List<String>> _iraqCitiesKu = {'بەغدا': ['کەرادە', 'مەنسوور', 'ئەعزەمیە', 'دۆرە', 'کازمیە', 'زەیونە', 'یەرموک', 'بەیع', 'شاری سەدر', 'شەعب', 'زەعفەرانیە', 'تاجی', 'ئەبوغرێب', 'مەحموودیە'], 'هەولێر': ['ناوەندی شار', 'عەنکاوە', 'بەختیاری', 'سۆران', 'شەقڵاوە', 'کۆیە', 'خەبات', 'ڕەواندوز', 'مێرگەسۆر'], 'بەسرە': ['ناوەندی بەسرە', 'عەشار', 'قوڕنە', 'زوبێر', 'فاو', 'ئەبو خەسیب', 'شەت ئەلعەرەب', 'مەدینە'], 'نەینەوا': ['موسڵ', 'تەلەعفەر', 'حەمدانیە', 'شنگال', 'شێخان', 'مەخموور', 'تەلکێف', 'حەزەر', 'بەعشیقە'], 'سلێمانی': ['ناوەندی سلێمانی', 'ڕانیە', 'دوکان', 'کەلار', 'هەڵەبجە', 'پێنجوێن', 'دەربەندیخان', 'چەمچەماڵ'], 'دهۆک': ['ناوەندی دهۆک', 'زاخۆ', 'ئامێدی', 'سێمێل', 'شێخان', 'ئاکرێ'], 'کەرکووک': ['ناوەندی کەرکووک', 'حەویجە', 'داقووق', 'دوبز'], 'ئەنبار': ['ڕەمادی', 'فەلووجە', 'هیت', 'قائیم', 'ڕوتبە', 'حەدیسە', 'خالیدیە', 'عانە'], 'دیالە': ['بەعقووبە', 'خاڵس', 'میقدادیە', 'بەلەدڕووز', 'خانەقین', 'کفری'], 'سەڵاحەدین': ['تەکریت', 'سامەڕا', 'بێجی', 'بەلەد', 'دوجەیل', 'تووزخورماتوو', 'شەرگات'], 'بابل': ['حیللە', 'مەحاوێل', 'موسەییب', 'هاشمیە', 'قاسم'], 'کەربەلا': ['ناوەندی کەربەلا', 'هیندیە', 'عەین تەمەر', 'حوڕ'], 'نەجەف': ['ناوەندی نەجەف', 'کوفە', 'مەنازیرە', 'میشخاب'], 'واست': ['کوت', 'حەی', 'سوەیرە', 'نیعمانیە', 'عەزیزیە', 'بەدرە'], 'قادسیە': ['دیوانیە', 'عەفەک', 'شامیە', 'حەمزە'], 'میسان': ['عەمارە', 'مەجەڕی کەبیر', 'عەلی غەربی', 'کەحلا', 'مەیموونە'], 'زیقار': ['ناسیریە', 'سووق شیوخ', 'شەترە', 'ڕیفاعی', 'چەباییش'], 'موسەننا': ['سەماوە', 'ڕومەیسە', 'خزر', 'وەرکا']};

  Map<String, List<String>> _getCurrentCitiesMap() {
    final locale = context.locale.languageCode;
    if (locale == 'ku') return _iraqCitiesKu;
    if (locale == 'en') return _iraqCitiesEn;
    return _iraqCitiesAr;
  }

  Future<void> _signUp() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى ملء جميع الحقول"), backgroundColor: Colors.orange));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final fakeEmail = "${_phoneController.text.trim()}@wareed.app";
      final AuthResponse res = await Supabase.instance.client.auth.signUp(email: fakeEmail, password: _passwordController.text.trim());
      if (res.user != null) {
        await Supabase.instance.client.from('profiles').upsert({
          'id': res.user!.id, 'full_name': _nameController.text.trim(), 'phone_number': _phoneController.text.trim(),
          'blood_type': _selectedBloodType, 'city': _selectedCity, 'area': _selectedArea, 'gender': _selectedGender, 'is_available': true
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("success_register").tr(), backgroundColor: Colors.green));
          Navigator.pop(context); 
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error_msg").tr(), backgroundColor: Colors.red));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final citiesMap = _getCurrentCitiesMap();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black), onPressed: () => Navigator.pop(context)), title: Text("register_title", style: TextStyle(color: Colors.black, fontFamily: GoogleFonts.cairo().fontFamily, fontWeight: FontWeight.bold)).tr(), centerTitle: true),
      body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24.0), child: Column(children: [
        _buildTextField(controller: _nameController, labelKey: "full_name", icon: Icons.person), const SizedBox(height: 15),
        _buildDropdown(hintKey: "gender_hint", value: _selectedGender, items: _genders, displayItem: (item) => item == 'Male' ? tr("male") : tr("female"), icon: Icons.wc, onChanged: (val) => setState(() => _selectedGender = val)), const SizedBox(height: 15),
        _buildTextField(controller: _phoneController, labelKey: "phone_label", icon: Icons.phone_android_rounded, isNumber: true), const SizedBox(height: 15),
        _buildDropdown(hintKey: "blood_type_hint", value: _selectedBloodType, items: _bloodTypes, icon: Icons.bloodtype, onChanged: (val) => setState(() => _selectedBloodType = val)), const SizedBox(height: 15),
        _buildDropdown(hintKey: "city_hint", value: _selectedCity, items: citiesMap.keys.toList(), icon: Icons.location_city, onChanged: (val) => setState(() { _selectedCity = val; _selectedArea = null; })), const SizedBox(height: 15),
        _buildDropdown(hintKey: "area_hint", value: _selectedArea, items: _selectedCity == null ? [] : (citiesMap[_selectedCity] ?? []), icon: Icons.map, onChanged: (val) => setState(() => _selectedArea = val), isEnabled: _selectedCity != null), const SizedBox(height: 15),
        _buildTextField(controller: _passwordController, labelKey: "password_label", icon: Icons.lock, isPassword: true), const SizedBox(height: 30),
        SizedBox(width: double.infinity, height: 60, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE63946), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: _isLoading ? null : _signUp, child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text("register_btn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.cairo().fontFamily)).tr())),
      ]))),
    );
  }
  Widget _buildTextField({required TextEditingController controller, required String labelKey, required IconData icon, bool isPassword = false, bool isNumber = false}) { return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]), child: TextField(controller: controller, obscureText: isPassword, keyboardType: isNumber ? TextInputType.phone : TextInputType.text, decoration: InputDecoration(labelText: tr(labelKey), prefixIcon: Icon(icon, color: const Color(0xFFE63946)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), filled: true, fillColor: Colors.white))); }
  Widget _buildDropdown({required String hintKey, required String? value, required List<String> items, required IconData icon, required Function(String?) onChanged, String Function(String)? displayItem, bool isEnabled = true}) { return Container(decoration: BoxDecoration(color: isEnabled ? Colors.white : Colors.grey[200], borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, hint: Row(children: [Icon(icon, color: isEnabled ? const Color(0xFFE63946) : Colors.grey), const SizedBox(width: 10), Text(tr(hintKey))]), isExpanded: true, items: items.map((String item) { return DropdownMenuItem<String>(value: item, child: Text(displayItem != null ? displayItem(item) : item)); }).toList(), onChanged: isEnabled ? onChanged : null, icon: Icon(Icons.arrow_drop_down, color: isEnabled ? Colors.black : Colors.grey)))); }
}