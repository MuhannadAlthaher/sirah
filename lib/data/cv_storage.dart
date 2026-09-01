import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/data/demo_data.dart';

/// Persists "My CVs" and the in-progress draft (if any) to on-device
/// storage, so both survive an app restart — this app has no backend,
/// so [SharedPreferences] (a JSON blob under one key) is enough; there's
/// no multi-user or cross-device sync need to justify a real database.
abstract final class CvStorage {
  static const _cvsKey = 'saved_cvs_v1';
  static const _draftKey = 'cv_draft_v1';

  static Future<List<DemoCv>> loadCvs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cvsKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => DemoCv.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return [];
    }
  }

  static Future<void> saveCvs(List<DemoCv> cvs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cvsKey,
      jsonEncode(cvs.map((cv) => cv.toJson()).toList()),
    );
  }

  static Future<CvBuilderState?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null) return null;
    try {
      return CvBuilderState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    }
  }

  /// Pass `null` to clear the stored draft (resumed or discarded).
  static Future<void> saveDraft(CvBuilderState? draft) async {
    final prefs = await SharedPreferences.getInstance();
    if (draft == null) {
      await prefs.remove(_draftKey);
    } else {
      await prefs.setString(_draftKey, jsonEncode(draft.toJson()));
    }
  }
}
