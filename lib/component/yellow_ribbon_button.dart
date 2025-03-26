import 'package:flutter/material.dart';

/// 黃絲帶學習系統按鈕組件
/// 
/// 這個按鈕組件基於Figma設計文件(node-id=43-811)實現
/// 按鈕具有深藍色背景、圓角設計以及白色文字
/// 點擊時會變成黃色背景(#FFCC00)，基於設計文件(node-id=47-97)
/// 禁用時按鈕背景透明度降低至10%，基於設計文件(node-id=47-107)
class YellowRibbonButton extends StatelessWidget {
  /// 按鈕文字
  final String label;
  
  /// 點擊事件回調
  final VoidCallback? onPressed;
  
  /// 按鈕寬度，默認為自適應內容
  final double? width;
  
  /// 按鈕高度，默認為48
  final double height;
  
  /// 文字樣式，默認為白色文字、16號字體、500字重
  final TextStyle? textStyle;
  
  /// 背景顏色，默認為深藍色 #194680
  final Color backgroundColor;
  
  /// 點擊時的背景顏色，默認為黃色 #FFCC00
  final Color pressedColor;
  
  /// 按鈕內邊距
  final EdgeInsetsGeometry padding;
  
  /// 禁用時的背景透明度，默認為0.1 (10%)
  final double disabledOpacity;
  
  const YellowRibbonButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.width,
    this.height = 48,
    this.textStyle,
    this.backgroundColor = const Color(0xFF194680),
    this.pressedColor = const Color(0xFFFFCC00),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    this.disabledOpacity = 0.1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return backgroundColor.withOpacity(disabledOpacity);
              }
              if (states.contains(MaterialState.pressed)) {
                return pressedColor;
              }
              return backgroundColor;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.white.withOpacity(disabledOpacity);
              }
              return Colors.white;
            },
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999), // 完全圓角按鈕
            ),
          ),
          padding: MaterialStateProperty.all(padding),
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return 0;
              }
              return 2;
            },
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(
          label,
          style: textStyle ?? TextStyle(
            color: isDisabled ? Colors.white.withOpacity(disabledOpacity) : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            letterSpacing: 0.1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// 按鈕用例示例
/// 
/// 在應用中可以這樣使用按鈕組件：
/// ```dart
/// YellowRibbonButton(
///   label: '確定',
///   onPressed: () {
///     // 處理點擊事件
///   },
/// )
/// ```
/// 
/// 禁用狀態按鈕：
/// ```dart
/// YellowRibbonButton(
///   label: '確定',
///   onPressed: null, // 設置為null表示按鈕禁用
/// )
/// ```
/// 
/// 自定義樣式：
/// ```dart
/// YellowRibbonButton(
///   label: '取消',
///   backgroundColor: Colors.grey,
///   pressedColor: Colors.amber,
///   width: 200,
///   onPressed: () {
///     // 處理點擊事件
///   },
/// )
/// ``` 