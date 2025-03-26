/**
 * stock_observer_factory.dart
 * 
 * 本文件實現了工廠模式和工廠構造函數範例，用於創建股票觀察者對象。
 * 包含兩種實現方式：
 * 1. 通過工廠構造函數（Factory Constructor）- Dart語言特有的語法糖
 * 2. 通過靜態工廠方法（Static Factory Method）- 傳統的工廠模式實現
 */

import 'stock_observer.dart';

/// 觀察者類型枚舉 - 用於區分不同類型的觀察者
enum ObserverType {
  investor,  // 投資者類型
  analyst,   // 分析師類型
}

/**
 * 股票投資者類 - 實現了StockObserver接口
 * 
 * 該類使用了Dart的工廠構造函數(Factory Constructor)特性，
 * 通過withStocks命名構造函數提供了創建並初始化對象的便捷方式
 */
class StockInvestor implements StockObserver {
  final String name;                // 投資者姓名
  final List<String> interestedStocks = []; // 關注的股票列表
  LogCallback? _logCallback;        // 日誌回調函數
  
  // 基本構造函數 - 創建投資者實例
  StockInvestor(this.name);
  
  /**
   * 工廠構造函數 - 創建投資者並設置關注的股票
   * 
   * 優點:
   * 1. 封裝複雜的創建邏輯
   * 2. 提供更直觀的命名
   * 3. 更符合Dart語言特性
   */
  factory StockInvestor.withStocks(String name, List<String> stocks) {
    final investor = StockInvestor(name);
    for (var stock in stocks) {
      investor.followStock(stock);
    }
    return investor;
  }
  
  /// 設置日誌回調函數 - 實現自StockObserver接口
  @override
  set logCallback(LogCallback callback) {
    _logCallback = callback;
  }
  
  /// 輸出日誌的私有方法
  void _log(String message) {
    print(message); // 控制台輸出
    _logCallback?.call(message); // 調用回調函數(如果存在)
  }
  
  /// 關注特定股票的方法
  void followStock(String symbol) {
    if (!interestedStocks.contains(symbol)) {
      interestedStocks.add(symbol);
      _log('$name 開始關注股票 $symbol');
    }
  }
  
  /// 取消關注股票的方法
  void unfollowStock(String symbol) {
    interestedStocks.remove(symbol);
    _log('$name 不再關注股票 $symbol');
  }
  
  /**
   * 更新方法 - 實現自StockObserver接口
   * 當關注的股票價格變化時被調用
   */
  @override
  void update(String stockSymbol, double price) {
    if (interestedStocks.contains(stockSymbol)) {
      _log('通知: $name, 您關注的股票 $stockSymbol 當前價格為 ¥$price');
    }
  }
}

/**
 * 股票分析師類 - 實現了StockObserver接口
 * 
 * 該類同樣使用工廠構造函數模式，通過withThresholds命名構造函數
 * 提供了一種便捷的方式來創建並初始化分析師對象
 */
class StockAnalyst implements StockObserver {
  final String name;                      // 分析師姓名
  final Map<String, double> priceThresholds = {}; // 股票價格閾值映射
  LogCallback? _logCallback;              // 日誌回調函數
  
  // 基本構造函數
  StockAnalyst(this.name);
  
  /**
   * 工廠構造函數 - 創建分析師並設置價格閾值
   * 
   * 相較於傳統構造函數加初始化代碼，工廠構造函數提供了：
   * 1. 更具表達力的API
   * 2. 更好的封裝性
   * 3. 代碼復用
   */
  factory StockAnalyst.withThresholds(String name, Map<String, double> thresholds) {
    final analyst = StockAnalyst(name);
    thresholds.forEach((stock, threshold) {
      analyst.setThreshold(stock, threshold);
    });
    return analyst;
  }
  
  /// 設置日誌回調函數 - 實現自StockObserver接口
  @override
  set logCallback(LogCallback callback) {
    _logCallback = callback;
  }
  
  /// 輸出日誌的私有方法
  void _log(String message) {
    print(message);
    _logCallback?.call(message);
  }
  
  /// 設置股票價格閾值的方法
  void setThreshold(String symbol, double threshold) {
    priceThresholds[symbol] = threshold;
    _log('$name 設置 $symbol 的價格閾值為 ¥$threshold');
  }
  
  /**
   * 更新方法 - 實現自StockObserver接口
   * 當股票價格變化時被調用，根據設置的閾值進行分析
   */
  @override
  void update(String stockSymbol, double price) {
    if (priceThresholds.containsKey(stockSymbol)) {
      final threshold = priceThresholds[stockSymbol]!;
      if (price >= threshold) {
        _log('分析警報: $name 發現 $stockSymbol 價格 ¥$price 已超過閾值 ¥$threshold，建議賣出！');
      }
      if (price <= threshold * 0.7) {
        _log('分析警報: $name 發現 $stockSymbol 價格 ¥$price 遠低於閾值 ¥$threshold，可能是買入機會！');
      }
    }
  }
}

/**
 * 觀察者工廠類 - 傳統工廠模式實現
 * 
 * 提供靜態方法來創建觀察者對象，演示了傳統工廠模式的實現方式
 * 在已有工廠構造函數的情況下，此類主要用於兼容舊代碼
 */
class StockObserverFactory {
  // 私有構造函數，防止實例化 - 因為該類只提供靜態工廠方法
  StockObserverFactory._();
  
  /**
   * 創建觀察者的通用工廠方法
   * 
   * 優點:
   * 1. 封裝對象創建邏輯
   * 2. 根據類型參數創建不同對象
   * 3. 隱藏實現細節
   * 
   * @param type 觀察者類型
   * @param name 觀察者名稱
   * @param interestedStocks 可選參數，投資者關注的股票
   * @param thresholds 可選參數，分析師的股票閾值
   * @return 返回創建的觀察者對象
   */
  static StockObserver createObserver({
    required ObserverType type,
    required String name,
    List<String>? interestedStocks,
    Map<String, double>? thresholds,
  }) {
    switch (type) {
      case ObserverType.investor:
        return interestedStocks != null 
            ? StockInvestor.withStocks(name, interestedStocks)
            : StockInvestor(name);
      case ObserverType.analyst:
        return thresholds != null 
            ? StockAnalyst.withThresholds(name, thresholds)
            : StockAnalyst(name);
    }
  }
  
  /**
   * 創建投資者的便捷工廠方法
   * 
   * @param name 投資者名稱
   * @param interestedStocks 可選參數，投資者關注的股票
   * @return 返回創建的投資者對象
   */
  static StockInvestor createInvestor(String name, [List<String>? interestedStocks]) {
    return interestedStocks != null
        ? StockInvestor.withStocks(name, interestedStocks)
        : StockInvestor(name);
  }
  
  /**
   * 創建分析師的便捷工廠方法
   * 
   * @param name 分析師名稱
   * @param thresholds 可選參數，分析師的股票閾值
   * @return 返回創建的分析師對象
   */
  static StockAnalyst createAnalyst(String name, [Map<String, double>? thresholds]) {
    return thresholds != null
        ? StockAnalyst.withThresholds(name, thresholds)
        : StockAnalyst(name);
  }
} 