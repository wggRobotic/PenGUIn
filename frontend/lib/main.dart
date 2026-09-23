import 'package:flutter/material.dart';
import 'package:frontend/storage/config_handler.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/tabs/analytics_tab.dart';
import 'package:frontend/tabs/controls_tab.dart';
import 'package:frontend/tabs/nodes_tab.dart';
import 'package:frontend/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  final nodeProvider = NodeProvider();
  final topicInformationProvider = TopicInformationProvider();
  final serviceInformationProvider = ServiceInformationProvider();
  final actionInformationProvider = ActionInformationProvider();
  final analyticsProvider = AnalyticsProvider();
  final steeringProvider = SteeringProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => nodeProvider),
        ChangeNotifierProvider(create: (_) => topicInformationProvider),
        ChangeNotifierProvider(create: (_) => serviceInformationProvider),
        ChangeNotifierProvider(create: (_) => actionInformationProvider),
        ChangeNotifierProvider(create: (_) => analyticsProvider),
        ChangeNotifierProvider(create: (_) => steeringProvider)
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

  
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // Apply the configuration
    loadConfig(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryContainer,
          title: TabBar(
            labelColor: theme.onPrimaryContainer,
            unselectedLabelColor: theme.surface,
            tabs: const [
              Tab(
                icon: Icon(Icons.code_outlined),
                text: "Nodes"
              ),
              Tab(
                icon: Icon(Icons.analytics_outlined),
                text: "Analytics"
              ),
              Tab(
                icon: Icon(Icons.control_camera_outlined),
                text: "Controls"
              )
            ],
            // Apply the configuration and filter attributes
            onTap: (index) async {
              switch (index) {
                case 0:
                  context.read<NodeProvider>().updateNodeList(await NodesConfigHandler().applyNodeConfiguration(context));
                  break;
                case 1:
                  context.read<AnalyticsProvider>().updateAnalyticsData(await NodesConfigHandler().applyAnalyticsConfiguration(context));
                  if (!context.mounted) return;
                  context.read<AnalyticsProvider>().updateFilterAttributes();
                case 2:
                  // TODO:
                  await NodesConfigHandler().applySteeringConfiguration(context);
              }
            },
          ),
        ),
        body: const TabBarView(
          children: [
            NodesTab(),
            AnalyticsTab(),
            ControlsTab(),
          ],
        ),
      ),
    );
  }

  void loadConfig(BuildContext context) async {
    // Load the config
    if (!context.mounted) return;
    context.read<NodeProvider>().updateNodeList(await NodesConfigHandler().applyNodeConfiguration(context));
    if (!context.mounted) return;
    context.read<AnalyticsProvider>().updateAnalyticsData(await NodesConfigHandler().applyAnalyticsConfiguration(context));
    if (!context.mounted) return;
    await NodesConfigHandler().applySteeringConfiguration(context);

    // Update the filter attributes
    if(!context.mounted) return;
    context.read<AnalyticsProvider>().updateFilterAttributes();
  }
}
