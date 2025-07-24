import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/constants.dart';

class SupabaseService {
  static SupabaseClient? _instance;

  static SupabaseClient get instance {
    _instance ??= Supabase.instance.client;
    return _instance!;
  }

  // static Future<void> initialize() async {
  //   await Supabase.initialize(
  //     url: Constants.supabaseUrl,
  //     anonKey: Constants.supabaseKey,
  //   );
  // }
}
