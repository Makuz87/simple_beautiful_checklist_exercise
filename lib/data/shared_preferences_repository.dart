import 'package:shared_preferences/shared_preferences.dart';
import 'database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  static const String _key = 'checklist_items';

  late SharedPreferences _prefs;

  late final Future<void> _init;

  SharedPreferencesRepository() {
    _init = _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // TODO: Methoden implementieren (getItemCount, getItems, addItem, etc.)

  @override
  Future<List<String>> getItems() async {
    await _init;
    return _prefs.getStringList(_key) ?? [];
  }

  @override
  Future<void> addItem(String item) async {
    await _init;

    if (item.isEmpty) return;

    final items = _prefs.getStringList(_key) ?? [];

    if (!items.contains(item)) {
      items.add(item);
      await _prefs.setStringList(_key, items);
    }
  }

  @override
  Future<void> deleteItem(int index) async {
    await _init;

    final items = _prefs.getStringList(_key) ?? [];

    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await _prefs.setStringList(_key, items);
    }
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    await _init;

    if (newItem.isEmpty) return;

    final items = _prefs.getStringList(_key) ?? [];

    // prüfen, ob Index gültig und das neue Item nicht bereits in der Liste vorkommt
    if (index >= 0 && index < items.length && !items.contains(newItem)) {
      items[index] = newItem;
      await _prefs.setStringList(_key, items);
    }
  }

  @override
  Future<int> getItemCount() async {
    await _init;

    final items = _prefs.getStringList(_key) ?? [];
    return items.length;
  }
}
