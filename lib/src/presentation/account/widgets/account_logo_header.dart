import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mind_metric/src/presentation/account/account_theme.dart';

class AccountLogoHeader extends StatelessWidget {
  const AccountLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Center(
        child: CachedNetworkImage(
          imageUrl: AccountThemeColors.logoUrl,
          width: 150,
          height: 40,
          fit: BoxFit.contain,
          placeholder: (_, __) => const SizedBox(
            width: 150,
            height: 40,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AccountThemeColors.accent,
                ),
              ),
            ),
          ),
          errorWidget: (_, __, ___) => const Icon(
            Icons.image_not_supported_outlined,
            color: AccountThemeColors.muted,
            size: 40,
          ),
        ),
      ),
    );
  }
}
