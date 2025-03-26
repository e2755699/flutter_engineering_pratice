import 'package:flutter/material.dart';
import 'stock_observer.dart';
import 'package:flutter_engineering_pratice/component/yellow_ribbon_button.dart';

// 股票價格變化狀態枚舉
enum StockPriceChange {
  up,     // 上漲
  down,   // 下跌
  stable  // 穩定
}

class StockAppScreen extends StatefulWidget {
  const StockAppScreen({super.key});

  @override
  State<StockAppScreen> createState() => _StockAppScreenState();
}

class _StockAppScreenState extends State<StockAppScreen> with TickerProviderStateMixin {
  final StockMarket _stockMarket = StockMarket();
  final StockInvestor _investor1 = StockInvestor('張先生');
  final StockInvestor _investor2 = StockInvestor('李女士');
  final StockAnalyst _analyst = StockAnalyst('王分析師');
  
  final List<String> availableStocks = ['AAPL', 'GOOGL', 'TSLA', 'BABA', 'PDD'];
  final List<String> notifications = [];
  
  // 儲存股票價格歷史記錄
  final Map<String, double> _previousPrices = {};
  
  // 記錄股票變化狀態用於動畫
  final Map<String, StockPriceChange> _priceChangeStatus = {};
  
  // 動畫控制器
  final Map<String, AnimationController> _animationControllers = {};
  
  @override
  void initState() {
    super.initState();
    
    // 為每個股票創建動畫控制器
    for (final symbol in availableStocks) {
      _animationControllers[symbol] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      _priceChangeStatus[symbol] = StockPriceChange.stable;
    }
    
    // 初始化股票市場
    _stockMarket.addStock('AAPL', 180.0);
    _stockMarket.addStock('GOOGL', 140.0);
    _stockMarket.addStock('TSLA', 210.0);
    _stockMarket.addStock('BABA', 75.0);
    _stockMarket.addStock('PDD', 130.0);
    
    // 初始化前一次價格
    for (final symbol in availableStocks) {
      _previousPrices[symbol] = _stockMarket.getStockPrice(symbol) ?? 0.0;
    }
    
    // 註冊觀察者到股票市場
    _stockMarket.registerObserver(_investor1);
    _stockMarket.registerObserver(_investor2);
    _stockMarket.registerObserver(_analyst);
    
    // 觀察者設置自己感興趣的股票
    _investor1.followStock('AAPL');
    _investor1.followStock('TSLA');
    _investor2.followStock('GOOGL');
    _investor2.followStock('BABA');
    
    // 分析師設置閾值
    _analyst.setThreshold('AAPL', 190.0);
    _analyst.setThreshold('GOOGL', 150.0);
    _analyst.setThreshold('TSLA', 220.0);
    
    // 創建一個日誌收集器
    _setupLogCollector();
    
    // 添加價格變化監聽器
    _setupPriceChangeListener();
    
    // 啟動股票價格模擬
    _stockMarket.startStockPriceSimulation();
  }
  
