import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

class PremiumTemplate {
  const PremiumTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.roleSeed,
    required this.headlineSeed,
    required this.aboutSeed,
  });

  final String id;
  final String title;
  final String description;
  final String roleSeed;
  final String headlineSeed;
  final String aboutSeed;
}

List<PremiumTemplate> premiumTemplates(AppLocalizations l10n) => [
      PremiumTemplate(
        id: 'executive',
        title: l10n.templateExecutive,
        description: l10n.templateExecutiveDesc,
        roleSeed: 'Chief Operating Officer | Growth & Operations',
        headlineSeed:
            'COO | Scaling \$50M+ Businesses | Board Advisor | PE-Backed Exits',
        aboutSeed:
            'I partner with founders and boards to turn operational complexity into durable growth...',
      ),
      PremiumTemplate(
        id: 'tech_leader',
        title: l10n.templateTechLeader,
        description: l10n.templateTechLeaderDesc,
        roleSeed: 'Engineering Director | Platform & Delivery',
        headlineSeed:
            'Engineering Director | Cloud & Platform | 50+ Engineers | FinTech',
        aboutSeed:
            'I build high-performing engineering organizations that ship reliably at scale...',
      ),
      PremiumTemplate(
        id: 'creator',
        title: l10n.templateCreator,
        description: l10n.templateCreatorDesc,
        roleSeed: 'Content Strategist | Personal Brand',
        headlineSeed:
            'Creator | B2B Content & Growth | 200K+ Audience | Keynote Speaker',
        aboutSeed:
            'I help professionals grow authority through story-driven content and distribution...',
      ),
      PremiumTemplate(
        id: 'career_shift',
        title: l10n.templateCareerShift,
        description: l10n.templateCareerShiftDesc,
        roleSeed: 'Product Manager | Career Transition',
        headlineSeed:
            'PM in Transition | Ex-Consultant → Product | SaaS | Open to Roles',
        aboutSeed:
            'I bring structured problem-solving from consulting into zero-to-one product work...',
      ),
    ];
