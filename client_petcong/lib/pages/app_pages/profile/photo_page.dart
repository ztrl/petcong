import 'package:flutter/material.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:petcong/widgets/create_button.dart';
import 'package:petcong/widgets/delete_button.dart';
import 'media_page.dart';
import 'video_page.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';

// 이미지를 선택하고 화면에 표시되는 기능
class DisplayImage extends StatelessWidget {
  final String imagePath;

  const DisplayImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // 추가
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0), // 둥근 모서리의 크기를 지정합니다.
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover, // 이미지를 그리드의 크기에 맞게 조절합니다.
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PhotoPage extends StatefulWidget {
  final double progress;

  const PhotoPage({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  PhotoPageState createState() => PhotoPageState();
}

class PhotoPageState extends State<PhotoPage> {
  late double _progress;
  final List<String> _photoPaths = []; // 선택한 이미지들의 경로를 저장하는 리스트

  void navigateToMediaPage() async {
    final result = await Get.to<String>(const MediaPage());
    if (result != null) {
      setState(() {
        _photoPaths.add(result);
      });
    }
  }

  void deleteImage(int index) {
    setState(() {
      _photoPaths.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: _progress);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: LinearProgressIndicator(
            value: _progress,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 249, 113, 95),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () => Get.back(result: _progress),
              ),
            ),
            const SizedBox(height: 10.0),
            const Center(
              child: Text(
                '사진 첨부',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10.0),
            const Center(
              child: Text(
                '최소 2개의 사진을 첨부해주세요',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 60.0),
            SizedBox(
              height: 250,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index < _photoPaths.length) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          DisplayImage(imagePath: _photoPaths[index]),
                          if (index == 0) // 첫 번째 그리드일 때만 아이콘을 표시합니다.
                            Positioned(
                              top: -45,
                              left: 22.5,
                              child: SvgPicture.asset(
                                'assets/src/crown.svg',
                                width: 40,
                                height: 40,
                                color: const Color.fromARGB(255, 249, 113, 95),
                              ),
                            ),
                          Positioned(
                            bottom: -8,
                            right: -8,
                            child: RoundGradientXButton(
                              onTap: () => deleteImage(index),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GridWithPlusButton(
                            onTap: () => navigateToMediaPage(),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  ContinueButton(
                    isFilled: _photoPaths.length >= 2,
                    buttonText: 'CONTINUE',
                    onPressed: _photoPaths.length >= 2
                        ? () {
                            Get.to(
                                VideoPage(
                                  progress: _progress + 1 / 12,
                                ),
                                transition: Transition.noTransition);
                          }
                        : null,
                    width: 240.0,
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridWithPlusButton extends StatelessWidget {
  final VoidCallback onTap;

  const GridWithPlusButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          right: -5,
          child: RoundGradientPlusButton(onTap: onTap),
        ),
      ],
    );
  }
}
