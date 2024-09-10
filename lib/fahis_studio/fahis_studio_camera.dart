import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fahis_studio/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FahisStudioCamera extends StatefulWidget {
  const FahisStudioCamera({
    super.key,
    required this.part,
    required this.assetsRoute,
    required this.availableCameras
  });

  final List<CameraDescription> availableCameras;
  final BodyPart part;
  final String assetsRoute;

  @override
  State<FahisStudioCamera> createState() => _FahisStudioCameraState();
}

class _FahisStudioCameraState extends State<FahisStudioCamera> {
  File? _pictureFile;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isTapped = false;
  
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.availableCameras[0],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Image.asset('${widget.assetsRoute}/${widget.part.outlineBody}'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.height * .3,
            ),
          ],
        )
    );
    /*return AspectRatio(
      aspectRatio: 16/9,
      child: RotatedBox(
        quarterTurns: 1,
        child: _pictureFile == null
            ? CameraPreview(_controller)
            : Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: RotatedBox(
                  quarterTurns: 3,
                  child: Image.file(_pictureFile!)
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(onPressed: (){
                        setState(() {
                          _pictureFile = null;
                        });
                      }, child: Text('Cancel', style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.orange
                      ),)),
                      const SizedBox(width: 8,),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange
                          ),
                          onPressed: () {}, //_savePic(),
                          child: Text('Save', style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Colors.white
                          ),)
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );*/
  }

  Future<void> _pickGalleryImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pictureFile = File(result.files.single.path!);
      });
    }
  }
  // _selectPart(BodyPart part) {
  //   setState(() {
  //     if(part.image != null){
  //       _pictureFile = File(part.image!);
  //     }else{
  //       _pictureFile = null;
  //     }
  //     _selectedPart = part;
  //   });
  // }

/*
  _savePic() {
    if(_pictureFile != null){
      _bodyType.parts.where((p)
      => p.id == _selectedPart.id
      ).first.image = _pictureFile!.path;
    }
    _pictureFile = null;
    _selectedPart = _bodyType.parts.where((p)
    => p.id == _selectedPart.id + 1
    ).first;
    setState(() {});
  }
*/



  void _next() {
  }
}
