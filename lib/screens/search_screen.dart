import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _selectedBloodType;
  String? _selectedCity;
  bool _isLoading = false;
  List<Map<String, dynamic>> _donors = [];
  bool _hasSearched = false;

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> _cities = ['بغداد', 'أربيل', 'البصرة', 'نينوى', 'السليمانية', 'دهوك', 'كركوك', 'الأنبار', 'ديالى', 'صلاح الدين', 'بابل', 'كربلاء', 'النجف', 'واسط', 'القادسية', 'ميسان', 'ذي قار', 'المثنى', 'Baghdad', 'Erbil', 'Basra', 'Sulaymaniyah', 'Mosul', 'Duhok'];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
    else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لا يمكن إجراء الاتصال")));
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    String formattedNumber = phoneNumber;
    if (formattedNumber.startsWith('0')) formattedNumber = '+964${formattedNumber.substring(1)}';
    final Uri whatsappUri = Uri.parse("https://wa.me/$formattedNumber?text=مرحباً، وجدت اسمك في تطبيق وريد للتبرع بالدم 🩸");
    try { await launchUrl(whatsappUri, mode: LaunchMode.externalApplication); } 
    catch (e) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تطبيق واتساب غير مثبت"))); }
  }

  Future<void> _reportUser(Map<String, dynamic> donor) async {
    String? reason;
    final reasons = ["مضايقة / سلوك غير لائق", "الرقم لا يعمل / خطأ", "طلب مقابل مادي للتبرع", "معلومات وهمية", "أخرى"];
    await showDialog(context: context, builder: (context) => AlertDialog(title: const Text("سبب الإبلاغ"), content: SizedBox(width: double.maxFinite, child: ListView.builder(shrinkWrap: true, itemCount: reasons.length, itemBuilder: (context, index) => ListTile(title: Text(reasons[index]), leading: const Icon(Icons.report_problem, color: Colors.orange), onTap: () { reason = reasons[index]; Navigator.pop(context); })))));
    if (reason != null) {
      final String reportMsg = "🚨 *بلاغ جديد*\n👤 ${donor['full_name']}\n📞 ${donor['phone_number']}\n⚠️ $reason";
      final Uri telegramUri = Uri.parse("https://t.me/Wareed_admin?text=${Uri.encodeComponent(reportMsg)}");
      try { await launchUrl(telegramUri, mode: LaunchMode.externalApplication); await Supabase.instance.client.rpc('increment_reports', params: {'user_id': donor['id']}); } catch (e) {}
    }
  }

  Future<void> _secureContact(Map<String, dynamic> donor, Function contactAction) async {
    if (donor['gender'] == 'Female') {
      bool? agreed = await showDialog(context: context, builder: (context) => AlertDialog(icon: const Icon(Icons.gavel_rounded, size: 50, color: Colors.red), title: Text(tr("warning_title"), style: TextStyle(fontFamily: GoogleFonts.cairo().fontFamily, fontWeight: FontWeight.bold)), content: Text(tr("warning_msg_short"), textAlign: TextAlign.center), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr("cancel_call"), style: const TextStyle(color: Colors.grey))), ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), child: Text(tr("i_promise")))]));
      if (agreed == true) contactAction();
    } else { contactAction(); }
  }

  Future<void> _searchDonors() async {
    if (_selectedBloodType == null || _selectedCity == null) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("select_filters_msg").tr(), backgroundColor: Colors.orange)); return; }
    setState(() { _isLoading = true; _donors = []; _hasSearched = true; });
    try {
      final data = await Supabase.instance.client.from('profiles').select().eq('blood_type', _selectedBloodType!).eq('city', _selectedCity!).eq('is_available', true);
      final List<Map<String, dynamic>> filteredDonors = [];
      final now = DateTime.now();
      for (var donor in data) {
        bool isEligible = true;
        if (donor['last_donation_date'] != null) {
          final lastDate = DateTime.parse(donor['last_donation_date']);
          if (now.difference(lastDate).inDays < 90) isEligible = false;
        }
        if (isEligible) filteredDonors.add(donor);
      }
      setState(() => _donors = filteredDonors);
    } catch (e) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: Text(tr("nav_search"), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black)), centerTitle: true, backgroundColor: Colors.transparent, elevation: 0, automaticallyImplyLeading: false),
      body: Padding(padding: const EdgeInsets.all(20.0), child: Column(children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]), child: Column(children: [_buildDropdown(hint: "blood_type_hint", value: _selectedBloodType, items: _bloodTypes, icon: Icons.bloodtype, onChanged: (val) => setState(() => _selectedBloodType = val)), const SizedBox(height: 15), _buildDropdown(hint: "city_hint", value: _selectedCity, items: _cities, icon: Icons.location_city, onChanged: (val) => setState(() => _selectedCity = val)), const SizedBox(height: 20), SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE63946), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: _isLoading ? null : _searchDonors, icon: const Icon(Icons.search), label: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text("search_btn", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)).tr()))])),
        const SizedBox(height: 20),
        Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xFFE63946))) : (_donors.isEmpty) ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_hasSearched ? Icons.sentiment_dissatisfied_rounded : Icons.person_search_rounded, size: 100, color: Colors.grey[300]), const SizedBox(height: 15), Text(_hasSearched ? tr("no_donors_found") : tr("start_search_msg"), textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: GoogleFonts.cairo().fontFamily))])) : ListView.builder(itemCount: _donors.length, itemBuilder: (context, index) => _buildDonorCard(_donors[index]))),
      ])),
    );
  }

  Widget _buildDonorCard(Map<String, dynamic> donor) {
    String displayName = donor['full_name'] ?? "فاعل خير";
    if (donor['gender'] == 'Female') displayName = tr("female_hidden_name");
    return Container(margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))]), child: Stack(children: [Row(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: const Color(0xFFE63946).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(donor['blood_type'] ?? "?", style: const TextStyle(color: Color(0xFFE63946), fontWeight: FontWeight.bold, fontSize: 20)))), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Row(children: [const Icon(Icons.location_on, size: 14, color: Colors.grey), const SizedBox(width: 4), Text("${donor['city']} - ${donor['area'] ?? ''}", style: const TextStyle(color: Colors.grey, fontSize: 12))])]))]), Positioned(top: -10, left: -10, child: PopupMenuButton<String>(icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20), onSelected: (value) { if (value == 'report') _reportUser(donor); }, itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[const PopupMenuItem<String>(value: 'report', child: Row(children: [Icon(Icons.flag, color: Colors.red, size: 18), SizedBox(width: 10), Text('إبلاغ', style: TextStyle(fontSize: 12))]))])), Positioned(bottom: 0, left: 0, child: Row(children: [IconButton(icon: const Icon(Icons.chat, color: Color(0xFF25D366)), onPressed: () => _secureContact(donor, () => _openWhatsApp(donor['phone_number']))), IconButton(icon: const Icon(Icons.phone, color: Colors.blue), onPressed: () => _secureContact(donor, () => _makePhoneCall(donor['phone_number'])))]))]));
  }
  Widget _buildDropdown({required String hint, required String? value, required List<String> items, required IconData icon, required Function(String?) onChanged}) { return Container(padding: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, hint: Row(children: [Icon(icon, color: const Color(0xFFE63946), size: 20), const SizedBox(width: 10), Text(tr(hint))]), isExpanded: true, items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(), onChanged: onChanged))); }
}