import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/models/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedNewsListNotifier extends StateNotifier<List<News>> {
  final SharedPreferences? _prefs;

  SavedNewsListNotifier(this._prefs)
      : super(_prefs
                ?.getStringList('saved_news')!
                .map((e) => News.fromJson(e))
                .toList() ??
            []);

  void toggleSaved(News news) {
    final index = state.indexWhere((element) => element.url == news.url);
    if (index != -1) {
      news.savedAt = null;
      state = List.from(state)..removeAt(index);
    } else {
      news.savedAt = DateTime.now();
      state = [...state, news];
    }

    _prefs?.setStringList('saved_news', state.map((e) => e.toJson()).toList());
  }
}

final sharedPrefsProvider = FutureProvider((ref) {
  return SharedPreferences.getInstance();
});

final savedNewsListProvider =
    StateNotifierProvider<SavedNewsListNotifier, List<News>>((ref) {
  final prefs = ref.watch(sharedPrefsProvider).maybeWhen(
        data: (value) => value,
        orElse: () => null,
      );
  return SavedNewsListNotifier(prefs);
});
