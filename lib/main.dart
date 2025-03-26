import 'package:flutter/material.dart';
import 'package:flutter_engineering_pratice/utils/battery_level.dart';
import 'package:flutter_engineering_pratice/observer_pattern_demo/stock_app_screen.dart';
import 'package:flutter_engineering_pratice/observer_pattern_demo/factory_stock_screen.dart';
import 'package:flutter_engineering_pratice/component/button_demo_page.dart';
import 'package:flutter_engineering_pratice/component/card_demo_page.dart';
import 'package:flutter_engineering_pratice/component/yellow_ribbon_button.dart';

void main() {
  // WidgetTest().widgetCreate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter設計模式演示',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter設計模式演示'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              YellowRibbonButton(
                label: '觀察者模式 (Observer Pattern)',
                width: 280,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StockAppScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              YellowRibbonButton(
                label: '工廠模式 (Factory Pattern)',
                width: 280,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FactoryStockScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              YellowRibbonButton(
                label: '電池電量檢測',
                width: 280,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BatteryLevelWidget()),
                  );
                },
              ),
              const SizedBox(height: 16),
              YellowRibbonButton(
                label: '生命週期監聽',
                width: 280,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LifecycleAwareWidget()),
                  );
                },
              ),
              const SizedBox(height: 16),
              YellowRibbonButton(
                label: '黃絲帶按鈕示例',
                width: 280,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ButtonDemoPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              YellowRibbonButton(
                label: '學生卡片示例',
                width: 280,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CardDemoPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const BatteryLevelWidget(),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<MyHomePage2> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LifecycleAwareWidget extends StatefulWidget {
  const LifecycleAwareWidget({super.key});

  @override
  State<LifecycleAwareWidget> createState() => _LifecycleAwareWidgetState();
}

class _LifecycleAwareWidgetState extends State<LifecycleAwareWidget> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
      onDetach: () => print('App 生命週期: detached'),
      onHide: () => print('App 生命週期: hidden'),
      onInactive: () => print('App 生命週期: inactive'),
      onPause: () => print('App 生命週期: on paused'),
      onResume: () => print('App 生命週期: resumed'),
      onRestart: () => print('App 生命週期: on Restart'),
      onShow: () => print('App 生命週期: shown'),
    );
  }

  void _onStateChanged(AppLifecycleState state) {
    // print('App 生命週期狀態改變: $state');
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: const Center(
        child: Text('生命週期監聽 Widget'),
      ),
    );
  }
}

class BatteryLevelWidget extends StatefulWidget {
  const BatteryLevelWidget({super.key});

  @override
  State<BatteryLevelWidget> createState() => _BatteryLevelWidgetState();
}

class _BatteryLevelWidgetState extends State<BatteryLevelWidget> {
  int? batteryLevel;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getBattery() async {
    WidgetsFlutterBinding.ensureInitialized();
    // final level = await BatteryLevel.BatteryLevelStream();
    setState(() {
      // batteryLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '當前電池電量：',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              batteryLevel != null ? '$batteryLevel%' : '讀取中...',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            YellowRibbonButton(
              label: '點擊獲取電量',
              onPressed: () {
                _getBattery();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}


mixin WidgetMixin {

   widgetCreate() {
    print("mixn");
  }
}

mixin WidgetMixin2 {

   widgetCreate() {
    print("mixn2");
  }
}


class WidgetTest with WidgetMixin, WidgetMixin2 {

  WidgetTest();


  @override
  widgetCreate() {
    super.widgetCreate();
    print("widget");
  }

}