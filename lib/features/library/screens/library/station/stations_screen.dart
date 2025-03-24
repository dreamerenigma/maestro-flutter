import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/data/services/station/station_firebase_service.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../domain/entities/station/station_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../service_locator.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../home/screens/home_screen.dart';
import '../../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../../widgets/dialogs/filter_stations_bottom_dialog.dart';
import '../../../widgets/input_fields/input_field.dart';
import '../../../widgets/lists/station/station_list.dart';

class StationsScreen extends StatefulWidget {
  final int initialIndex;
  final List<StationEntity> stations;
  final List<SongEntity> song;

  const StationsScreen({super.key, required this.initialIndex, required this.stations, required this.song});

  @override
  State<StationsScreen> createState() => StationsScreenState();
}

class StationsScreenState extends State<StationsScreen> {
  late final int selectedIndex;
  final TextEditingController _searchController = TextEditingController();
  List<StationEntity> filteredStations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    filteredStations = widget.stations;
    _searchController.addListener(_filterStations);
    _loadStation();
  }

  void _loadStation() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final result = await sl<StationFirebaseService>().getStations();

        result.fold(
          (error) {
            log("Error fetching stations: $error");
            setState(() {
              isLoading = false;
            });
          },
          (stations) {
            setState(() {
              filteredStations = stations.map((station) => station.toEntity()).toList();
              isLoading = false;
            });
          },
        );
      } else {
        log("User not authenticated");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log("Error loading stations: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void _filterStations() {
    setState(() {
      filteredStations = widget.stations.where((station) => station.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Stations', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
            : ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: RefreshIndicator(
            onRefresh: _reloadData,
            displacement: 0,
            color: AppColors.primary,
            backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 6, top: 16, bottom: 6),
                  child: InputField(
                    controller: _searchController,
                    hintText: filteredStations.isEmpty ? 'Search stations' : 'Search ${filteredStations.length} stations',
                    icon: JamIcons.settingsAlt,
                    onIconPressed: () {
                      showFilterStationsDialog(context);
                    },
                  ),
                ),
                StationList(stations: filteredStations, initialIndex: widget.initialIndex, song: widget.song),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }
}
