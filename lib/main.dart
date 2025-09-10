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
  bool swipeEnabled = false;

  final List<Map<String, dynamic>> storyData = [
    {
      'text': 'Güneşin sıcak ışıkları tenimi okşarken, ayaklarımın altındaki ılık kumda yürüyor, denizin sonsuz maviliğine dalıp gitmiştim. Bugün, her zamanki gibi sakin bir gündü, ya da öyle sanmıştım.',
      'image': 'assets/ilkresim.png',
    },
    {
      'text': 'Uzakta, kumsalda tek başına oturan yaşlı bir adam dikkatimi çekti. Üzerinde eski püskü ama temiz kıyafetler vardı ve denize doğru bakıyordu, sanki bir şey bekliyormuş gibiydi.',
      'image': 'assets/hikaye2.png',
    },
    {
      'text': 'Merakıma yenik düşerek ona doğru yürüdüm. Yaklaştıkça, yüzündeki derin çizgilerin her birinin bir hikaye anlattığını fark ettim. Yanına vardığımda, bana döndü ve gözlerinde bilgelikle dolu bir parıltı vardı.',
      'image': 'assets/3hikaye.png',
    },
    {
      'text': 'Sözleri beni şaşırttı. Tam ne diyeceğimi düşünürken, arkasındaki havada garip bir titreşim başladı. Hava bükülüyor, renkler dans ediyordu. Sanki görünmez bir el perdenin arkasını aralıyordu.',
      'image': 'assets/4hikaye.png',
    },
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
        child: Stack(
          children: [
            // Arka plan görseli tüm ekran
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(storyData[storyIndex]['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Hikaye kutucuğu ve butonlar
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      storyData[storyIndex]['text'],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!swipeEnabled) SizedBox(height: 12),
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
