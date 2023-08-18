import 'package:elredlivetest/common/app_date_field.dart';
import 'package:elredlivetest/common/app_radio_field.dart';
import 'package:elredlivetest/common/app_text_field.dart';
import 'package:elredlivetest/models/screens_model.dart';
import 'package:elredlivetest/providers/current_screen_provider.dart';
import 'package:elredlivetest/providers/screens_data_provider.dart';
import 'package:elredlivetest/screens/confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreenPage extends StatefulWidget {
  const BaseScreenPage({super.key});

  @override
  State<BaseScreenPage> createState() => _BaseScreenPageState();
}

class _BaseScreenPageState extends State<BaseScreenPage> {
  bool isInputValid = false;

  @override
  Widget build(BuildContext context) {
    final screensState = context.watch<ScreensProvider>().state;
    final currentScreenProvider = context.watch<CurrentScreenProvider>();
    final currentScreen = currentScreenProvider.state;

    bool isLastQuestion = false;

    late Screen screen;
    if (currentScreen.parent != -1) {
      final parent = screensState.screens!.screens![currentScreen.parent!];
      // print(parent.toJson());
      if(parent.ans != null) {
        screen = screensState.screens!.screens![currentScreen.parent!]
            .childScreen![parent.ans]![0];
      }
    } else {
      screen = screensState.screens!.screens![currentScreen.current!];
    }

    if ((currentScreen.parent == screensState.screens!.screens!.length - 1 ||
            currentScreen.current ==
                screensState.screens!.screens!.length - 1) &&
        screen.childScreen == null) {
      isLastQuestion = true;
    } else {
      isLastQuestion = false;
    }

    if (screen.ans != null && screen.ans.toString().isNotEmpty) {
      validateAnswer(screen.ans, screen.fields![0]);
    }

    // print(currentScreen.current);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: (currentScreen.current ?? 0) == 0
            ? null : IconButton(
                icon: Icon(Icons.keyboard_arrow_left_rounded),
                onPressed: () {
                  if ((currentScreen.current ?? 0) > 0) {
                    currentScreenProvider.previousQuestion();
                  }
                  Navigator.of(context).pop();
                },
              ),
        title: const Text(
          "Gamification",
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
                  Text(
                    screen.heading ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Color(0xFFFBAA29),
                      value: (isInputValid
                              ? (currentScreen.current! + 1)
                              : currentScreen.current!) /
                          screensState.screensCount,
                      minHeight: 8,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  // Bar
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                            if(currentScreen.current! > 0)
                              generateQuestionCompletedText(),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              screen.question ?? "",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            ..._buildFields(screen),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return const Color(0x80FBAA29);
                              }
                              return const Color(0xFFFBAA29);
                            },
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: !isInputValid
                            ? null
                            : () {
                                if (isLastQuestion) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ConfirmScreen(),
                                    ),
                                  );
                                } else {
                                  if (screen.childScreen != null) {
                                    currentScreenProvider.nextChildQuestion();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BaseScreenPage(),
                                      ),
                                    );
                                  } else {
                                    currentScreenProvider.nextQuestion();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BaseScreenPage(),
                                      ),
                                    );
                                  }
                                }
                              },
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFields(Screen screen) {
    List<Widget> widgets = [];

    for (String field in screen.fields!) {
      if (field == "textfield") {
        widgets.add(
          AppTextField(
            hintText: screen.hintText ?? "",
            initialValue: screen.ans,
            onChanged: (value) {
              setAnswer(value);
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                validateAnswer(value, field);
              });
            },
            onValid: (value) {},
          ),
        );
      } else if (field == "radio") {
        widgets.add(
          AppRadioField(
            options: screen.options ?? [],
            group: screen.ans ?? "",
            onChanged: (value) {
              validateAnswer(value, field);
              setAnswer(value);
            },
          ),
        );
      } else if (field == "datefield") {
        widgets.add(
          AppDateField(
            hintText: screen.hintText ?? "",
            currentDate: screen.ans,
            onChanged: (value) {
              validateAnswer(value, field);

              setAnswer(value);
            },
          ),
        );
      }
    }

    return widgets;
  }

  Widget generateQuestionCompletedText() {
    final screenState = context.read<ScreensProvider>().state;
    final screenData = context.read<CurrentScreenProvider>().state;

    List<TextSpan> spans = [];
    if(screenData.parent! != -1) {
      final s = screenState.screens!.screens![screenData.parent!];
      spans.add(TextSpan(
        text: "${s.question} ",
      ));
      for(final o in s.options!) {
        if(o.value == s.ans) {
          spans.add(TextSpan(
              text: "${o.text} ",
              style: const TextStyle(
                decoration: TextDecoration.underline,
              )));
        }
      }
    } else {
      for (int i = 0; i < screenData.current!; i++) {
        final s = screenState.screens!.screens![i];
        spans.add(TextSpan(
          text: "${s.question} ",
        ));
        spans.add(TextSpan(
            text: "${s.ans} ",
            style: const TextStyle(
              decoration: TextDecoration.underline,
            )));
      }
    }
    
    return Text.rich(
      TextSpan(
        children: spans,
      ),
      style: TextStyle(
        fontSize: 20,
      ),
    );

  }

  void validateAnswer(String value, String type) {
    bool isValid = false;
    if (type == "radio" || type == "datefield") {
      if (value == null || value.isEmpty) {
        isValid = false;
      } else {
        isValid = true;
      }
    }
    if (type == "textfield") {
      if (value == null || value.length < 2 || value.length > 60) {
        isValid = false;
      } else {
        isValid = true;
      }
    }
    setState(() {
      isInputValid = isValid;
    });
  }

  void setAnswer(String value) {
    final currentScreen = context.read<CurrentScreenProvider>().state;

    context.read<ScreensProvider>().updateAnswer(
          currentScreen.parent,
          currentScreen.current!,
          value,
        );
  }
}
