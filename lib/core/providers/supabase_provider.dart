import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((ref) {
  return Supabase.instance.client;
});

final supabaseAuthProvider = Provider((ref) {
  return ref.read(supabaseProvider).auth;
});

final supabaseStorageProvider = Provider((ref) {
  return ref.read(supabaseProvider).storage;
});

final authStateProvider = StreamProvider((ref) {
  return ref.read(supabaseAuthProvider).onAuthStateChange;
});

final currentUserProvider = Provider((ref) {
  return ref.read(supabaseAuthProvider).currentUser;
});