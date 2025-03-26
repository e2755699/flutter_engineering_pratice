import 'package:flutter/material.dart';
import 'horizontal_card.dart';

/// 學生卡片組件示例頁面
///
/// 這個頁面展示了HorizontalStudentCard的各種使用方式
class CardDemoPage extends StatelessWidget {
  const CardDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 生成一個學生列表用於演示
    final List<Map<String, String>> students = [
      {'name': '王小明', 'classInfo': '勝利國小三年級', 'initial': 'W'},
      {'name': '張美麗', 'classInfo': '和平國小二年級', 'initial': 'Z'},
      {'name': '李大寶', 'classInfo': '仁愛國小四年級', 'initial': 'L'},
      {'name': '陳小花', 'classInfo': '信義國小一年級', 'initial': 'C'},
      {'name': '林小勇', 'classInfo': '忠孝國小五年級', 'initial': 'L'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('學生卡片示例'),
        backgroundColor: const Color(0xFF194680),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '學生列表',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B20),
                ),
              ),
              const SizedBox(height: 16),
              
              // 使用ListView.builder來顯示學生列表
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: HorizontalStudentCard(
                      name: student['name']!,
                      classInfo: student['classInfo']!,
                      initial: student['initial']!,
                      onView: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('查看${student['name']}的詳細信息')),
                        );
                      },
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              const Text(
                '自定義卡片',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B20),
                ),
              ),
              const SizedBox(height: 16),
              
              // 自定義寬度卡片
              HorizontalStudentCard(
                name: '黃大大',
                classInfo: '建國高中三年級',
                initial: 'H',
                width: double.infinity,
                avatarColor: Colors.deepOrange,
                onView: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('自定義寬度卡片被點擊')),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // 自定義高度卡片
              HorizontalStudentCard(
                name: '周小彬',
                classInfo: '師大附中一年級',
                initial: 'Z',
                height: 100,
                avatarColor: Colors.green,
                onView: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('自定義高度卡片被點擊')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 