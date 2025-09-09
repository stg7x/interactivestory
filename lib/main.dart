import 'package:flutter/material.dart';

void main() => runApp(InteractiveStoryApp());

class InteractiveStoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StoryPage(),
    );
  }
}

class StoryPage extends StatefulWidget {
  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int storyIndex = 0;
  bool swipeEnabled = false; // ayar ile kontrol

  final List<Map<String, dynamic>> storyData = [
    {'text': 'Bir ormana geldin. Devam etmek ister misin?', 'image': 'assets/forest.jpg'},
    {'text': 'Bir nehir gördün. Üzerinden geçmek ister misin?', 'image': 'assets/river.jpg'},
    {'text': 'Macera sona erdi!', 'image': 'assets/ending.jpg'},
  ];

  void nextStory(bool choice) {
    setState(() {
      if (storyIndex < storyData.length - 1) {
        storyIndex++;
      } else {
        storyIndex = 0; // sona gelince başa dön
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interaktif Hikaye'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    swipeEnabled: swipeEnabled,
                    onSwipeEnabledChanged: (val) {
                      setState(() {
                        swipeEnabled = val;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: swipeEnabled
            ? (details) {
                if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
                  nextStory(true);
                } else if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
                  nextStory(false);
                }
              }
            : null,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(storyData[storyIndex]['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      storyData[storyIndex]['text'],
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    if (!swipeEnabled)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => nextStory(true),
                            child: Text('Evet'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size(120, 50),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => nextStory(false),
                            child: Text('Hayır'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: Size(120, 50),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ayarlar ekranı
class SettingsPage extends StatefulWidget {
  final bool swipeEnabled;
  final Function(bool) onSwipeEnabledChanged;

  SettingsPage({required this.swipeEnabled, required this.onSwipeEnabledChanged});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool swipeEnabled;

  @override
  void initState() {
    super.initState();
    swipeEnabled = widget.swipeEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Kaydırmalı ilerleme'),
              value: swipeEnabled,
              onChanged: (val) {
                setState(() {
                  swipeEnabled = val;
                  widget.onSwipeEnabledChanged(swipeEnabled);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
