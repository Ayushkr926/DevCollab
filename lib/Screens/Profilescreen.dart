import 'dart:math' as math;
import 'dart:ui';

import 'package:devcollab/models/profile_model.dart';
import 'package:devcollab/presentation/memoji/home_shell.dart';
import 'package:devcollab/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:devcollab/providers/profileprovider.dart';
import 'package:devcollab/utils/AppColors.dart';
import 'package:flip_card/flip_card.dart';
import '../data/models/memoji_model.dart';
import '../widgets/Profile/demo_data_image.dart';
import '../widgets/Profile/showcasegrid.dart';
import 'Homescreen.dart';
import 'bannerscreen.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  int _navIndex = 4;

  Future<void> _openMemojiPicker(BuildContext context) async {
    // HomeShell needs to Navigator.pop(context, selectedMemoji) when the
    // user taps "Use Avatar" — see the DetailScreen note below.
    final selected = await Navigator.of(context).push<Memoji>(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
    if (selected != null && mounted) {
      context.read<ProfileProvider>().setMemoji(selected);
    }
  }

  void _openPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                // hook up image_picker here, then
                // context.read<ProfileProvider>().setProfileImage(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove photo'),
              onTap: () {
                Navigator.pop(context);
                context.read<ProfileProvider>().setProfileImage('');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Fetch profile when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  void _onNavTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _navIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
      // Add your explore/search screen
        break;
      case 2:
        _showPostSheet();
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/chat');
        break;
      case 4:
      // Already on profile
        break;
    }
  }

  void _showPostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PostBottomSheet(),
    );
  }

  Future<void> _refresh() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    await profileProvider.refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    final initials = profile.name
        .split(" ")
        .take(2)
        .map((e) => e.isNotEmpty ? e[0] : "")
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: DC.bg2,
      // extendBodyBehindAppBar: true,
      appBar: _GlassAppBar(
        name: profile.name,
        onAddTap: () {},
        onMenuTap: () {},
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner + Profile Picture
              _BannerSection(
                profile: profile,
                initials: initials,
                onEditBanner: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BannerSelectionScreen(),
                    ),
                  );
                },
                onTapPhoto: () => _openPhotoOptions(context),
                onTapMemoji: () => _openMemojiPicker(context),
              ),

              const SizedBox(height: 56),

              // Profile Info
              _ProfileInfoCard(profile: profile),

              const SizedBox(height: 24),

              // Social Links
              const _SocialLinksSection(),

              const SizedBox(height: 24),

              // Stats
              _StatsCard(profile: profile),

              const SizedBox(height: 32),

              // Skills Section
              _SkillsSection(profile: profile),

              const SizedBox(height: 32),

              // Showcase
              const _ShowcaseSection(),

              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: _navIndex, onTap: _onNavTap),
    );
  }

  Widget _buildProfileImage(String initials, ProfileProvider profile) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundImage: profile.profileImage.isNotEmpty
                ? NetworkImage(profile.profileImage)
                : null,
            child: profile.profileImage.isEmpty
                ? Text(
              initials,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
                : null,
          ),
        ),
        Positioned(
          bottom: 6,
          right: 6,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// ------------------------------------------------------------------------
/// Glass / floating AppBar
/// ------------------------------------------------------------------------
class _GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final VoidCallback onAddTap;
  final VoidCallback onMenuTap;

  const _GlassAppBar({
    required this.name,
    required this.onAddTap,
    required this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(94);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 90,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: DC.bg2.withOpacity(0.72),
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.04),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _CircleIconButton(icon: Icons.add, onTap: onAddTap),
                Expanded(
                  child: Center(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                _CircleIconButton(icon: Icons.menu_rounded, onTap: onMenuTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.6),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------------
/// Banner + avatar
/// ------------------------------------------------------------------------
class _BannerSection extends StatelessWidget {
  final ProfileProvider profile;
  final String initials;
  final VoidCallback onEditBanner;
  final VoidCallback onTapPhoto;
  final VoidCallback onTapMemoji;

  const _BannerSection({
    required this.profile,
    required this.initials,
    required this.onEditBanner,
    required this.onTapPhoto,
    required this.onTapMemoji,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                profile.bannerimage != ""
                    ? Image.network(
                  profile.bannerimage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey.shade300),
                )
                    : Image.network(
                  "https://cdn.magicdecor.in/com/2024/11/05150300/3D-Serene-Sunset-and-Mounatins-Landscape-Wallpaper-Mural.jpg",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey.shade300),
                ),
                // soft gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.06),
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
                // subtle blur strip near the edit button for readability

              ],
            ),
          ),
        ),

        // Frosted glass edit button
        Positioned(
          bottom: 14,
          right: 14,
          child: _FrostedCircleButton(
            icon: Icons.add_a_photo_outlined,
            onTap: onEditBanner,
          ),
        ),

        // Avatar overlapping banner
        Positioned(
          bottom: -48,
          left: 20,
          child: ProfileAvatarFlip(
            profileImageUrl: profile.profileImage,
            memoji: MemojiPreviewAvatar(memoji: profile.selectedMemoji, size: 96),
            initials: initials,
            isOnline: true,
            size: 96,
            onTapPhoto: onTapPhoto,
            onTapMemoji: onTapMemoji, profileImage: null,
          ),
        ),
      ],
    );
  }
}

