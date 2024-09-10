import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fahis_studio/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FahisStudio extends StatefulWidget {
  const FahisStudio({super.key, required this.cameras, required this.bodyType});

  final List<CameraDescription> cameras;
  final BodyType bodyType;

  @override
  State<FahisStudio> createState() => _FahisStudioState();
}

class _FahisStudioState extends State<FahisStudio> {
  // double _yAngle = 0.0;
  late BodyType _bodyType;
  late BodyPart _selectedPart;
  final ScrollController _partScroller = ScrollController(
    initialScrollOffset: 0
  );
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
    _bodyType = widget.bodyType ;
    _selectedPart = _bodyType.parts.first ;
    // _startListening();
  }

/*  void _startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      _checkOrientation(event);
    });
  }*/

/*  void _checkOrientation(AccelerometerEvent event) {
    double y = event.y;
    _yAngle = y;

    setState(() {});
  }*/

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder:(context, snapshot) {
     if(snapshot.connectionState == ConnectionState.done){
       return Scaffold(
         backgroundColor: Colors.black,
         body: Row(
           children: [
             Container(
               height: MediaQuery.of(context).size.width,
               width: MediaQuery.of(context).size.height * .3,
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
               color: Colors.black,
               child: SingleChildScrollView(
                 controller: _partScroller,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     ..._bodyType.parts.map((BodyPart part) {
                       return BodyTypeCard(
                         part: part,
                         router: _bodyType.routeName,
                         isSelected: part.id == _selectedPart.id,
                         onSelect: (index) => _navigatePage(index: index),
                       );
                     }),
                   ],
                 ),
               ),
             ),
             Expanded(
               child: _selectedPart.cachedImage == null
                   ? Align(
                   alignment: Alignment.center,
                   child: Row(
                     children: [
                       Expanded(
                         child: AspectRatio(
                           aspectRatio: 16/9,
                           child: RotatedBox(
                               quarterTurns: 1,
                               child: CameraPreview(
                                 _controller,
                                 child: RotatedBox(
                                     quarterTurns: 3,
                                     child: Image.asset('assets/outlines/${widget.bodyType.routeName}/${_selectedPart.outlineBody}')
                                 ),
                               )
                           ),
                         ),
                       ),
                       Container(
                         height: MediaQuery.of(context).size.width,
                         width: MediaQuery.of(context).size.height * .3,
                         margin: const EdgeInsets.only(bottom: 8),
                         padding: const EdgeInsets.symmetric(horizontal: 16),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Container(
                               height: 50,
                               width: 50,
                               decoration: BoxDecoration(
                                   color: Colors.black.withOpacity(.5),
                                   borderRadius: BorderRadius.circular(100)
                               ),
                               child: IconButton(
                                   onPressed: (){},
                                   icon: const Icon(Icons.image, color: Colors.white,)
                               ),
                             ),
                             CameraButton(
                                 isVideo: _selectedPart.bodyPart == BodyParts.exteriorVideo,
                                 onTakePick: _pick,
                                 onStartVideo: () => _controller.startVideoRecording(),
                                 onEndVideo: _pickVideo
                             ),
                             Container(
                               height: 50,
                               width: 70,
                               decoration: BoxDecoration(
                                   color: Colors.black.withOpacity(.5),
                                   borderRadius: BorderRadius.circular(100)
                               ),
                               child: TextButton(
                                   onPressed: (){},
                                   child: Text('Next >', style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                       color: Colors.white
                                   ),)
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   )
               )
                   : Align(
                   alignment: Alignment.center,
                   child: PicturePreview(
                     cachedImage: _selectedPart.cachedImage!,
                     outline: 'assets/outlines/${widget.bodyType.routeName}/${_selectedPart.outlineBody}',
                     onCancel: () => setState(() {
                       _selectedPart.cachedImage = null;
                     }),
                     isVideo: _selectedPart.bodyPart == BodyParts.exteriorVideo,
                     onSave: (image) {}
                   )
               ),
             ),
           ],
         ),
       );
     }else{
       return const Center(
         child: CircularProgressIndicator(
           color: Colors.orange,
         ),
       );
     }
    });
  }

  _pick() async {
    XFile cameraFile = await _controller.takePicture();
    setState(() {
      _selectedPart.cachedImage = File(cameraFile.path);
    });
  }

  _navigatePage({int index = 1,bool isNext = false}){
    if(isNext){
      index = _selectedPart.id.toInt() ;
    }
    setState((){
      _selectedPart = _bodyType.parts.where((part) => part.id == index).first;
    });
    index -= 1;
    _partScroller.animateTo(
        index * MediaQuery.of(context).size.height * .25,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn
    );
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn
    );
    setState(() {});
  }

  _pickVideo() async {
    XFile cameraFile = await _controller.stopVideoRecording();
    setState(() {
      _selectedPart.cachedImage = File(cameraFile.path);
    });
  }
}

