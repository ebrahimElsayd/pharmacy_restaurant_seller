import 'package:fpdart/fpdart.dart';

import '../entitise/dashboard_stats.dart';
import '../repo/dashboard_repo.dart';

class GetDashboardStats {
  final DashboardRepository repository;

  GetDashboardStats(this.repository);

  Future<Either<Exception, DashboardStats>> call() async {
    try {
      // ✅ إذا كان repository يرجع Either مباشرة (غير async)
      final result = repository.getDashboardStats(); // بدون await
      return result;
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}