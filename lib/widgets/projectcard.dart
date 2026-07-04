import 'package:flutter/material.dart';

class CardUI extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback? onTap;

  const CardUI({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final membersStr = project['members'] as String; // e.g. "3/5"
    final parts = membersStr.split('/');
    final filled = int.tryParse(parts[0]) ?? 0;
    final total = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
    final progress = total == 0 ? 0.0 : filled / total;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['title'],
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project['description'],
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (project['tech'] as List)
                          .map((tech) => _TechChip(label: tech.toString()))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey[200], height: 1),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildMemberProgress(filled, total, progress)),
                        const SizedBox(width: 12),
                        _buildDaysBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: Image.network(
            "https://i.pinimg.com/736x/74/96/98/749698cbed1f9f7adceb9b4f9c7a21d5.jpg",
            height: 170,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                height: 170,
                color: Colors.grey[100],
                child: const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stack) => Container(
              height: 170,
              color: Colors.grey[100],
              alignment: Alignment.center,
              child: Icon(Icons.image_not_supported_rounded,
                  color: Colors.grey[400], size: 32),
            ),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.35),
                    Colors.transparent,
                    Colors.black.withOpacity(0.45),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 14,
          right: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getTypeGradient(project['type']),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getTypeGradient(project['type'])[0].withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              project['type'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 14,
          left: 14,
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Text(
                  (project['owner'] as String).isNotEmpty
                      ? project['owner'][0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                project['owner'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberProgress(int filled, int total, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people_alt_rounded, size: 16, color: Colors.blueGrey[400]),
            const SizedBox(width: 6),
            Text(
              "$filled/$total members",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              progress >= 1.0 ? Colors.green : Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDaysBadge() {
    final color = _getDaysColor(project['days']);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            project['days'],
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getTypeGradient(String type) {
    switch (type.toLowerCase()) {
      case 'hackathon':
        return [Colors.purple, Colors.deepPurpleAccent];
      case 'freelance':
        return [Colors.green, Colors.teal];
      case 'open source':
        return [Colors.orange, Colors.deepOrangeAccent];
      default:
        return [Colors.blue, Colors.indigo];
    }
  }

  Color _getDaysColor(String days) {
    if (days.contains("Left")) return Colors.redAccent;
    if (days.contains("Ongoing")) return Colors.green;
    return Colors.blue;
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}