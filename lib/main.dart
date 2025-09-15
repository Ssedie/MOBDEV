import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Personal Info',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PersonalInfoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Audio URLs (can be online URLs or local asset paths with setSource)
  final List<String> audioUrls = [
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  ];

  // YouTube video IDs
  final List<String> videoIds = [
    'FZW9SoAgDcE',
    'ftNxcMu0fE0',
    '_Cd_3mKUWNw',
    'ZqhvmlWf-os',
    '9DSBkbCcfFI',
  ];

  // Images in assets
  final List<String> imagePaths = [
    'assets/images/face.jpg',
    'assets/images/lightbulb.jpg',
    'assets/images/cow.jpg',
    'assets/images/animal.jpg',
    'assets/images/tree.jpg',
  ];

  // Track current playing audio index
  int? _currentAudioIndex;

  // Play audio
  void _playAudio(int index) async {
    if (_currentAudioIndex == index) {
      await _audioPlayer.pause();
      setState(() {
        _currentAudioIndex = null;
      });
    } else {
      await _audioPlayer.play(UrlSource(audioUrls[index]));
      setState(() {
        _currentAudioIndex = index;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Personal Info App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal info card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/image1.jpg'),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "John Doe",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text("Flutter Developer | Tech Enthusiast"),
                          SizedBox(height: 8),
                          Text("Email: john.doe@example.com"),
                          SizedBox(height: 8),
                          Text("Location: San Francisco, CA"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
            buildSectionTitle("My Images"),

            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePaths[index],
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),
            buildSectionTitle("My Videos (YouTube)"),

            Column(
              children: videoIds.map((videoId) {
                YoutubePlayerController _controller = YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.indigo,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.indigo,
                      handleColor: Colors.indigoAccent,
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 30),
            buildSectionTitle("My Audios"),

            Column(
              children: List.generate(audioUrls.length, (index) {
                bool isPlaying = _currentAudioIndex == index;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle_fill,
                      color: Colors.indigo,
                      size: 36,
                    ),
                    title: Text('Audio Track ${index + 1}'),
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