class PicturePreview extends StatefulWidget {
  const PicturePreview({super.key, required this.cachedImage, required this.outline, required this.onCancel, required this.onSave, required this.isVideo});

  final bool isVideo;
  final File cachedImage;
  final String outline;
  final Function onCancel;
  final Function(File image) onSave;

  @override
  State<PicturePreview> createState() => _PicturePreviewState();
}

class _PicturePreviewState extends State<PicturePreview> {
  bool _showOutline = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              widget.isVideo
              ? VideoPlayerScreen(video: widget.cachedImage)
              : Image.file(widget.cachedImage),
              _showOutline ? AspectRatio(
                aspectRatio: 16/9,
                child: Image.asset(widget.outline),
              )
              : const SizedBox(),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.height * .3,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(100)
                ),
                child: Column(
                  children: [
                    IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.image_aspect_ratio, color: Colors.white,)
                    ),
                    Text('Edit', style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              Container(
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(100)
                ),
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () => setState(() {
                          _showOutline = !_showOutline;
                        }),
                        icon: const Icon(Icons.hide_image_outlined, color: Colors.white,)
                    ),
                    Text(_showOutline ? 'Hide' : 'Show', style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              Container(
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(100)
                ),
                child: Column(
                  children: [
                    IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.save, color: Colors.white,)
                    ),
                    Text('Save', style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              Container(
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(100)
                ),
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () => widget.onCancel,
                        icon: const Icon(Icons.settings_backup_restore, color: Colors.white,)
                    ),
                    Text('Cancel', style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class BodyTypeCard extends StatelessWidget {
  const BodyTypeCard({
    super.key,
    required this.part,
    required this.router,
    required this.onSelect,
    required this.isSelected,
  });

  final Function(int partId) onSelect;
  final bool isSelected;
  final BodyPart part;
  final String router;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(part.id.toInt()),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .25,
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 5/4,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Constants.borderRadiusMd),
                    border: Border.all(
                        color: isSelected ? Colors.orange : Colors.blueGrey,
                        width: 2,
                        style: BorderStyle.solid
                    )
                ),
                child: Center(
                  child: part.image != null
                      ? Image.file(File(part.image!))
                      : Image.asset('assets/outlines/$router/${part.getOutline()}',color: Colors.blueGrey,),
                ),
              ),
            ),
            const SizedBox(height: 6,),
            Text(part.name,style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: part.image != null ? Colors.green : Colors.white
            ),),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.video});
  final File video;
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      widget.video, // Update with your video file path
    )..initialize().then((_) {
      setState(() {}); // Update the UI when the video is initialized
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Center(child: CircularProgressIndicator(color: Constants.primaryColor,)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class CameraButton extends StatefulWidget {
  const CameraButton({
    super.key,
    this.isVideo = false,
    this.onTakePick,
    this.onStartVideo,
    this.onEndVideo,
  });

  final bool isVideo;
  final Function? onTakePick;
  final Function? onStartVideo;
  final Function? onEndVideo;

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  bool _isTapped = false;
  bool _isRecording = false;

  // Future.delayed(duration, () => HapticFeedback.vibrate());
  @override
  void initState() {
    // TODO: implement initState
    if(widget.isVideo && (widget.onStartVideo == null || widget.onEndVideo == null)){
      return ;
    }
    if(! widget.isVideo && widget.onTakePick == null){
      return ;
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onClick,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 80 ,
          width: 80 ,
          padding: EdgeInsets.all(_isTapped ? 15 : 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white, width: 5),
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: _isRecording ? Colors.red : Colors.white
            ),
          )
      ),
    );
  }

  void _onClick() async {
    if(widget.isVideo){
      if(_isRecording){
        setState(() {
          _isTapped = false;
          _isRecording = false;
        });
        widget.onEndVideo!();
      }else{
        setState(() {
          _isTapped = true;
          _isRecording = true;
        });
        widget.onStartVideo!();
      }
    }
    else{
      setState(() {
        _isTapped = true;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _isTapped = false;
      });
      widget.onTakePick!();
    }
  }
}