class _FrostedCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FrostedCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withOpacity(0.22),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: const Icon(Icons.camera_alt_outlined,
                  color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------------
/// Profile info (name, role, bio, availability)
/// ------------------------------------------------------------------------
class _ProfileInfoCard extends StatelessWidget {
  final ProfileProvider profile;

  const _ProfileInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // role section
          if (profile.role.isNotEmpty) ...[
            Text(
              profile.role,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // bio section
          if (profile.bio.isNotEmpty) ...[
            Text(
              profile.bio,
              style: TextStyle(
                height: 1.6,
                fontSize: 14.5,
                color: Colors.black.withOpacity(0.72),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Availability pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Available for Projects",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------------
/// Social links
/// ------------------------------------------------------------------------
class _SocialLinksSection extends StatelessWidget {
  const _SocialLinksSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: const [
          _SocialCard(name: "GitHub", icon: FontAwesomeIcons.github),
          SizedBox(width: 12),
          _SocialCard(name: "LinkedIn", icon: FontAwesomeIcons.linkedin),
          SizedBox(width: 12),
          _SocialCard(name: "LeetCode", icon: FontAwesomeIcons.code),
        ],
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  final String name;
  final IconData icon;

  const _SocialCard({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: FaIcon(icon, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_outward_rounded,
                  size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------------
/// Stats
/// ------------------------------------------------------------------------
class _StatsCard extends StatelessWidget {
  final ProfileProvider profile;

  const _StatsCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: StatItem(
                icon: Icons.folder_copy_outlined,
                value: "${profile.projects}",
                title: "Projects",
              ),
            ),
            _buildDivider(),
            Expanded(
              child: StatItem(
                icon: Icons.groups_2_outlined,
                value: "${profile.collabs}",
                title: "Collabs",
              ),
            ),
            _buildDivider(),
            Expanded(
              child: StatItem(
                icon: Icons.visibility_outlined,
                value: "${profile.views}",
                title: "Views",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 44, width: 1, color: Colors.grey.shade200);
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;

  const StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// ------------------------------------------------------------------------
/// Skills
/// ------------------------------------------------------------------------
class _SkillsSection extends StatelessWidget {
  final ProfileProvider profile;

  const _SkillsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.workspace_premium_outlined,
                  size: 15,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Skills",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Manage",
                      style: TextStyle(
                        color: Color(0xff406ABF),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded,
                        size: 15, color: Color(0xff406ABF)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: profile.skills.map((skill) => _SkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String skill;
  const _SkillChip(this.skill);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.primary.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            skill,
            style: TextStyle(
              color: DC.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------------
/// Showcase
/// ------------------------------------------------------------------------
class _ShowcaseSection extends StatelessWidget {
  const _ShowcaseSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "My Showcase",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded,
                        size: 15, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ShowcaseGrid(images: demoImages),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------------
/// Avatar flip (flip logic unchanged — visuals only)
/// ------------------------------------------------------------------------
class ProfileAvatarFlip extends StatefulWidget {
  final String profileImageUrl;
  final Widget memoji;
  final String initials;
  final bool isOnline;
  final double size;
  final VoidCallback? onTapPhoto;
  final VoidCallback? onTapMemoji;

  const ProfileAvatarFlip({
    super.key,
    required this.profileImageUrl,
    required this.memoji,
    required this.initials,
    this.isOnline = true,
    this.size = 88,
    this.onTapPhoto,
    this.onTapMemoji, required profileImage,
  });

  @override
  State<ProfileAvatarFlip> createState() => _ProfileAvatarFlipState();
}

class _ProfileAvatarFlipState extends State<ProfileAvatarFlip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool get _hasPhoto => widget.profileImageUrl.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (!_hasPhoto) return;
    final delta = d.primaryDelta! / (widget.size * 2.0);
    _controller.value = (_controller.value + delta).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails d) {
    if (!_hasPhoto) return;
    final target = _controller.value > 0.5 ? 1.0 : 0.0;
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleTap() {
    if (!_hasPhoto) {
      widget.onTapMemoji?.call();
      return;
    }
    final showingMemoji = _controller.value > 0.5;
    showingMemoji ? widget.onTapMemoji?.call() : widget.onTapPhoto?.call();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // outer soft glow
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.18),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _handleTap,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 5),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: _hasPhoto
                  ? AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value.clamp(0.0, 1.0);
                  final angle = t * math.pi;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0018) // perspective
                      ..rotateY(angle),
                    child: angle < math.pi / 2
                        ? _photoLayer() // Front: Photo
                        : Transform(
                      // Back: Memoji (corrected orientation)
                      transform: Matrix4.rotationY(math.pi),
                      alignment: Alignment.center,
                      child: widget.memoji,
                    ),
                  );
                },
              )
                  : widget.memoji,
            ),
          ),
        ),

        // Swipe hint dots
        if (_hasPhoto)
          Positioned(
            bottom: -2,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => _PageDots(progress: _controller.value),
            ),
          ),

        // Online status with subtle ring
        Positioned(
          bottom: 6,
          right: 6,
          child: Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.isOnline ? Colors.green : Colors.grey)
                      .withOpacity(0.35),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: widget.isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _photoLayer() {
    return Image.network(
      widget.profileImageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Center(
        child: Text(
          widget.initials,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final double progress;
  const _PageDots({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(active: progress < 0.5),
        const SizedBox(width: 3),
        _dot(active: progress >= 0.5),
      ],
    );
  }

  Widget _dot({required bool active}) => Container(
    width: active ? 10 : 5,
    height: 5,
    decoration: BoxDecoration(
      color: active ? Colors.black87 : Colors.black26,
      borderRadius: BorderRadius.circular(3),
      boxShadow: const [BoxShadow(color: Colors.white, blurRadius: 1)],
    ),
  );
}

class MemojiPreviewAvatar extends StatelessWidget {
  final Memoji? memoji;
  final double size;
  const MemojiPreviewAvatar({super.key, required this.memoji, this.size = 88});

  @override
  Widget build(BuildContext context) {
    if (memoji == null) {
      return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Icon(Icons.emoji_emotions_outlined,
            size: size * 0.5, color: Colors.grey.shade500),
      );
    }
    print("profile memo is ${memoji!.imagePath}");
    return Image.asset(memoji!.imagePath, fit: BoxFit.cover);
  }
}