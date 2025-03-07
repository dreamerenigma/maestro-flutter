import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import 'choose_picture_screen.dart';

class SelectPicturesScreen extends StatefulWidget {
  const SelectPicturesScreen({super.key});

  @override
  SelectPicturesScreenState createState() => SelectPicturesScreenState();
}

class SelectPicturesScreenState extends State<SelectPicturesScreen> {
  final List<AssetEntity> _imageList = [];
  final List<bool> selectedImages = [];
  final TextEditingController _searchController = TextEditingController();
  bool loading = true;
  int currentPage = 0;
  final int pageSize = 50;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final PermissionState permissionState = await PhotoManager.requestPermissionExtend();

      if (permissionState.isAuth) {
        List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
        );

        if (albums.isNotEmpty) {
          List<AssetEntity> images = await albums[0].getAssetListPaged(
            page: currentPage,
            size: pageSize,
          );

          setState(() {
            _imageList.addAll(images);
            selectedImages.addAll(List.generate(images.length, (index) => false));
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      } else {
        PhotoManager.openSetting();
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.blue)),
                    ),
                    Expanded(child: _tabBar()),
                  ],
                ),
              ),
              _search(context),
              Expanded(
                child: TabBarView(
                  children: [
                    _imagesGrid(context),
                    _imagesGrid(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          height: 40,
          decoration: BoxDecoration(color: AppColors.darkGrey, borderRadius: BorderRadius.circular(12.0)),
          child: TabBar(
            tabs: const [
              Tab(
                child: SizedBox(
                  width: 100,
                  child: Center(
                    child: Text('Photos'),
                  ),
                ),
              ),
              Tab(
                child: SizedBox(
                  width: 100,
                  child: Center(
                    child: Text('Albums'),
                  ),
                ),
              ),
            ],
            indicator: BoxDecoration(
              color: AppColors.darkerGrey,
              borderRadius: BorderRadius.circular(12.0),
            ),
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            overlayColor: WidgetStateProperty.all(AppColors.transparent),
            labelPadding: EdgeInsets.zero,
            dividerColor: AppColors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _search(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: TextSelectionTheme(
              data: TextSelectionThemeData(
                cursorColor: AppColors.primary,
                selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
                selectionHandleColor: AppColors.primary,
              ),
              child: TextField(
                controller: _searchController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Photos, People, Places...',
                  hintStyle: TextStyle(color: context.isDarkMode ? AppColors.darkerGrey : AppColors.darkerGrey),
                  prefixIcon: Icon(Icons.search, color: context.isDarkMode ? AppColors.darkerGrey : AppColors.darkGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagesGrid(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
    }

    if (_imageList.isEmpty) {
      return const Center(child: Text('No images found'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: _imageList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, createPageRoute(ChoosePictureScreen(image: _imageList[index])));
          },
          child: FutureBuilder<Uint8List?>(
            future: _imageList[index].thumbnailData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  );
                } else {
                  return const Center(child: Text('Failed to load image'));
                }
              } else {
                return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
              }
            },
          ),
        );
      },
    );
  }
}
