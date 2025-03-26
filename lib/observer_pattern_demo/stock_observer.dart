import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

// 日誌回調函數類型
typedef LogCallback = void Function(String message);

// 價格變化監聽回調函數類型
typedef PriceChangeCallback = void Function(String symbol, double price);

// 觀察者接口：定義股票觀察者必須實現的方法
abstract class StockObserver {
  void update(String stockSymbol, double price);
  set logCallback(LogCallback callback);
}

// 主題接口：定義可被觀察的對象需要實現的方法
abstract class StockSubject {
  void registerObserver(StockObserver observer);
  void removeObserver(StockObserver observer);
  void notifyObservers();
  set logCallback(LogCallback callback);
}

// 具體主題：股票市場
class StockMarket implements StockSubject {
  // 股票代碼到價格的映射
  final Map<String, double> _stockPrices = {};
  // 觀察者列表
  final List<StockObserver> _observers = [];
  // 日誌回調
  LogCallback? _logCallback;
  // 價格變化監聽器
  PriceChangeCallback? _priceChangeCallback;
  
  // 單例模式確保全局只有一個股票市場
  static final StockMarket _instance = StockMarket._internal();
  
  factory StockMarket() {
    return _instance;
  }
  
  StockMarket._internal();
  
  // 設置價格變化監聽器
  void setPriceChangeListener(PriceChangeCallback callback) {
    _priceChangeCallback = callback;
  }
  
  // 實現日誌回調設置
  @override
  set logCallback(LogCallback callback) {
    _logCallback = callback;
  }
  
  // 輸出日誌
  void _log(String message) {
    print(message);
    _logCallback?.call(message);
  }
  
  // 獲取股票價格
  double? getStockPrice(String symbol) {
    return _stockPrices[symbol];
  }
  
  // 更新股票價格
  void updateStockPrice(String symbol, double price) {
    _stockPrices[symbol] = price;
    _log('股票 $symbol 價格更新為 ¥$price');
    // 通知價格變化監聽器
    _priceChangeCallback?.call(symbol, price);
    notifyObservers();
  }
  
  // 實現註冊觀察者方法
  @override
  void registerObserver(StockObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }
  
  // 實現移除觀察者方法
  @override
  void removeObserver(StockObserver observer) {
    _observers.remove(observer);
  }
  
  // 實現通知所有觀察者方法
  @override
  void notifyObservers() {
    for (var observer in _observers) {
      _stockPrices.forEach((symbol, price) {
        observer.update(symbol, price);
      });
    }
  }
  
  // 模擬股票價格變動
  void startStockPriceSimulation() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      _stockPrices.keys.forEach((symbol) {
        // 模擬價格波動 (-3% 到 +3%)
        final currentPrice = _stockPrices[symbol] ?? 0.0;
        final change = currentPrice * (0.06 * (Random().nextDouble() - 0.5));
        updateStockPrice(symbol, (currentPrice + change).clamp(1.0, 10000.0));
      });
    });
  }
  
  // 添加新股票
  void addStock(String symbol, double initialPrice) {
    if (!_stockPrices.containsKey(symbol)) {
      _stockPrices[symbol] = initialPrice;
      _log('添加股票 $symbol，初始價格 ¥$initialPrice');
      notifyObservers();
    }
  }
}

// 具體觀察者：股票投資者
class StockInvestor implements StockObserver {
  final String name;
  final List<String> interestedStocks = [];
  LogCallback? _logCallback;
  
  // 基本構造函數
  StockInvestor(this.name);
  
  // 工廠構造函數 - 創建投資者並設置關注的股票
  factory StockInvestor.withStocks(String name, List<String> stocks) {
    final investor = StockInvestor(name);
    for (var stock in stocks) {
      investor.followStock(stock);
    }
    return investor;
  }
  
  @override
  set logCallback(LogCallback callback) {
    _logCallback = callback;
  }
  
  void _log(String message) {
    print(message);
    _logCallback?.call(message);
  }
  
  // 關注特定股票
  void followStock(String symbol) {
    if (!interestedStocks.contains(symbol)) {
      interestedStocks.add(symbol);
      _log('$name 開始關注股票 $symbol');
    }
  }
  
  // 取消關注股票
  void unfollowStock(String symbol) {
    interestedStocks.remove(symbol);
    _log('$name 不再關注股票 $symbol');
  }
  
  // 實現更新方法，接收主題通知
  @override
  void update(String stockSymbol, double price) {
    if (interestedStocks.contains(stockSymbol)) {
      _log('通知: $name, 您關注的股票 $stockSymbol 當前價格為 ¥$price');
    }
  }
}

// 具體觀察者：股票分析師
class StockAnalyst implements StockObserver {
  final String name;
  final Map<String, double> priceThresholds = {};
  LogCallback? _logCallback;
  
  // 基本構造函數
  StockAnalyst(this.name);
  
  // 工廠構造函數 - 創建分析師並設置價格閾值
  factory StockAnalyst.withThresholds(String name, Map<String, double> thresholds) {
    final analyst = StockAnalyst(name);
    thresholds.forEach((stock, threshold) {
      analyst.setThreshold(stock, threshold);
    });
    return analyst;
  }
  
  @override
  set logCallback(LogCallback callback) {
    _logCallback = callback;
  }
  
  void _log(String message) {
    print(message);
    _logCallback?.call(message);
  }
  
  // 設置股票價格閾值
  void setThreshold(String symbol, double threshold) {
    priceThresholds[symbol] = threshold;
    _log('$name 設置 $symbol 的價格閾值為 ¥$threshold');
  }
  
  // 實現更新方法，根據閾值分析
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