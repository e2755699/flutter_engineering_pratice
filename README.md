# Flutter 股票市場應用 - 觀察者模式實現

這個項目是一個使用Flutter框架開發的股票市場應用，展示了設計模式中觀察者模式（Observer Pattern）的實際應用。

## 功能特點

- **觀察者模式實現**：通過StockSubject和StockObserver接口實現股票價格變化的發布-訂閱機制
- **實時股票價格模擬**：模擬股票價格的實時變化
- **個性化股票關注**：投資者可以選擇關注特定的股票
- **價格閾值警報**：分析師可以設置股票價格閾值，當價格超過閾值時發出賣出建議
- **視覺化價格變化**：股票價格變化時有視覺效果提示（上漲紅色，下跌綠色）

## 主要組件

- `StockObserver`：觀察者接口，定義了當被觀察對象發生變化時的通知方法
- `StockSubject`：被觀察者接口，定義了註冊、移除和通知觀察者的方法
- `StockMarket`：具體的被觀察者，維護股票價格並在價格變化時通知觀察者
- `StockInvestor`：具體的觀察者，代表關注特定股票的投資者
- `StockAnalyst`：具體的觀察者，代表設置閾值的分析師

## 技術細節

- **Flutter框架**：使用Flutter進行跨平台開發
- **Dart語言**：採用Dart作為開發語言
- **動畫效果**：使用AnimationController實現股票價格變化的視覺反饋
- **狀態管理**：採用Flutter原生的狀態管理方式

## 安裝與運行

1. 確保已安裝Flutter環境
2. 克隆本倉庫：`git clone https://github.com/e2755699/flutter_engineering_pratice.git`
3. 進入項目目錄：`cd flutter_engineering_pratice`
4. 獲取依賴：`flutter pub get`
5. 運行應用：`flutter run`

## 項目結構

```
lib/
├── main.dart                     # 應用入口
├── observer_pattern_demo/        # 觀察者模式實現
│   ├── stock_app_screen.dart     # 主界面
│   └── stock_observer.dart       # 觀察者模式接口及實現
└── utils/                        # 工具類
    └── battery_level.dart        # 系統工具
```

## 學習要點

- 設計模式在實際應用中的運用
- Flutter中的狀態管理和UI更新
- 動畫效果的實現
- 模擬現實業務場景的軟件開發

## 許可證

MIT License
