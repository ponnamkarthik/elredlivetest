// To parse this JSON data, do
//
//     final screensModel = screensModelFromJson(jsonString);

import 'dart:convert';

ScreensModel screensModelFromJson(String str) => ScreensModel.fromJson(json.decode(str));

String screensModelToJson(ScreensModel data) => json.encode(data.toJson());

class ScreensModel {
  final List<Screen>? screens;

  ScreensModel({
    this.screens,
  });

  ScreensModel copyWith({
    List<Screen>? screens,
  }) =>
      ScreensModel(
        screens: screens ?? this.screens,
      );

  factory ScreensModel.fromJson(Map<String, dynamic> json) => ScreensModel(
    screens: json["screens"] == null ? [] : List<Screen>.from(json["screens"]!.map((x) => Screen.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "screens": screens == null ? [] : List<dynamic>.from(screens!.map((x) => x.toJson())),
  };
}

class ChildScreen {
  final List<Screen>? frontend;
  final List<Screen>? backend;
  final List<Screen>? designer;

  ChildScreen({
    this.frontend,
    this.backend,
    this.designer,
  });

  ChildScreen copyWith({
    List<Screen>? frontend,
    List<Screen>? backend,
    List<Screen>? designer,
  }) =>
      ChildScreen(
        frontend: frontend ?? this.frontend,
        backend: backend ?? this.backend,
        designer: designer ?? this.designer,
      );

  factory ChildScreen.fromJson(Map<String, dynamic> json) => ChildScreen(
    frontend: json["frontend"] == null ? [] : List<Screen>.from(json["frontend"]!.map((x) => Screen.fromJson(x))),
    backend: json["backend"] == null ? [] : List<Screen>.from(json["backend"]!.map((x) => Screen.fromJson(x))),
    designer: json["designer"] == null ? [] : List<Screen>.from(json["designer"]!.map((x) => Screen.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "frontend": frontend == null ? [] : List<dynamic>.from(frontend!.map((x) => x.toJson())),
    "backend": backend == null ? [] : List<dynamic>.from(backend!.map((x) => x.toJson())),
    "designer": designer == null ? [] : List<dynamic>.from(designer!.map((x) => x.toJson())),
  };
}

class Screen {
  final String? screenName;
  final String? heading;
  final String? question;
  final String? hintText;
  final List<String>? fields;
  final List<Option>? options;
  dynamic ans;
  final Map<String, List<Screen>>? childScreen;

  Screen({
    this.screenName,
    this.heading,
    this.question,
    this.hintText,
    this.fields,
    this.options,
    this.ans,
    this.childScreen,
  });

  Screen copyWith({
    String? screenName,
    String? heading,
    String? question,
    String? hintText,
    List<String>? fields,
    List<Option>? options,
    dynamic ans,
    Map<String, List<Screen>>? childScreen,
  }) =>
      Screen(
        screenName: screenName ?? this.screenName,
        heading: heading ?? this.heading,
        question: question ?? this.question,
        hintText: hintText ?? this.hintText,
        fields: fields ?? this.fields,
        options: options ?? this.options,
        ans: ans ?? this.ans,
        childScreen: childScreen ?? this.childScreen,
      );

  factory Screen.fromJson(Map<String, dynamic> json){
    Map<String, List<Screen>> children = {};
    if(json["child_screen"] != null) {
      json["child_screen"] .forEach((key, value) {
        children[key] = List<Screen>.from(value.map((x) => Screen.fromJson(x)));
      });
    }
    return Screen(
      screenName: json["screen_name"],
      heading: json["heading"],
      question: json["question"],
      hintText: json["hint_text"],
      fields: json["fields"] == null ? [] : List<String>.from(json["fields"]!.map((x) => x)),
      options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
      ans: json["ans"],
      childScreen: json["child_screen"] == null ? null : children,
    );
  }

  Map<String, dynamic> toJson() => {
    "screen_name": screenName,
    "heading": heading,
    "question": question,
    "hint_text": hintText,
    "fields": fields == null ? [] : List<dynamic>.from(fields!.map((x) => x)),
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
    "ans": ans,
    // "child_screen": childScreen?.toJson(),
  };
}

class Option {
  final String? text;
  final String? value;
  final String? key;

  Option({
    this.text,
    this.value,
    this.key,
  });

  Option copyWith({
    String? text,
    String? value,
    String? key,
  }) =>
      Option(
        text: text ?? this.text,
        value: value ?? this.value,
        key: key ?? this.key,
      );

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    text: json["text"],
    value: json["value"],
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
    "key": key,
  };
}
