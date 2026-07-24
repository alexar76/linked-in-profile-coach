/// Marketplace screen — browse and purchase AI capabilities.
///
/// Filters to the "career" category by default. Shows:
/// - Credits balance
/// - Capability catalog (career-specific)
/// - Purchase history
/// - Top-up button (deep-links to browser wallet)

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../repositories/app_repository.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({
    super.key,
    required this.repo,
  });

  final AppRepository repo;

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  double _credits = 0.0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // In production, fetch credits from hub via SDK.
      // For now, read from local settings.
      _credits = await widget.repo.getMarketplaceCredits();
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.marketplaceCatalogTitle),
        actions: [
          _CreditsBadge(credits: _credits),
          const SizedBox(width: 8),
          _TopUpButton(
            onTopUp: () {
              // Deep-link to browser wallet.
              // In production: url_launcher.launchUrl('https://hub.aicom.io/pay?...');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.marketplaceTopUp)),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _buildCatalog(l10n),
    );
  }

  Widget _buildCatalog(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _PrivacyBanner(l10n: l10n),
        const SizedBox(height: 16),
        _CategoryHeader(title: l10n.marketplaceCategoryCareer),
        const SizedBox(height: 8),
        _CapabilityCard(
          title: 'ATS Rules 2026 Q2',
          seller: '@ats-maintainer',
          price: 0.10,
          description: 'Latest Workday/Greenhouse/Lever ATS keyword rules for Q2 2026.',
          teeVerified: true,
          rating: 4.8,
          onBuy: () => _buyCapability('ats-rules-2026-q2'),
        ),
        const SizedBox(height: 8),
        _CapabilityCard(
          title: 'FinTech Recruiter Signals',
          seller: '@fintech-data',
          price: 0.50,
          description: 'What fintech recruiters actually read in profiles — Q2 2026.',
          teeVerified: true,
          rating: 4.6,
          onBuy: () => _buyCapability('fintech-signals-q2'),
        ),
        const SizedBox(height: 8),
        _CapabilityCard(
          title: 'Salary Benchmark — US Tech',
          seller: '@salary-data',
          price: 0.25,
          description: 'Score-to-market-value mapping for US tech roles.',
          teeVerified: false,
          rating: 4.3,
          onBuy: () => _buyCapability('salary-bench-us'),
        ),
        const SizedBox(height: 8),
        _CapabilityCard(
          title: 'EU Locale Norms Pack',
          seller: '@eu-career',
          price: 0.10,
          description: 'EU-specific profile norms (GDPR-compliant, TEE-verified).',
          teeVerified: true,
          rating: 4.9,
          onBuy: () => _buyCapability('eu-locale-norms'),
        ),
      ],
    );
  }

  Future<void> _buyCapability(String id) async {
    if (_credits < 0.10) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient credits. Top up first.')),
        );
      }
      return;
    }

    // In production: invoke via SDK, deduct from channel.
    setState(() => _credits -= 0.10);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchased $id — \$${0.10.toStringAsFixed(2)}')),
      );
    }
  }
}

class _CreditsBadge extends StatelessWidget {
  const _CreditsBadge({required this.credits});
  final double credits;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(
        '${credits.toStringAsFixed(2)} credits',
        style: TextStyle(fontSize: 13, color: Colors.green.shade800, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _TopUpButton extends StatelessWidget {
  const _TopUpButton({required this.onTopUp});
  final VoidCallback onTopUp;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTopUp,
      icon: const Icon(Icons.add, size: 16),
      label: const Text('Top up'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.marketplacePrivacyNotice,
              style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.category_outlined, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({
    required this.title,
    required this.seller,
    required this.price,
    required this.description,
    required this.teeVerified,
    required this.rating,
    required this.onBuy,
  });

  final String title;
  final String seller;
  final double price;
  final String description;
  final bool teeVerified;
  final double rating;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      if (teeVerified) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.verified, size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 2),
                        Text('TEE', style: TextStyle(fontSize: 11, color: Colors.green.shade700)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(seller, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      const SizedBox(width: 12),
                      Icon(Icons.star, size: 12, color: Colors.amber.shade600),
                      Text(rating.toString(), style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: onBuy,
                  child: const Text('Buy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
