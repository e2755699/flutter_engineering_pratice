import 'package:flutter/material.dart';
import 'yellow_ribbon_button.dart';

/// 按鈕組件示例頁面
///
/// 這個頁面展示了YellowRibbonButton各種使用方式
class ButtonDemoPage extends StatelessWidget {
  const ButtonDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('黃絲帶按鈕示例'),
        backgroundColor: const Color(0xFF194680),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 描述標籤
              const Text(
                '禁用狀態按鈕',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // 基本按鈕 - 禁用狀態
              const YellowRibbonButton(
                label: 'Button Label',
                onPressed: null, // 禁用狀態
              ),
              const SizedBox(height: 20),
              
              // 描述標籤
              const Text(
                '正常狀態按鈕',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // 啟用狀態按鈕
              YellowRibbonButton(
                label: '確定',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('按鈕被點擊了！')),
                  );
                },
              ),
              const SizedBox(height: 20),
              
              // 描述標籤
              const Text(
                '自定義寬度按鈕',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // 自定義寬度按鈕
              YellowRibbonButton(
                label: '寬度300px的按鈕',
                width: 300,
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              
              // 描述標籤
              const Text(
                '自定義顏色按鈕',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // 自定義顏色按鈕
              YellowRibbonButton(
                label: '自定義顏色按鈕',
                backgroundColor: Colors.deepOrange,
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              
              // 描述標籤
              const Text(
                '自定義文字樣式按鈕',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // 自定義文字樣式按鈕
              YellowRibbonButton(
                label: '自定義文字樣式',
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              
              // 描述標籤
              const Text(
                '較小的按鈕',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // 較小的按鈕
              YellowRibbonButton(
                label: '較小的按鈕',
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
} 