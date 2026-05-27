import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_profile_coach/models/profile_section.dart';
import 'package:linkedin_profile_coach/services/profile_evaluator_fallback.dart';

void main() {
  test('fallback scores non-empty headline higher than empty', () {
    final evaluator = ProfileEvaluatorFallback();
    final sections = [
      const ProfileSection(
        key: 'headline',
        title: 'Headline',
        description: '',
        hint: '',
        content: 'Senior Flutter Developer | FinTech | Remote | 8+ years',
      ),
      const ProfileSection(
        key: 'about',
        title: 'About',
        description: '',
        hint: '',
      ),
    ];

    final result = evaluator.evaluate(
      sections: sections,
      targetRole: 'Flutter Developer',
      targetIndustry: 'FinTech',
      resumeText: null,
    );

    expect(result.currentOverall, greaterThan(0));
    expect(result.currentBySection['headline']!.score, greaterThan(0));
    expect(result.currentBySection['about']!.score, lessThan(
      result.currentBySection['headline']!.score,
    ));
  });
}
