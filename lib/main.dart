import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Personal Info',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const PersonalInfoPage(),
    );
  }
}

// The missing StatefulWidget class
class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
  int _currentImageIndex = 0;
  int _currentVideoIndex = 0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  final List<String> audioUrls = [
    'audio/kahel.mp3',
    'audio/sapphire.mp3',
    'audio/sailor.mp3',
    'audio/skusta.mp3',
    'audio/blue.mp3',
  ];

  final List<String> videoIds = [
    'FZW9SoAgDcE',
    'ftNxcMu0fE0',
    '_Cd_3mKUWNw',
    'ZqhvmlWf-os',
    '9DSBkbCcfFI',
  ];

  final List<String> imagePaths = [
    'assets/images/face.jpg',
    'assets/images/lightbulb.jpg',
    'assets/images/cow.jpg',
    'assets/images/animal.jpg',
    'assets/images/tree.jpg',
  ];

  int? _currentAudioIndex;

  final CarouselSliderController _imageCarouselController = CarouselSliderController();
  final CarouselSliderController _videoCarouselController = CarouselSliderController();

  late final List<YoutubePlayerController> _youtubeControllers;

  @override
  void initState() {
    super.initState();

    _youtubeControllers = videoIds.map(
          (videoId) => YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      ),
    ).toList();// Existing YouTube controller setup here

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _currentAudioIndex = null;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
      });
    });
  }


  void _playAudio(int index) async {
    if (_currentAudioIndex == index) {
      await _audioPlayer.pause();
      setState(() {
        _currentAudioIndex = null;
      });
    } else {
      await _audioPlayer.stop(); // stop any current playing audio
      await _audioPlayer.play(AssetSource(audioUrls[index]));
      setState(() {
        _currentAudioIndex = index;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
      });
    }
  }


  @override
  void dispose() {
    for (var controller in _youtubeControllers) {
      controller.dispose();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome!"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal info card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.6),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Zedric M. Rulloda",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Fullstack Developer | Student",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "zedric.rulloda@lorma.edu",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "Baccuit Norte, Bauang, La Union",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            buildSectionTitle("Images to See"),

            Column(
              children: [
                CarouselSlider.builder(
                  carouselController: _imageCarouselController,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index, realIndex) {
                    return AnimatedOpacity(
                      opacity: _currentImageIndex == index ? 1.0 : 0.6,
                      duration: Duration(milliseconds: 500),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              imagePaths[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.black54, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Text(
                                  'Image ${index + 1}',  // Change to your own captions if you want
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 180,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imagePaths.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _imageCarouselController.animateToPage(entry.key),
                      child: Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == entry.key
                              ? Colors.blueAccent
                              : Colors.grey[400],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 30),
            buildSectionTitle("Videos to Watch"),

            Column(
              children: [
                CarouselSlider.builder(
                  carouselController: _videoCarouselController,
                  itemCount: _youtubeControllers.length,
                  itemBuilder: (context, index, realIndex) {
                    final controller = _youtubeControllers[index];
                    final isCurrent = index == _currentVideoIndex;

                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: isCurrent ? 1 : 0.6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: YoutubePlayer(
                            controller: controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.blueAccent,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.blueAccent,
                              handleColor: Colors.blue,
                            ),
                            onEnded: (metaData) {
                              // Optionally auto-advance video here
                            },
                            onReady: () {
                              // Pause other videos
                              for (int i = 0; i < _youtubeControllers.length; i++) {
                                if (i != index) {
                                  _youtubeControllers[i].pause();
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 230,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.9,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentVideoIndex = index;
                        // Pause all videos except current one
                        for (int i = 0; i < _youtubeControllers.length; i++) {
                          if (i != index) _youtubeControllers[i].pause();
                        }
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _youtubeControllers.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _videoCarouselController.animateToPage(entry.key),
                      child: Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentVideoIndex == entry.key
                              ? Colors.blueAccent
                              : Colors.grey[400],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),


            const SizedBox(height: 30),
            buildSectionTitle("Some Audio for You"),

            Column(
              children: List.generate(audioUrls.length, (index) {
                bool isPlaying = _currentAudioIndex == index;
                double progress = 0;
                if (isPlaying && _totalDuration.inMilliseconds > 0) {
                  progress = _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
                }

                return Card(
                  color: const Color(0xFF142850),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle_fill,
                        key: ValueKey<bool>(isPlaying),
                        color: Colors.blueAccent,
                        size: 36,
                      ),
                    ),
                    title: Text(
                      'Audio Track ${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: isPlaying
                        ? Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade700,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    )
                        : null,
                    trailing: isPlaying
                        ? Text(
                      "${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    )
                        : null,
                    onTap: () => _playAudio(index),
                  ),
                );
              }),
            ),

          ],
        ),
      ),
    );
  }
}
