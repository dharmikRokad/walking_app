// Main app
import 'package:flutter/services.dart';
import 'package:walking_app/utils/hive_helper.dart';
import 'package:walking_app/providers/home_provider.dart';
import 'package:walking_app/providers/rive_anim_provider.dart';
import 'package:walking_app/utils/app_colors.dart';
import 'package:walking_app/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HiveHelper.instance.initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(
          create: (context) => RiveAnimProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Walking App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          indicatorColor: AppColors.brown,
          appBarTheme: const AppBarTheme(
            elevation: 5,
            shadowColor: AppColors.grey,
            backgroundColor: AppColors.lBrown,
            titleTextStyle: TextStyle(
              color: AppColors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        routes: AppRouter.instance.routes(),
        initialRoute: RouteNames.home.name,
      ),
    );
  }
}
