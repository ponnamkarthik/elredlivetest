import 'package:flutter/material.dart';

class CurrentScreenData {
  final int? current;
  final int? parent;
  final int? completed;
  final int? total;

  CurrentScreenData({
    this.current,
    this.parent,
    this.completed,
    this.total,
  });

  CurrentScreenData copyWith({
    int? current,
    int? parent,
    int? completed,
    int? total,
  }) =>
      CurrentScreenData(
        current: current ?? this.current,
        parent: parent ?? this.parent,
        completed: completed ?? this.completed,
        total: total ?? this.total,
      );
}

class CurrentScreenProvider extends ChangeNotifier {
  CurrentScreenData state =
      CurrentScreenData(current: 0, completed: 0, parent: -1, total: 0);

  reset() {
    state = CurrentScreenData(current: 0, completed: 0, parent: -1, total: 0);
    notifyListeners();
  }

  nextQuestion() {
    state = state.copyWith(
      current: state.current! + 1,
    );
    notifyListeners();
  }

  nextChildQuestion() {
    state = state.copyWith(
      parent: state.current,
      current: state.current! + 1,
    );
    notifyListeners();
  }

  previousQuestion() {
    if(state.parent != -1) {
      state = state.copyWith(
        parent: -1,
        current: state.current! - 2,
      );
    } else {
      state = state.copyWith(
        current: state.current! - 1,
      );
    }
    print(state.current);
    notifyListeners();
  }
}
