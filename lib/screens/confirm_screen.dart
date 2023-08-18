import 'package:elredlivetest/providers/current_screen_provider.dart';
import 'package:elredlivetest/providers/screens_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_screen.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  void openSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Center(
                    child: Text(
                      "Success 🎉",
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openFailedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                 Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Failed 🚫",
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                        SizedBox(height: 12,),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void screenProviderListener() {
    final state = context
        .read<ScreensProvider>()
        .state;
    if (state.status == ScreensStatus.completed) {
      openSuccessDialog();
    }
    if (state.status == ScreensStatus.error) {
      openFailedDialog(state.error);
    }

  }

  @override
  void initState() {
    super.initState();

    context.read<ScreensProvider>().addListener(screenProviderListener);
  }

  @override
  void dispose() {
    context.read<ScreensProvider>().removeListener(screenProviderListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screensState = context
        .watch<ScreensProvider>()
        .state;
    final currentScreenProvider = context.read<CurrentScreenProvider>();
    final currentScreen = currentScreenProvider.state;

    final name = screensState.screens!.screens![0].ans;
    final gender = screensState.screens!.screens![1].ans;
    final dob = screensState.screens!.screens![2].ans;
    final multi = screensState.screens!.screens![3];
    final des = multi.ans;
    String iDo = "";

    for (final op in multi.options!) {
      if (op.value == des) {
        iDo = op.text ?? "";
      }
    }
    final work = multi.childScreen![des]![0].ans;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: (currentScreen.current ?? 0) > 0
            ? IconButton(
          icon: Icon(Icons.keyboard_arrow_left_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
            : null,
        title: const Text(
          "Profile Summary",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Text.rich(
                      TextSpan(text: "Hi, ", children: [
                        TextSpan(
                            text: name,
                            style: TextStyle(
                              color: Color(0xFFFBAA29),
                            ))
                      ]),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "You did it 🎉",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // Bar
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Please review your answers below and do change if any or confirm and continue.",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "My personal details 🙂",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text.rich(
                              TextSpan(
                                text: "My Name is ",
                                children: [
                                  TextSpan(
                                    text: name,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " I am ",
                                  ),
                                  TextSpan(
                                    text: gender,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " born on ",
                                  ),
                                  TextSpan(
                                    text: dob,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "How I keep busy 💻",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text.rich(
                              TextSpan(
                                text: "I am ",
                                children: [
                                  TextSpan(
                                    text: iDo,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " and I develop ",
                                  ),
                                  TextSpan(
                                    text: work,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        child: Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return const Color(0x80FBAA29);
                                    }
                                    return const Color(0xFFFBAA29);
                                  },
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              onPressed:
                              screensState.status == ScreensStatus.loading
                                  ? null
                                  :  () {
                                context.read<ScreensProvider>().resetStateAnsData();
                                context.read<CurrentScreenProvider>().reset();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context){
                                  return const BaseScreenPage();
                                }), (route) => false);
                              },
                              child: const Icon(
                                Icons.cached_rounded,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return const Color(0x80FBAA29);
                                      }
                                      return const Color(0xFFFBAA29);
                                    },
                                  ),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed:
                                screensState.status == ScreensStatus.loading
                                    ? null
                                    : () {
                                  final data = <String, String>{
                                    "name": name,
                                    "gender": gender,
                                    "dob": dob,
                                    "profession": des,
                                    "skills": work,
                                  };
                                  context.read<ScreensProvider>().postUser(data);
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
