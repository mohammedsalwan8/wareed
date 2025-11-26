import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedBloodType; String? _selectedCity; String? _selectedArea; bool _isLoading = false;
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  // (انسخ قوائم المحافظات Ar, En, Ku من register_screen وضعها هنا تماماً لتظهر في التعديل)
  final Map<String, List<String>> _iraqCitiesAr = {'بغداد': ['الكرادة', 'المنصور', 'الأعظمية', 'الدورة', 'الكاظمية', 'زيونة', 'اليرموك', 'البياع', 'مدينة الصدر', 'الشعب', 'الزعفرانية', 'التاجي', 'أبو غريب', 'المحمودية'], 'أربيل': ['مركز المدينة', 'عينكاوا', 'بختياري', 'سوران', 'شقلاوة', 'كويه (كويسنجق)', 'خبات', 'راوندوز', 'ميركسور'], 'البصرة': ['مركز البصرة', 'العشار', 'القرنة', 'الزبير', 'الفاو', 'أبو الخصيب', 'شط العرب', 'المدينة'], 'نينوى': ['الموصل', 'تلعفر', 'الحمدانية', 'سنجار', 'الشيخان', 'مخمور', 'تلكيف', 'الحضر', 'بعشيقة'], 'السليمانية': ['مركز السليمانية', 'رانية', 'دوكان', 'كلار', 'حلبجة', 'بنجوين', 'دربندخان', 'جمجمال'], 'دهوك': ['مركز دهوك', 'زاخو', 'العمادية', 'سميل', 'شيخان', 'عقرة'], 'كركوك': ['مركز كركوك', 'الحويجة', 'دقوق', 'دبس'], 'الأنبار': ['الرمادي', 'الفلوجة', 'هيت', 'القائم', 'الرطبة', 'حديثة', 'الخالدية', 'عنة'], 'ديالى': ['بعقوبة', 'الخالص', 'المقدادية', 'بلدروز', 'خانقين', 'كفري'], 'صلاح الدين': ['تكريت', 'سامراء', 'بيجي', 'بلد', 'الدجيل', 'طوزخورماتو', 'الشرقاط'], 'بابل': ['الحلة', 'المحاويل', 'المسيب', 'الهاشمية', 'القاسم'], 'كربلاء': ['مركز كربلاء', 'الهندية', 'عين التمر', 'الحر'], 'النجف': ['مركز النجف', 'الكوفة', 'المناذرة', 'المشخاب'], 'واسط': ['الكوت', 'الحي', 'الصويرة', 'النعمانية', 'العزيزية', 'بدرة'], 'القادسية': ['الديوانية', 'عفك', 'الشامية', 'الحمزة'], 'ميسان': ['العمارة', 'المجر الكبير', 'علي الغربي', 'الكحلاء', 'الميمونة'], 'ذي قار': ['الناصرية', 'سوق الشيوخ', 'الشطرة', 'الرفاعي', 'الجبايش'], 'المثنى': ['السماوة', 'الرميثة', 'الخضر', 'الوركاء']};
  final Map<String, List<String>> _iraqCitiesEn = {'Baghdad': ['Karrada', 'Mansour', 'Adhamiya', 'Dora', 'Kadhimiya', 'Zayuna', 'Yarmouk', 'Bayaa', 'Sadr City', 'Shaab', 'Zafraniya', 'Taji', 'Abu Ghraib', 'Mahmoudiya'], 'Erbil': ['City Center', 'Ainkawa', 'Bakhtyari', 'Soran', 'Shaqlawa', 'Koya', 'Khabat', 'Rawanduz', 'Meragasur'], 'Basra': ['Basra Center', 'Ashar', 'Qurna', 'Zubair', 'Fao', 'Abu Al-Khaseeb', 'Shatt Al-Arab', 'Al-Madina'], 'Nineveh': ['Mosul', 'Tal Afar', 'Hamdaniya', 'Sinjar', 'Sheikhan', 'Makhmur', 'Tel Kaif', 'Hatra', 'Bashiqa'], 'Sulaymaniyah': ['Sulaymaniyah Center', 'Ranya', 'Dukan', 'Kalar', 'Halabja', 'Penjwen', 'Darbandikhan', 'Chamchamal'], 'Duhok': ['Duhok Center', 'Zakho', 'Amadiya', 'Sumel', 'Sheikhan', 'Aqrah'], 'Kirkuk': ['Kirkuk Center', 'Hawija', 'Daquq', 'Dibis'], 'Anbar': ['Ramadi', 'Fallujah', 'Hit', 'Al-Qaim', 'Rutba', 'Haditha', 'Khalidiya', 'Ana'], 'Diyala': ['Baqubah', 'Khalis', 'Muqdadiya', 'Balad Ruz', 'Khanaqin', 'Kifri'], 'Saladin': ['Tikrit', 'Samarra', 'Baiji', 'Balad', 'Dujail', 'Tuz Khurmatu', 'Shirqat'], 'Babylon': ['Hilla', 'Mahawil', 'Musayyib', 'Hashimiya', 'Qasim'], 'Karbala': ['Karbala Center', 'Hindiya', 'Ain Al-Tamur', 'Al-Hur'], 'Najaf': ['Najaf Center', 'Kufa', 'Manathera', 'Mishkhab'], 'Wasit': ['Kut', 'Hai', 'Suwaira', 'Numaniya', 'Aziziya', 'Badra'], 'Qadisiyah': ['Diwaniyah', 'Afak', 'Shamiya', 'Hamza'], 'Maysan': ['Amara', 'Majarr Al-Kabir', 'Ali Al-Gharbi', 'Kahla', 'Maimouna'], 'Dhi Qar': ['Nasiriyah', 'Suq Al-Shoyokh', 'Shatra', 'Rifa\'i', 'Chibayish'], 'Muthanna': ['Samawah', 'Rumaitha', 'Khidhir', 'Warka']};
  final Map<String, List<String>> _iraqCitiesKu = {'بەغدا': ['کەرادە', 'مەنسوور', 'ئەعزەمیە', 'دۆرە', 'کازمیە', 'زەیونە', 'یەرموک', 'بەیع', 'شاری سەدر', 'شەعب', 'زەعفەرانیە', 'تاجی', 'ئەبوغرێب', 'مەحموودیە'], 'هەولێر': ['ناوەندی شار', 'عەنکاوە', 'بەختیاری', 'سۆران', 'شەقڵاوە', 'کۆیە', 'خەبات', 'ڕەواندوز', 'مێرگەسۆر'], 'بەسرە': ['ناوەندی بەسرە', 'عەشار', 'قوڕنە', 'زوبێر', 'فاو', 'ئەبو خەسیب', 'شەت ئەلعەرەب', 'مەدینە'], 'نەینەوا': ['موسڵ', 'تەلەعفەر', 'حەمدانیە', 'شنگال', 'شێخان', 'مەخموور', 'تەلکێف', 'حەزەر', 'بەعشیقە'], 'سلێمانی': ['ناوەندی سلێمانی', 'ڕانیە', 'دوکان', 'کەلار', 'هەڵەبجە', 'پێنجوێن', 'دەربەندیخان', 'چەمچەماڵ'], 'دهۆک': ['ناوەندی دهۆک', 'زاخۆ', 'ئامێدی', 'سێمێل', 'شێخان', 'ئاکرێ'], 'کەرکووک': ['ناوەندی کەرکووک', 'حەویجە', 'داقووق', 'دوبز'], 'ئەنبار': ['ڕەمادی', 'فەلووجە', 'هیت', 'قائیم', 'ڕوتبە', 'حەدیسە', 'خالیدیە', 'عانە'], 'دیالە': ['بەعقووبە', 'خاڵس', 'میقدادیە', 'بەلەدڕووز', 'خانەقین', 'کفری'], 'سەڵاحەدین': ['تەکریت', 'سامەڕا', 'بێجی', 'بەلەد', 'دوجەیل', 'تووزخورماتوو', 'شەرگات'], 'بابل': ['حیللە', 'مەحاوێل', 'موسەییب', 'هاشمیە', 'قاسم'], 'کەربەلا': ['ناوەندی کەربەلا', 'هیندیە', 'عەین تەمەر', 'حوڕ'], 'نەجەف': ['ناوەندی نەجەف', 'کوفە', 'مەنازیرە', 'میشخاب'], 'واست': ['کوت', 'حەی', 'سوەیرە', 'نیعمانیە', 'عەزیزیە', 'بەدرە'], 'قادسیە': ['دیوانیە', 'عەفەک', 'شامیە', 'حەمزە'], 'میسان': ['عەمارە', 'مەجەڕی کەبیر', 'عەلی غەربی', 'کەحلا', 'مەیموونە'], 'زیقار': ['ناسیریە', 'سووق شیوخ', 'شەترە', 'ڕیفاعی', 'چەباییش'], 'موسەننا': ['سەماوە', 'ڕومەیسە', 'خزر', 'وەرکا']};

  Map<String, List<String>> _getCurrentCitiesMap() {
    final locale = context.locale.languageCode;
    if (locale == 'ku') return _iraqCitiesKu;
    if (locale == 'en') return _iraqCitiesEn;
    return _iraqCitiesAr;
  }

  @override
  void initState() { super.initState(); _loadUserData(); }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final data = await Supabase.instance.client.from('profiles').select().eq('id', user.id).single();
      setState(() { _nameController.text = data['full_name'] ?? ""; _phoneController.text = data['phone_number'] ?? ""; _selectedBloodType = data['blood_type']; _selectedCity = data['city']; _selectedArea = data['area']; });
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.from('profiles').update({
          'full_name': _nameController.text.trim(), 'phone_number': _phoneController.text.trim(),
          'blood_type': _selectedBloodType, 'city': _selectedCity, 'area': _selectedArea,
        }).eq('id', user.id);
        if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr("success_update")), backgroundColor: Colors.green)); Navigator.pop(context, true); }
      }
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("حدث خطأ"), backgroundColor: Colors.red)); }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final citiesMap = _getCurrentCitiesMap();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: Text(tr("edit_profile"), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black)), centerTitle: true, backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [_buildTextField(_nameController, "full_name", Icons.person), const SizedBox(height: 15), _buildTextField(_phoneController, "phone_label", Icons.phone, isNumber: true), const SizedBox(height: 15), _buildDropdown("blood_type_hint", _selectedBloodType, _bloodTypes, Icons.bloodtype, (val) => setState(() => _selectedBloodType = val)), const SizedBox(height: 15), _buildDropdown("city_hint", _selectedCity, citiesMap.keys.toList(), Icons.location_city, (val) => setState(() { _selectedCity = val; _selectedArea = null; })), const SizedBox(height: 15), _buildDropdown("area_hint", _selectedArea, _selectedCity == null ? [] : (citiesMap[_selectedCity] ?? []), Icons.map, (val) => setState(() => _selectedArea = val), isEnabled: _selectedCity != null), const SizedBox(height: 40), SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE63946), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: _isLoading ? null : _updateProfile, child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(tr("save_changes"), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.cairo().fontFamily, color: Colors.white))))])),
    );
  }
  Widget _buildTextField(TextEditingController controller, String labelKey, IconData icon, {bool isNumber = false}) { return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]), child: TextField(controller: controller, keyboardType: isNumber ? TextInputType.phone : TextInputType.text, decoration: InputDecoration(labelText: tr(labelKey), prefixIcon: Icon(icon, color: const Color(0xFFE63946)), border: InputBorder.none, contentPadding: const EdgeInsets.all(20)))); }
  Widget _buildDropdown(String hintKey, String? value, List<String> items, IconData icon, Function(String?) onChanged, {bool isEnabled = true}) { return Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), decoration: BoxDecoration(color: isEnabled ? Colors.white : Colors.grey[200], borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, hint: Row(children: [Icon(icon, color: isEnabled ? const Color(0xFFE63946) : Colors.grey), const SizedBox(width: 10), Text(tr(hintKey))]), isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: isEnabled ? onChanged : null, icon: Icon(Icons.arrow_drop_down, color: isEnabled ? Colors.black : Colors.grey)))); }
}