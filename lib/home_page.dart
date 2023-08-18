import 'package:elredlivetest/providers/screens_data_provider.dart';
import 'package:elredlivetest/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void screenStateListener() {
    final state = context.read<ScreensProvider>().state;
    if (state.status == ScreensStatus.completed) {
      context.read<ScreensProvider>().removeListener(screenStateListener);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BaseScreenPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ScreensProvider>().fetchScreens();
    });

    // context.read<ScreensProvider>().addListener(screenStateListener);
  }

  @override
  void dispose() {
    // context.read<ScreensProvider>().removeListener(screenStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Gamification",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildBody(BuildContext context) {
    final screensState = context.watch<ScreensProvider>().state;
    print(screensState.status);
    if (screensState.status == ScreensStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => BaseScreenPage(),
          ),
          (route) => false,
        );
      });
    }
    if (screensState.status == ScreensStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (screensState.status == ScreensStatus.error) {
      return Center(
        child: Text(
          screensState.error,
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    return SizedBox();
  }
}
