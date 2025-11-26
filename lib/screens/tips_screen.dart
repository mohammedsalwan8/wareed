import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("نصائح طبية", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTipCard("من يستطيع التبرع؟", "• العمر: 18-65 سنة\n• الوزن: أكثر من 50 كغم\n• الصحة: خالي من الأمراض المزمنة والمعدية", Icons.health_and_safety, Colors.blue),          _buildTipCard("فوائد التبرع", "• تجديد خلايا الدم\n• تقليل خطر الإصابة بالجلطات\n• فحص مجاني شامل للدم", Icons.favorite, Colors.red),
          _buildTipCard("قبل التبرع", "• نم جيداً ليلة التبرع\n• تناول وجبة خفيفة صحية\n• اشرب كميات وفيرة من الماء", Icons.nightlight_round, Colors.orange),
          _buildTipCard("بعد التبرع", "• استرح لمدة 10-15 دقيقة\n• تناول السوائل والعصائر\n• تجنب المجهود الشاق لمدة يوم", Icons.local_cafe, Colors.green),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String content, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(right: BorderSide(color: color, width: 5)), // شريط ملون جانبي
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 10),
              Text(title, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          Text(content, style: GoogleFonts.cairo(fontSize: 14, height: 1.6, color: Colors.grey[700])),
        ],
      ),
    );
  }
}