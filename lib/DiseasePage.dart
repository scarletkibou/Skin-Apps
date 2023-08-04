import 'package:flutter/material.dart';

class DiseasePage extends StatelessWidget {
  final String Disease_name;
  DiseasePage({required this.Disease_name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Disease_name),
      ),
      body: ListView(
        children: [
          _buildDiseaseTile(
            cause:
                'เชื้อโรคอีสุกอีใสเกิดจากไวรัสที่แพร่เชื้อไปยังบุคคลอื่น ๆ ผ่านการสัมผัสกับผื่นโดยตรง นอกจากนั้นหากผู้ป่วยไอ หรือจามอาจจะทำการ	กระจายละอองเชื้ออีสุกอีใสไปในอากาศและทำการแพร่เชื้อแก่คนอื่นที่หายใจละอองที่มีเชื้อ เข้าไปในร่างกาย',
            treatment:
                '1.หลีกเลี่ยงการเกาแผลเนื่องจากช้าเพิ่มโอกาสการติดเชื้อ 2.ผู้ป่วยควรทำการนัดพบแพทย์เมื่อไข้กินระยะเวลานานเกิน 4 วัน 	และมีไข้ที่สูงกว่า 38.9 เซลเซียส 3.หลีกเลี่ยงการให้ยาแอสไพรินแก่เด็กหรือวัยรุ่นที่มีโรคอีสุกอีใสเนื่องจากอาจเกิดภาวะโรคเรย์ซินโด	รม 4.ควรทำการปรึกษาแพทย์ก่อนทำการให้ยาแก้ปวดลด อาการอักเสบกลุ่ม NSAID แก่ผู้ป่วยโรคอีสุกอีใส มีการวิจัยเผยว่ายากลุ่มนี้	อาจส่งผลให้เกิดการติดเชื้อ   ที่ผิวหนังหรือเนื้อเยื่อถูกทำลาย',
            medicine: 'อะไซโคลเวียร์ (acyclovir)',
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseTile({
    required String cause,
    required String treatment,
    required String medicine,
  }) {
    return ListTile(
      title: Text('Cause: $cause'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatment: $treatment'),
          Text('Medicine: $medicine'),
        ],
      ),
    );
  }
}
