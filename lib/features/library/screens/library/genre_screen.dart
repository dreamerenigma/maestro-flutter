import 'package:flutter/material.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class PickGenreScreen extends StatefulWidget {
  const PickGenreScreen({super.key});

  @override
  PickGenreScreenState createState() => PickGenreScreenState();
}

class PickGenreScreenState extends State<PickGenreScreen> {
  String? selectedGenre;
  String? selectedAudio;

  List<String> genres = [
    "Alternative Rock",
    "Ambient",
    "Classical",
    "Blues",
    "Classical",
    "Country",
    "Dance & EDM",
    "Dancehall",
    "Deep House",
    "Disco",
    "Drum & Base",
    "Dubstep",
    "Electronic",
    "Folk & Singer-Songwriter",
    "Hip-hop & Rap",
    "House",
    "Indie",
    "Jazz & Blues",
    "Latin",
    "Metal",
    "Piano",
    "Pop",
    "R&B Soul",
    "Reggae",
    "Reggaeton",
    "Rock",
    "Soundtrack",
    "Speech",
    "Techno",
    "Trance",
    "Trap",
    "Triphop",
    "World",
  ];

  List<String> audio = [
    "Audiobooks",
    "Business",
    "Comedy",
    "Entertainment",
    "Learning",
    "News & Politics",
    "Religion & Spirituality",
    "Science",
    "Sports",
    "Storytelling",
    "Technology",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Pick genre', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Music', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w200, color: AppColors.lightGrey)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  String genre = genres[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedGenre = genre;
                        Navigator.pop(context, selectedGenre);
                      });
                    },
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(genre, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w200, letterSpacing: -0.5)),
                          if (selectedGenre == genre) const Icon(Icons.check, color: AppColors.blue),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Audio', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w200, color: AppColors.lightGrey)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: audio.length,
                itemBuilder: (context, index) {
                  String audioCategory = audio[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedAudio = audioCategory;
                        Navigator.pop(context, selectedAudio);
                      });
                    },
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(audioCategory, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w200, letterSpacing: -0.5)),
                          if (selectedAudio == audioCategory)
                            const Icon(Icons.check, color: AppColors.blue),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
