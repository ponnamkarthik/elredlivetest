import 'package:elredlivetest/models/screens_model.dart';
import 'package:elredlivetest/repository/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ScreensStatus {
  initial,
  loading,
  completed,
  error,
}

class ScreensState {
  final ScreensStatus status;
  final ScreensModel? screens;
  final String error;
  final int screensCount;

  ScreensState({
    this.status = ScreensStatus.initial,
    this.screens,
    this.error = "",
    this.screensCount = 0,
  });

  ScreensState copyWith({
    ScreensStatus? status,
    ScreensModel? screens,
    String? error,
    int? screensCount,
  }) {
    return ScreensState(
      status: status ?? this.status,
      screens: screens ?? this.screens,
      error: error ?? this.error,
      screensCount: screensCount ?? this.screensCount,
    );
  }
}

class ScreensProvider extends ChangeNotifier {
  final ApiRepository apiRepository;

  ScreensProvider(this.apiRepository);

  ScreensState _state = ScreensState();

  ScreensState get state => _state;

  fetchScreens() async {
    _state = _state.copyWith(
      status: ScreensStatus.loading,
    );
    notifyListeners();
    try {
      final screens = await apiRepository.fetchScreens();
      _state = _state.copyWith(
        screens: screens,
        status: ScreensStatus.completed,
      );
      calculateTotalPages();
    } catch (err) {
      _state = _state.copyWith(
        status: ScreensStatus.error,
        error: err.toString(),
      );
    }
    notifyListeners();
  }

  calculateTotalPages() {
    int totalScreens = 0;

    if (state.screens != null) {
      totalScreens += state.screens!.screens!.length;

      for (final screen in state.screens!.screens!) {
        if (screen.childScreen != null) {
          totalScreens += 1;
        }
      }
    }
    _state = _state.copyWith(
      screensCount: totalScreens,
    );
    notifyListeners();
  }

  updateAnswer(int? parent, int child, String ans) {
    final screens = _state.screens;
    if(parent != null && parent != -1) {
      screens!.screens![parent].childScreen![screens!.screens![parent].ans]![0].ans = ans;
      // screens!.screens![parent].childScreen.ans = ans;
    } else {
      screens!.screens![child].ans = ans;
    }
    _state = _state.copyWith(
      screens: screens,
    );
    notifyListeners();
  }

  resetStateAnsData() {
    final screens = _state.screens;
    for (final screen in screens!.screens!) {
      screen.ans = null;
      if(screen.childScreen != null) {
        for (final childScreen in screen.childScreen!.values.first) {
          childScreen.ans = null;
        }
      }
    }
    _state = _state.copyWith(
      screens: screens,
    );
    notifyListeners();
  }

  postUser(Map<String, String> data) async {
    _state = _state.copyWith(
      status: ScreensStatus.loading,
    );
    notifyListeners();
    try {
      final status = await apiRepository.postUserData(data);
      if(status == true) {
        _state = _state.copyWith(
          status: ScreensStatus.completed,
        );
      } else {
        _state = _state.copyWith(
          status: ScreensStatus.error,
        );
      }
    } catch (err) {
      _state = _state.copyWith(
        status: ScreensStatus.error,
        error: err.toString(),
      );
    }
    notifyListeners();
  }
}
