import 'package:flutter/material.dart';
import 'yellow_ribbon_button.dart';

/// 學生信息水平卡片組件
/// 
/// 這個卡片組件基於Figma設計文件(node-id=22:202)實現
/// 卡片包含學生頭像、姓名、班級信息和操作按鈕
class HorizontalStudentCard extends StatelessWidget {
  /// 學生姓名
  final String name;
  
  /// 學生班級信息
  final String classInfo;
  
  /// 學生頭像的首字母（用於生成頭像）
  final String initial;
  
  /// 點擊查看按鈕的回調
  final VoidCallback? onView;
  
  /// 卡片寬度，默認為360
  final double width;
  
  /// 卡片高度，默認為80
  final double height;
  
  /// 頭像背景顏色
  final Color avatarColor;
  
  const HorizontalStudentCard({
    Key? key,
    required this.name,
    required this.classInfo,
    required this.initial,
    this.onView,
    this.width = 360,
    this.height = 80,
    this.avatarColor = const Color(0xFF65558F),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCAC4D0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 左側頭像和文本區域
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // 學生頭像
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: avatarColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 學生信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1D1B20),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          classInfo,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1D1B20),
                            letterSpacing: 0.25,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 右側操作按鈕
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: YellowRibbonButton(
              label: 'view',
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              onPressed: onView,
            ),
          ),
        ],
      ),
    );
  }
}

/// 卡片用例示例
/// 
/// 在應用中可以這樣使用卡片組件：
/// ```dart
/// HorizontalStudentCard(
///   name: '王小明',
///   classInfo: '勝利國小三年級',
///   initial: 'W',
///   onView: () {
///     // 處理查看操作
///   },
/// )
/// ``` 