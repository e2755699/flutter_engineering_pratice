import 'package:flutter/material.dart';
import 'dart:async';
import 'stock_observer.dart';
import 'stock_observer_factory.dart';

// 股票價格變化枚舉
enum StockPriceChange {
  up,
  down,
  stable,
}

// 股票價格類，用於跟踪當前和前一個價格
class StockPriceInfo {
  double price;
  double? previousPrice;
  
  StockPriceInfo(this.price);
  
  void updatePrice(double newPrice) {
    previousPrice = price;
    price = newPrice;
  }
}

class FactoryStockScreen extends StatefulWidget {
  const FactoryStockScreen({Key? key}) : super(key: key);

  @override
  FactoryStockScreenState createState() => FactoryStockScreenState();
}

class FactoryStockScreenState extends State<FactoryStockScreen> with TickerProviderStateMixin {
  // 股票市場
  final StockMarket _stockMarket = StockMarket();
  
  // 使用工廠方法創建觀察者
  late final StockInvestor _investor1;
  late final StockInvestor _investor2;
  late final StockAnalyst _analyst;
  
  // 日誌收集器
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();
  
  // 價格變化動畫控制器
  final Map<String, AnimationController> _animationControllers = {};
  
  // 股票價格變化狀態
  final Map<String, StockPriceChange> _priceChangeStatus = {};
  
  // 存儲股票價格信息
  final Map<String, StockPriceInfo> _stockPriceInfos = {};

  @override
  void initState() {
    super.initState();
    
    // 使用工廠模式創建觀察者
    _investor1 = StockObserverFactory.createInvestor('張先生');
    _investor2 = StockObserverFactory.createInvestor('李女士');
    
    // 使用工廠模式創建分析師，並設置閾值
    _analyst = StockObserverFactory.createAnalyst('王分析師', {
      'AAPL': 190.0,
      'GOOGL': 150.0,
      'TSLA': 220.0,
    });
    
    // 初始化股票
    _initializeStocks();
    
    // 註冊觀察者到股票市場
    _stockMarket.registerObserver(_investor1);
    _stockMarket.registerObserver(_investor2);
    _stockMarket.registerObserver(_analyst);
    
    // 觀察者設置自己感興趣的股票
    _investor1.followStock('AAPL');
    _investor1.followStock('TSLA');
    _investor2.followStock('GOOGL');
    _investor2.followStock('BABA');
    
    // 創建一個日誌收集器
    _setupLogCollector();
    
    // 添加價格變化監聽器
    _setupPriceChangeListener();
    
    // 啟動股票價格模擬
    _stockMarket.startStockPriceSimulation();
  }
  
  // 初始化股票
  void _initializeStocks() {
    // 添加初始股票
    _stockMarket.addStock('AAPL', 180.0);
    _stockMarket.addStock('GOOGL', 140.0);
    _stockMarket.addStock('TSLA', 200.0);
    _stockMarket.addStock('BABA', 60.0);
    _stockMarket.addStock('PDD', 150.0);
    
    // 初始化股票價格信息
    _stockPriceInfos['AAPL'] = StockPriceInfo(180.0);
    _stockPriceInfos['GOOGL'] = StockPriceInfo(140.0);
    _stockPriceInfos['TSLA'] = StockPriceInfo(200.0);
    _stockPriceInfos['BABA'] = StockPriceInfo(60.0);
    _stockPriceInfos['PDD'] = StockPriceInfo(150.0);
  }
  
  // 獲取所有股票代碼
  List<String> _getAllStockSymbols() {
    return _stockPriceInfos.keys.toList();
  }
  
