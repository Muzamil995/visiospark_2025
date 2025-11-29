import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final UserModel? user;
  final String? imageUrl;
  final String? name;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.user,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final url = user?.avatarUrl ?? imageUrl;
    final displayName = user?.displayName ?? name ?? 'U';
    final initials = user?.initials ?? displayName[0].toUpperCase();

    Widget avatar;

    if (url != null && url.isNotEmpty) {
      avatar = CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: size / 2,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => _buildPlaceholder(initials),
        errorWidget: (context, url, error) => _buildPlaceholder(initials),
      );
    } else {
      avatar = _buildPlaceholder(initials);
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }
    return avatar;
  }

  Widget _buildPlaceholder(String initials) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final Widget? trailing;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: UserAvatar(user: user),
        title: Text(user.displayName),
        subtitle: Text(user.email),
        trailing: trailing,
      ),
    );
  }
}

class UserListTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showEmail;

  const UserListTile({
    super.key,
    required this.user,
    this.onTap,
    this.trailing,
    this.showEmail = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: UserAvatar(user: user),
      title: Text(user.displayName),
      subtitle: showEmail ? Text(user.email) : null,
      trailing: trailing,
    );
  }
}
