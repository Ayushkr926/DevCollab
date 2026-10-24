import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/Hackathinmodel.dart';

import '../providers/hackathonprovider.dart';
import '../utils/app_theme.dart';
import '../utils/AppColors.dart';

class HackathonDetailScreen extends StatefulWidget {
  final Hackathon hackathon;

  const HackathonDetailScreen({super.key, required this.hackathon});

  @override
  State<HackathonDetailScreen> createState() => _HackathonDetailScreenState();
}

class _HackathonDetailScreenState extends State<HackathonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final hack = widget.hackathon;
    final isUpcoming = hack.isUpcoming;

    return Scaffold(
      backgroundColor: DC.bg1,
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: DC.bg1,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    hack.bannerImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  hack.bookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  Provider.of<HackathonProvider>(context, listen: false)
                      .toggleBookmark(hack.id);
                  setState(() {});
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hack.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(" ${hack.rating}", style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                  Text("by ${hack.organizer}", style: TextStyle(color: Colors.grey[600], fontSize: 16)),

                  const SizedBox(height: 12),

                  // Status & Countdown
                  Row(
                    children: [
                      _buildStatusChip(hack),
                      const SizedBox(width: 12),
                      if (isUpcoming) _buildCountdown(hack),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Key Info Cards
                  Row(
                    children: [
                      _buildInfoCard(Icons.calendar_today, "Date", "${hack.hackathonStart.day}/${hack.hackathonStart.month} - ${hack.hackathonEnd.day}/${hack.hackathonEnd.month}"),
                      const SizedBox(width: 12),
                      _buildInfoCard(Icons.emoji_events, "Prize", hack.totalPrizePool),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _buildInfoCard(Icons.location_on, "Mode", hack.isOnline ? "Online" : hack.city),
                      const SizedBox(width: 12),
                      _buildInfoCard(Icons.people, "Team", "${hack.minTeamSize}-${hack.maxTeamSize} members"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text("About", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(hack.description, style: const TextStyle(fontSize: 15.5, height: 1.5)),

                  const SizedBox(height: 28),

                  // Themes
                  const Text("Themes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: hack.themes.map((theme) => Chip(
                      label: Text(theme),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      labelStyle: TextStyle(color: AppColors.primary),
                    )).toList(),
                  ),

                  const SizedBox(height: 28),

                  // Prizes
                  if (hack.prizes.isNotEmpty) ...[
                    const Text("Prizes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...hack.prizes.map((prize) => ListTile(
                      leading: const Icon(Icons.workspace_premium, color: Colors.amber),
                      title: Text(prize.position),
                      subtitle: Text(prize.description),
                      trailing: Text(prize.amount, style: const TextStyle(fontWeight: FontWeight.bold)),
                    )),
                  ],

                  const SizedBox(height: 28),

                  // Registration Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: hack.registrationOpen
                          ? () {
                        Provider.of<HackathonProvider>(context, listen: false)
                            .registerForHackathon(hack.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Registration Successful!")),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DC.bg0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        hack.registrationOpen ? "Register Now" : "Registration Closed",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(Hackathon hack) {
    Color color = Colors.green;
    String text = "Upcoming";

    if (hack.isOngoing) {
      color = Colors.orange;
      text = "Ongoing";
    } else if (hack.isPast) {
      color = Colors.grey;
      text = "Completed";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: DC.bg0),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdown(Hackathon hack) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final diff = hack.hackathonStart.difference(now);

        if (diff.isNegative) return const SizedBox();

        final days = diff.inDays;
        final hours = diff.inHours % 24;
        final minutes = diff.inMinutes % 60;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              Text(
                "$days d ${hours}h ${minutes}m",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}