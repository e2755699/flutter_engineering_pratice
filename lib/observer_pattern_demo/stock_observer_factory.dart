import 'stock_observer.dart';

/// 觀察者類型枚舉
enum ObserverType {
  investor,
  analyst,
}

/// 觀察者工廠類
class StockObserverFactory {
  /// 創建觀察者
  static StockObserver createObserver({
    required ObserverType type,
    required String name,
    List<String>? interestedStocks,
    Map<String, double>? thresholds,
  }) {
    switch (type) {
      case ObserverType.investor:
        final investor = StockInvestor(name);
        // 如果提供了感興趣的股票，則添加
        if (interestedStocks != null) {
          for (var stock in interestedStocks) {
            investor.followStock(stock);
          }
        }
        return investor;
      case ObserverType.analyst:
        final analyst = StockAnalyst(name);
        // 如果提供了閾值，則設置
        if (thresholds != null) {
          thresholds.forEach((stock, threshold) {
            analyst.setThreshold(stock, threshold);
          });
        }
        return analyst;
    }
  }
  
  /// 創建投資者
  static StockInvestor createInvestor(String name, [List<String>? interestedStocks]) {
    return createObserver(
      type: ObserverType.investor,
      name: name,
      interestedStocks: interestedStocks,
    ) as StockInvestor;
  }
  
  /// 創建分析師
  static StockAnalyst createAnalyst(String name, [Map<String, double>? thresholds]) {
    return createObserver(
      type: ObserverType.analyst,
      name: name,
      thresholds: thresholds,
    ) as StockAnalyst;
  }
} 