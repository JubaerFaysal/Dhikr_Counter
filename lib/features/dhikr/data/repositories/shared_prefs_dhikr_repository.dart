import 'package:dhikr_counter/core/services/shared_preferences_service.dart';
import 'package:dhikr_counter/features/dhikr/data/models/dhikr_model.dart';
import 'package:dhikr_counter/features/dhikr/domain/repositories/dhikr_repository.dart';

class SharedPrefsDhikrRepository implements DhikrRepository {
  SharedPrefsDhikrRepository(this._service);

  final SharedPreferencesService _service;

  @override
  DhikrModel loadState() {
    return _service.loadDhikrState();
  }

  @override
  Future<void> saveState(DhikrModel model) async {
    await _service.saveDhikrState(model);
  }
}
