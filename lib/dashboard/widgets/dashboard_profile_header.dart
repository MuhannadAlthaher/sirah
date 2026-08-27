import 'package:flutter/material.dart';
import 'package:sira/data/demo_data.dart';
import 'package:sira/widget/position_badge.dart';
import 'package:sira/widget/profile_avatar.dart';

/// The dashboard's top section: profile picture, name, and a badge
/// showing the user's position — all sized off [width] so it scales
/// with the screen instead of relying on fixed pixel values.
class DashboardProfileHeader extends StatelessWidget {
  const DashboardProfileHeader({
    super.key,
    required this.user,
    required this.width,
  });

  final DemoUser user;
  final double width;

  @override
  Widget build(BuildContext context) {
    final avatarSize = width * 0.16;
    final gap = width * 0.04;

    return Row(
      children: [
        ProfileAvatar(name: user.name, size: avatarSize),
        SizedBox(width: gap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: gap * 0.3),
              PositionBadge(position: user.position, width: width),
            ],
          ),
        ),
      ],
    );
  }
}
