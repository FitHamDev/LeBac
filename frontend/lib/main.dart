import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ViewModel/settings_viewmodel.dart';
import 'package:frontend/pages/start_page.dart';
import 'package:frontend/ViewModel/home_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProxyProvider<SettingsViewModel, HomeViewModel>(
          create: (context) => HomeViewModel(Provider.of<SettingsViewModel>(context, listen: false)),
          update: (context, settings, previous) => previous ?? HomeViewModel(settings),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BossieLeBac',
        home: const StartPage(),
      ),
    );
  }
}
