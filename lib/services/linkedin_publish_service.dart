import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/linkedin_publish.dart';
import '../models/profile_section.dart';

class LinkedInPublishService {
  Future<void> copySectionText(ProfileSection section, {bool useAi = true}) async {
    final text = useAi && section.hasAiContent
        ? section.aiContent
        : section.content;
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<bool> openEditPage(String sectionKey) async {
    final info = publishInfoFor(sectionKey);
    final uri = Uri.parse(info.editUrl);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
