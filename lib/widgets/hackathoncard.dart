import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils/app_theme.dart';
import '../../utils/AppColors.dart';
import '../Screens/hackathondetailsscreen.dart';
import '../models/Hackathinmodel.dart' show Hackathon;

class Hackcard extends StatelessWidget {
  final Hackathon hackathon;
  final VoidCallback onBookmark;
  final VoidCallback onRegister;

  const Hackcard({
    super.key,
    required this.hackathon,
    required this.onBookmark,
    required this.onRegister,
  });

  // Inside Hackcard widget
  Widget _buildCountdown(Hackathon hack) {
    if (!hack.isUpcoming) return const SizedBox();

    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final difference = hack.hackathonStart.difference(now);

        if (difference.isNegative) return const SizedBox();

        final days = difference.inDays;
        final hours = difference.inHours % 24;
        final minutes = difference.inMinutes % 60;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer, size: 16, color: Colors.red),
              const SizedBox(width: 6),
              Text(
                "$days d ${hours}h ${minutes}m",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUpcoming = hackathon.hackathonStart.isAfter(DateTime.now());
    final isOngoing = hackathon.hackathonStart.isBefore(DateTime.now()) &&
        hackathon.hackathonEnd.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  hackathon.bannerImage,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                ),
              ),

              // Online / Offline Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: hackathon.isOnline ? Colors.blue.withOpacity(0.9) : Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hackathon.isOnline ? "🌐 Online" : "📍 Offline",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Bookmark Button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onBookmark,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
                      ],
                    ),
                    child: Icon(
                      hackathon.bookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: hackathon.bookmarked ? DC.p : Colors.grey[700],
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Organizer
                Row(
                  children: [
                    Text(
                      hackathon.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    _buildCountdown(hackathon)
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "by ${hackathon.organizer}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                // Tagline
                Text(
                  hackathon.tagline,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14.5,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 16),

                // Date & Prize Row
                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        icon: Icons.calendar_today,
                        title: isOngoing ? "Ongoing" : "Starts",
                        value: timeago.format(hackathon.hackathonStart, allowFromNow: true),
                      ),
                    ),
                    Expanded(
                      child: _infoRow(
                        icon: Icons.emoji_events,
                        title: "Prize Pool",
                        value: hackathon.totalPrizePool,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Themes / Technologies
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hackathon.themes.take(3).map((theme) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        theme,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HackathonDetailScreen(hackathon: hackathon),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: DC.p),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("View Details"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: hackathon.registrationOpen ? onRegister : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DC.p,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          hackathon.registrationOpen ? "Register Now" : "Closed",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}