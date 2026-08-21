import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_profile_coach/models/ats_match_result.dart';
import 'package:linkedin_profile_coach/services/dashboard_analytics_service.dart';
import 'package:linkedin_profile_coach/services/linkedin_analytics_parser.dart';

void main() {
  test('LinkedInAnalyticsParser reads profile views CSV', () {
    const csv = 'Date,Profile Views\n'
        '2024-01-01,10\n'
        '2024-01-08,25\n'
        '2024-01-15,40\n';
    final bundle = LinkedInAnalyticsParser().parseFromCsvFiles({
      'profileviews.csv': csv,
    });
    expect(bundle.series['profile_views']?.length, 3);
    expect(bundle.latest('profile_views'), 40);
  });

  test('DashboardAnalyticsService builds completeness trend', () {
    final service = DashboardAnalyticsService();
    final result = service.build(
      DashboardAnalyticsInput(
        snapshots: const [],
        evaluations: const [],
        linkedInRecords: const [],
        importCount: 2,
        lastImportAt: DateTime(2024, 6, 1),
        recommendations: const [],
        filledSections: 12,
        totalSections: 24,
        targetRole: 'Engineer',
        ats: const AtsMatchResult(
          scorePercent: 80,
          matchedKeywords: ['flutter'],
          missingKeywords: [],
          targetRole: 'Engineer',
        ),
      ),
    );
    expect(result.completenessPercent, 50);
    expect(result.hasAtsTarget, isTrue);
  });
}
