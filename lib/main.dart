import 'package:elredlivetest/home_page.dart';
import 'package:elredlivetest/providers/current_screen_provider.dart';
import 'package:elredlivetest/providers/screens_data_provider.dart';
import 'package:elredlivetest/repository/api_repository.dart';
import 'package:elredlivetest/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiRepository>(
          create: (context) {
            final client = http.Client();
            final apiService = ApiService(client: http.Client());
            return ApiRepository(apiService: apiService);
          },
        ),
        ChangeNotifierProvider<CurrentScreenProvider>(create: (context) {
          return CurrentScreenProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          final ApiRepository apiRepository = context.read<ApiRepository>();
          return ScreensProvider(apiRepository);
        }),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFBAA29)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      home: const MyHomePage(),
    );
  }
}
