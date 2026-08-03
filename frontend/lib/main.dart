import 'package:flutter/material.dart';
import 'package:frontend/config_handler.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/tabs/analytics_tab.dart';
import 'package:frontend/tabs/nodes_tab.dart';
import 'package:frontend/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  final nodeProvider = NodeProvider();

  NodesConfigHandler().applyNodeConfiguration();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => nodeProvider),
      ],
      child: const PenGUIn()
    ),
  );
}

class PenGUIn extends StatelessWidget {
  const PenGUIn({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme();

    // Apply the configuration
    loadConfig(context);

    return MaterialApp(
      title: 'PenGUIn',
      // Define the color theme of the frontend
      theme: PenGUInTheme(textTheme).theme(PenGUInTheme.lightScheme()),
      darkTheme: PenGUInTheme(textTheme).theme(PenGUInTheme.darkScheme()),
      highContrastTheme: PenGUInTheme(textTheme).theme(PenGUInTheme.lightHighContrastScheme()),
      highContrastDarkTheme: PenGUInTheme(textTheme).theme(PenGUInTheme.darkHighContrastScheme()),
      home: const MyHomePage(),
    );
  }

  void loadConfig(BuildContext context) async {
    context.read<NodeProvider>().updateNodeList(await NodesConfigHandler().applyNodeConfiguration());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: const [
              Tab(
                icon: Icon(Icons.code_outlined),
                text: "Nodes"
              ),
              Tab(
                icon: Icon(Icons.analytics_outlined),
                text: "Analytics"
              ),
            ],
            // Apply the configuration
            onTap: (index) async {
              if (index == 1) {
                 context.read<NodeProvider>().updateNodeList(await NodesConfigHandler().applyNodeConfiguration());
              }
            },
          ),
        ),
        body: const TabBarView(
          children: [
            NodesTab(),
            AnalyticsTab(),
          ],
        ),
      ),
    );
  }
}
