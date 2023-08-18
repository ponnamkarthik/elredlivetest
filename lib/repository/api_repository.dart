import 'package:elredlivetest/models/screens_model.dart';
import 'package:elredlivetest/services/api_services.dart';

class ApiRepository {
  final ApiService apiService;

  ApiRepository({
    required this.apiService,
  });

  Future<ScreensModel> fetchScreens() async {
    try {
      final screens = await apiService.fetchScreens();
      return screens;
    } catch(e) {
      rethrow;
    }
  }

  Future<bool> postUserData(Map<String, String> data) async {
    try {
      final res = await apiService.postUserData(data);
      return res;
    } catch(e) {
      rethrow;
    }
  }

}
