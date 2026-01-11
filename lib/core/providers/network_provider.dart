import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../network/network_info.dart';

final internetConnectionProvider = Provider((ref) => InternetConnection());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final internetConnection = ref.read(internetConnectionProvider);
  return NetworkInfoImpl(internetConnection);
});
