import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput({Key? key, required this.onSelectImage}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage == null
              ? Text(
                  l10n?.noImage ?? 'No image',
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera),
            label: Text(l10n?.takePicture ?? 'Take Picture'),
            onPressed: _takePicture,
            style: ElevatedButton.styleFrom(
              onPrimary: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _takePicture() async {
    final imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile != null) {
      setState(() => _storedImage = File(imageFile.path));
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(_storedImage!.path);
      final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    }
  }
}
