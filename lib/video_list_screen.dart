import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recruitment_task/tile.dart';
import 'package:video_player/video_player.dart';

import 'constants.dart';
import 'generated/l10n.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  VideoListScreenState createState() => VideoListScreenState();
}

class VideoListScreenState extends State<VideoListScreen> {
  late VideoPlayerController _controller;
  bool _showRecommendations = false;
  bool _isRestartingVideo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(film)
      ..initialize().then((_) {
        setState(() {});
      })
      ..addListener(_checkVideoEnded);

    _controller.play();
  }

  void _checkVideoEnded() {
    if (_controller.value.position == _controller.value.duration &&
        _controller.value.position != Duration.zero &&
        !_isRestartingVideo) {
      setState(() {
        _showRecommendations = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkVideoEnded);
    _controller.dispose();
    super.dispose();
  }

  void _toggleRecommendations() {
    setState(() {
      if (_showRecommendations) {
        _showRecommendations = false;
        _isRestartingVideo = true;
        _controller.seekTo(Duration.zero).then((_) {
          _controller.play();
          _isRestartingVideo = false;
        });
      } else {
        _controller.pause();
        _showRecommendations = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedOpacity(
                opacity: _showRecommendations ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(),
              ),
            ],
          ),
          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            top: _showRecommendations ? 100 : 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              S.current.recommended,
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Container(
                              width: 50,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.symmetric(vertical: 1),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleRecommendations,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: [
                              Tile(title: S.current.plan_trip, backgroundColor: Colors.teal),
                              Tile(title: S.current.beach, backgroundColor: Colors.green),
                              Tile(title: S.current.beautiful_views, backgroundColor: Colors.green),
                              Tile(title: S.current.beach, backgroundColor: Colors.green),
                              Tile(title: S.current.plan_trip, backgroundColor: Colors.teal),
                              Tile(title: S.current.trails, backgroundColor: Colors.blue),
                              Tile(title: S.current.beautiful_views, backgroundColor: Colors.green),
                              Tile(title: S.current.plan_trip, backgroundColor: Colors.teal),
                              Tile(title: S.current.beautiful_views, backgroundColor: Colors.green),
                              Tile(title: S.current.plan_trip, backgroundColor: Colors.teal),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 32,
            right: 8,
            left: 8,
            child: Stack(children: [
              AnimatedOpacity(
                opacity: _showRecommendations ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: Text(
                    S.current.logo,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      icon(Icons.menu),
                      Row(
                        children: [
                          icon(Icons.favorite_border),
                          const SizedBox(width: 4),
                          icon(Icons.search),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget icon(IconData iconData) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(iconData, color: Colors.black.withOpacity(_showRecommendations ? 1 : 0.5)),
      ),
    );
  }
}
