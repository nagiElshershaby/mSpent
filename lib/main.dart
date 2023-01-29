import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './providers/transactions.dart';

import './widgets/transView.dart';
import './widgets/addTrans.dart';
import './widgets/chart.dart';

import 'screens/availableCash.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Transactions(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'mSpent',
        theme: ThemeData(
          primaryColor: const Color(0xff9b8bd3),
          fontFamily: 'OpenSans',
          textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: const TextStyle(
                  fontFamily: 'QuickSand',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xff8bd1d3)),
        ),
        home: AnimatedSplashScreen(
          splash: ImageIcon(
            const AssetImage('assets/images/mSpent.png'),
            size: 200,
            color: Theme.of(context).primaryColor,
          ),
          duration: 1000,
          nextScreen: const MyHomePage(title: 'mSpent'),
          splashTransition: SplashTransition.fadeTransition,
          //pageTransitionType: PageTransitionType.scale,
          backgroundColor: Colors.white,
        ),
        routes: {
          'availableCash': (context) => const AvailableCash(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void startAddNewTrans(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: 700,
              child: AddTrans(
                  addTx: Provider.of<Transactions>(context).addNewTransaction),
            ),
          );
        });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.of(context);
    final isLandscape = m.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        'mSpent',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        MaterialButton(
          onPressed: () {},
          onLongPress: () {
            Navigator.of(context).pushNamed('availableCash');
          },
          child: SizedBox(
            height: 50,
            width: 200,
            //color: Colors.white,
            child: Card(
              child: Center(
                child: Text(
                  Provider.of<Transactions>(context, listen: false)
                      .total
                      .toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary), //textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )
      ],
    );
    final txListWidget = SizedBox(
      height:
          (m.size.height - appBar.preferredSize.height - m.padding.top) * 0.7,
      child: transView(
        transactions: Provider.of<Transactions>(context).userTransactions,
        deleteTx: Provider.of<Transactions>(context).deleteTrans,
      ),
    );
    final chart = SizedBox(
      height:
          (m.size.height - appBar.preferredSize.height - m.padding.top) * 0.7,
      child: Chart(
          recentTransactions:
              Provider.of<Transactions>(context).recentTransactions),
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: FutureBuilder(
          future: Provider.of<Transactions>(context).fitchAndSetTransactions(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<Transactions>(
                      builder: (context, trans, ch) => SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isLandscape)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('show Chart'),
                                  Switch.adaptive(
                                      value: _showChart,
                                      activeColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onChanged: (val) {
                                        setState(() {
                                          _showChart = val;
                                        });
                                      })
                                ],
                              ),
                            if (!isLandscape)
                              SizedBox(
                                height: (m.size.height -
                                        appBar.preferredSize.height -
                                        m.padding.top) *
                                    0.3,
                                child: Chart(
                                    recentTransactions:
                                        Provider.of<Transactions>(context)
                                            .recentTransactions),
                              ),
                            if (!isLandscape) txListWidget,
                            if (isLandscape) _showChart ? chart : txListWidget
                          ],
                        ),
                      ),
                    ),
        ),
      ),
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => startAddNewTrans(context),
              tooltip: 'Increment',
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
    );
  }
}