  @override
  void dispose() {
    // 釋放動畫控制器
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  
  // 設置價格變化監聽器
  void _setupPriceChangeListener() {
    _stockMarket.setPriceChangeListener((symbol, price) {
      final previousPrice = _previousPrices[symbol] ?? 0.0;
      setState(() {
        // 更新價格變化狀態
        if (price > previousPrice) {
          _priceChangeStatus[symbol] = StockPriceChange.up;
          _animationControllers[symbol]?.reset();
          _animationControllers[symbol]?.repeat(reverse: true);
        } else if (price < previousPrice) {
          _priceChangeStatus[symbol] = StockPriceChange.down;
          _animationControllers[symbol]?.reset();
          _animationControllers[symbol]?.repeat(reverse: true);
        } else {
          _priceChangeStatus[symbol] = StockPriceChange.stable;
        }
        
        // 更新前一次價格
        _previousPrices[symbol] = price;
      });
      
      // 2秒後停止動畫
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _priceChangeStatus[symbol] = StockPriceChange.stable;
            _animationControllers[symbol]?.stop();
          });
        }
      });
    });
  }
  
  // 設置日誌收集
  void _setupLogCollector() {
    // 創建一個回調函數
    LogCallback logCallbackFunction = (String message) {
      setState(() {
        notifications.add(message);
        if (notifications.length > 20) {
          notifications.removeAt(0);
        }
      });
    };
    
    // 覆蓋 StockMarket 中的日誌方法來收集通知
    _stockMarket.logCallback = logCallbackFunction;
    
    // 設置投資者的日誌回調
    _investor1.logCallback = logCallbackFunction;
    _investor2.logCallback = logCallbackFunction;
    _analyst.logCallback = logCallbackFunction;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('股票觀察者模式演示'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _buildStockPriceSection(),
          _buildInvestorSection(),
          _buildNotificationsSection(),
        ],
      ),
    );
  }
  
  Widget _buildStockPriceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('當前股票價格', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableStocks.map((symbol) {
              final price = _stockMarket.getStockPrice(symbol) ?? 0.0;
              final priceChange = _priceChangeStatus[symbol] ?? StockPriceChange.stable;
              final controller = _animationControllers[symbol];
              
              return AnimatedBuilder(
                animation: controller ?? const AlwaysStoppedAnimation(0),
                builder: (context, child) {
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                            )
                          ],
                          border: priceChange != StockPriceChange.stable
                            ? Border.all(
                                color: priceChange == StockPriceChange.up
                                  ? Colors.red.withOpacity(controller?.value ?? 0)
                                  : Colors.green.withOpacity(controller?.value ?? 0),
                                width: 2,
                              )
                            : null,
                        ),
                        child: Column(
                          children: [
                            Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              '¥${price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: priceChange == StockPriceChange.up
                                  ? Colors.red
                                  : priceChange == StockPriceChange.down
                                    ? Colors.green
                                    : null,
                                fontWeight: priceChange != StockPriceChange.stable
                                  ? FontWeight.bold
                                  : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (priceChange != StockPriceChange.stable)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: priceChange == StockPriceChange.up
                                ? Colors.red.withOpacity(0.7 + (controller?.value ?? 0) * 0.3)
                                : Colors.green.withOpacity(0.7 + (controller?.value ?? 0) * 0.3),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInvestorSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('投資者與分析師', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InvestorCard(
                  name: _investor1.name,
                  followedStocks: _investor1.interestedStocks,
                  onFollowStock: (symbol) {
                    setState(() {
                      _investor1.followStock(symbol);
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InvestorCard(
                  name: _investor2.name,
                  followedStocks: _investor2.interestedStocks,
                  onFollowStock: (symbol) {
                    setState(() {
                      _investor2.followStock(symbol);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnalystCard(
            name: _analyst.name,
            thresholds: _analyst.priceThresholds,
            onSetThreshold: (symbol, threshold) {
              setState(() {
                _analyst.setThreshold(symbol, threshold);
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationsSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('通知中心', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: Text(notifications[notifications.length - 1 - index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvestorCard extends StatelessWidget {
  final String name;
  final List<String> followedStocks;
  final Function(String) onFollowStock;
  
  const InvestorCard({
    super.key,
    required this.name,
    required this.followedStocks,
    required this.onFollowStock,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('關注的股票:'),
            Wrap(
              spacing: 4,
              children: followedStocks.map((stock) => Chip(
                label: Text(stock, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.blue.shade100,
              )).toList(),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              hint: const Text('關注新股票'),
              isExpanded: true,
              items: ['AAPL', 'GOOGL', 'TSLA', 'BABA', 'PDD']
                  .where((s) => !followedStocks.contains(s))
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onFollowStock(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnalystCard extends StatefulWidget {
  final String name;
  final Map<String, double> thresholds;
  final Function(String, double) onSetThreshold;
  
  const AnalystCard({
    super.key,
    required this.name,
    required this.thresholds,
    required this.onSetThreshold,
  });
  
  @override
  State<AnalystCard> createState() => _AnalystCardState();
}

class _AnalystCardState extends State<AnalystCard> {
  String? selectedStock;
  final TextEditingController thresholdController = TextEditingController();
  
  @override
  void dispose() {
    thresholdController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('設置的閾值:'),
            widget.thresholds.isEmpty
                ? const Text('尚未設置閾值', style: TextStyle(fontStyle: FontStyle.italic))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.thresholds.entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('選擇股票'),
                    isExpanded: true,
                    value: selectedStock,
                    items: ['AAPL', 'GOOGL', 'TSLA', 'BABA', 'PDD']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStock = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: thresholdController,
                    decoration: const InputDecoration(
                      labelText: '閾值',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            YellowRibbonButton(
              label: '設置閾值',
              onPressed: () {
                if (selectedStock != null && thresholdController.text.isNotEmpty) {
                  final threshold = double.tryParse(thresholdController.text);
                  if (threshold != null) {
                    widget.onSetThreshold(selectedStock!, threshold);
                    thresholdController.clear();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
} 