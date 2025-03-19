# Flutter 股票市場應用 - 設計模式實現

這個項目是一個使用Flutter框架開發的股票市場應用，展示了設計模式中觀察者模式（Observer Pattern）和工廠模式（Factory Pattern）的實際應用。

## 功能特點

- **觀察者模式實現**：通過StockSubject和StockObserver接口實現股票價格變化的發布-訂閱機制
- **工廠模式實現**：通過StockObserverFactory封裝觀察者對象的創建過程
- **實時股票價格模擬**：模擬股票價格的實時變化
- **個性化股票關注**：投資者可以選擇關注特定的股票
- **價格閾值警報**：分析師可以設置股票價格閾值，當價格超過閾值時發出賣出建議
- **視覺化價格變化**：股票價格變化時有視覺效果提示（上漲紅色，下跌綠色）

## 主要組件

### 觀察者模式組件

- `StockObserver`：觀察者接口，定義了當被觀察對象發生變化時的通知方法
- `StockSubject`：被觀察者接口，定義了註冊、移除和通知觀察者的方法
- `StockMarket`：具體的被觀察者，維護股票價格並在價格變化時通知觀察者
- `StockInvestor`：具體的觀察者，代表關注特定股票的投資者
- `StockAnalyst`：具體的觀察者，代表設置閾值的分析師

### 工廠模式組件

- `StockObserverFactory`：觀察者工廠類，封裝了StockInvestor和StockAnalyst的創建邏輯
- `ObserverType`：觀察者類型枚舉，用於區分不同類型的觀察者

## 技術細節

- **Flutter框架**：使用Flutter進行跨平台開發
- **Dart語言**：採用Dart作為開發語言
- **動畫效果**：使用AnimationController實現股票價格變化的視覺反饋
- **狀態管理**：採用Flutter原生的狀態管理方式
- **設計模式**：應用多種設計模式解決實際問題

## 安裝與運行

1. 確保已安裝Flutter環境
2. 克隆本倉庫：`git clone https://github.com/e2755699/flutter_engineering_pratice.git`
3. 進入項目目錄：`cd flutter_engineering_pratice`
4. 獲取依賴：`flutter pub get`
5. 運行應用：`flutter run`

## 項目結構

```
lib/
├── main.dart                         # 應用入口
├── observer_pattern_demo/            # 觀察者模式和工廠模式實現
│   ├── stock_app_screen.dart         # 觀察者模式主界面
│   ├── factory_stock_screen.dart     # 工廠模式主界面
│   ├── stock_observer.dart           # 觀察者模式接口及實現
│   └── stock_observer_factory.dart   # 工廠模式實現
└── utils/                            # 工具類
    └── battery_level.dart            # 系統工具
```

## 設計模式學習要點

### 觀察者模式
- 一對多的依賴關係：當一個對象狀態改變時，所有依賴它的對象都會得到通知並自動更新
- 松耦合設計：觀察者和被觀察者之間的抽象耦合，實現了對象之間的解耦
- 開放封閉原則：無需修改既有代碼即可擴展系統的功能

### 工廠模式
- 封裝對象創建邏輯：隱藏對象的實例化過程
- 提高代碼可維護性：集中管理對象的創建方式
- 依賴倒置原則：代碼依賴於抽象接口，而非具體實現

## 許可證

MIT License
