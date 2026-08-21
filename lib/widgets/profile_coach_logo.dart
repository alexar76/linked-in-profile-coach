import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Brand mark from [assets/branding/profile_coach_icon.svg].
class ProfileCoachLogo extends StatelessWidget {
  const ProfileCoachLogo({
    super.key,
    this.size = 32,
  });

  final double size;

  static const _asset = 'assets/branding/profile_coach_icon.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