  // 獲取股票價格信息
  StockPriceInfo getStockPriceInfo(String symbol) {
    return _stockPriceInfos[symbol] ?? StockPriceInfo(0.0);
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
      // 更新股票價格信息
      if (_stockPriceInfos.containsKey(symbol)) {
        setState(() {
          _stockPriceInfos[symbol]!.updatePrice(price);
        });
      } else {
        setState(() {
          _stockPriceInfos[symbol] = StockPriceInfo(price);
        });
      }
      
      final priceInfo = _stockPriceInfos[symbol]!;
      final prevPrice = priceInfo.previousPrice;
      
      if (prevPrice != null) {
        setState(() {
          if (price > prevPrice) {
            _priceChangeStatus[symbol] = StockPriceChange.up;
          } else if (price < prevPrice) {
            _priceChangeStatus[symbol] = StockPriceChange.down;
          } else {
            _priceChangeStatus[symbol] = StockPriceChange.stable;
          }
        });
        
        // 創建動畫控制器
        if (!_animationControllers.containsKey(symbol)) {
          _animationControllers[symbol] = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          )..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationControllers[symbol]?.reverse();
            } else if (status == AnimationStatus.dismissed) {
              // 當動畫結束後，等待一段時間後恢復正常狀態
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    _priceChangeStatus[symbol] = StockPriceChange.stable;
                  });
                }
              });
            }
          });
        }
        
        // 播放動畫
        _animationControllers[symbol]?.forward();
      }
    });
  }
  
  // 設置日誌收集器
  void _setupLogCollector() {
    _investor1.logCallback = (log) {
      setState(() {
        _logs.add(log);
      });
      _scrollToBottom();
    };
    
    _investor2.logCallback = (log) {
      setState(() {
        _logs.add(log);
      });
      _scrollToBottom();
    };
    
    _analyst.logCallback = (log) {
      setState(() {
        _logs.add(log);
      });
      _scrollToBottom();
    };
    
    _stockMarket.logCallback = (log) {
      setState(() {
        _logs.add(log);
      });
      _scrollToBottom();
    };
  }
  
  // 滾動到日誌底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工廠模式 - 股票市場應用'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildStockGrid(),
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildLogView(),
          ),
        ],
      ),
    );
  }
  
  // 構建股票網格
  Widget _buildStockGrid() {
    final stockSymbols = _getAllStockSymbols();
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: stockSymbols.length,
      itemBuilder: (context, index) {
        final symbol = stockSymbols[index];
        return _buildStockCard(symbol);
      },
    );
  }
  
  // 構建股票卡片
  Widget _buildStockCard(String symbol) {
    final priceInfo = getStockPriceInfo(symbol);
    final priceChangeStatus = _priceChangeStatus[symbol] ?? StockPriceChange.stable;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _getBorderColor(priceChangeStatus),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              symbol,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildStockPriceSection(symbol, priceInfo.price, priceChangeStatus),
            const SizedBox(height: 8),
            Text(
              '更新時間: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 構建股票價格部分
  Widget _buildStockPriceSection(String symbol, double price, StockPriceChange status) {
    return Stack(
      children: [
        Text(
          '¥${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _getPriceColor(status),
          ),
        ),
        // 在右上角添加一個小圓點，表示價格變化方向
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getPriceColor(status).withOpacity(
                status == StockPriceChange.stable ? 0.0 : 1.0
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // 獲取價格顏色
  Color _getPriceColor(StockPriceChange status) {
    switch (status) {
      case StockPriceChange.up:
        return Colors.red;
      case StockPriceChange.down:
        return Colors.green;
      case StockPriceChange.stable:
        return Colors.black;
    }
  }
  
  // 獲取邊框顏色
  Color _getBorderColor(StockPriceChange status) {
    switch (status) {
      case StockPriceChange.up:
        return Colors.red.withOpacity(0.7);
      case StockPriceChange.down:
        return Colors.green.withOpacity(0.7);
      case StockPriceChange.stable:
        return Colors.grey.withOpacity(0.3);
    }
  }
  
  // 構建日誌視圖
  Widget _buildLogView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.grey.shade200,
          child: const Text(
            '日誌記錄',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                Color textColor = Colors.black;
                
                if (log.contains('分析警報')) {
                  textColor = Colors.red;
                } else if (log.contains('通知')) {
                  textColor = Colors.blue;
                } else if (log.contains('價格更新')) {
                  textColor = Colors.green;
                }
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    log,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
} 