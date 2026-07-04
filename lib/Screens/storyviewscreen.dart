import 'dart:async';

import 'package:flutter/material.dart';

import '../models/hackathon.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<DeveloperStory> stories;
  final int initialIndex;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    required this.initialIndex,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {

  late int current;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    current = widget.initialIndex;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nextStory();
      }
    });
  }

  void nextStory() {
    if (current == widget.stories.length - 1) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      current++;
    });

    controller
      ..reset()
      ..forward();
  }

  void previousStory() {
    if (current == 0) return;

    setState(() {
      current--;
    });

    controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final story = widget.stories[current];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(

          onTapUp: (details) {

            final width = MediaQuery.of(context).size.width;

            if (details.localPosition.dx < width / 2) {
              previousStory();
            } else {
              nextStory();
            }
          },

          onLongPressStart: (_) {
            controller.stop();
          },

          onLongPressEnd: (_) {
            controller.forward();
          },

          child: Stack(
            fit: StackFit.expand,
            children: [

              story.isVideo
                  ? const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 90,
                ),
              )
                  : Image.network(
                story.storyUrl,
                fit: BoxFit.cover,
              ),

              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  children: List.generate(
                    widget.stories.length,
                        (index) {

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (_, __) {

                              return LinearProgressIndicator(
                                value: index < current
                                    ? 1
                                    : index == current
                                    ? controller.value
                                    : 0,
                                backgroundColor: Colors.white24,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Positioned(
                top: 28,
                left: 12,
                right: 12,
                child: Row(
                  children: [

                    CircleAvatar(
                      backgroundImage:
                      NetworkImage(story.profileImage),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      story.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}