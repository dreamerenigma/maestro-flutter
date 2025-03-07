import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../utils/constants/app_colors.dart';
import '../../../library/screens/local_audio_screen.dart';

class LocalList extends StatefulWidget {
  final int initialIndex;

  const LocalList({super.key, required this.initialIndex});

  @override
  LocalListState createState() => LocalListState();
}

class LocalListState extends State<LocalList> {
  List<FileSystemEntity> _audioFiles = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadAudioFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync();

    setState(() {
      _audioFiles = files.where((file) {
        final fileExtension = file.path.split('.').last;
        return fileExtension == 'mp3' || fileExtension == 'wav' || fileExtension == 'm4a';
      }).toList();
    });
  }

  Future<void> _playAudio(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
      _audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    } catch (e) {
      log("An error occurred while trying to play the audio file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Audio Playlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('LocalList', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, createPageRoute(LocalAudioScreen(initialIndex: widget.initialIndex, songs: [])));
                  },
                  child: const Text('See All', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _audioFiles.length > 5 ? 5 : _audioFiles.length,
                itemBuilder: (context, index) {
                  final file = _audioFiles[index];
                  return ListTile(
                    title: Text(file.path.split('/').last),
                    onTap: () => _playAudio(file.path),
                  );
                },
              ),
            ),
            _localSongs(),
          ],
        ),
      ),
    );
  }

  Widget _localSongs() {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.isDarkMode ? AppColors.darkGrey : AppColors.grey,
      ),
      child: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow_rounded,
        color: context.isDarkMode ? AppColors.darkerGrey : AppColors.grey,
      ),
    );
  }
}
