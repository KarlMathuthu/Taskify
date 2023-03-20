import 'package:image_picker/image_picker.dart';

getPickedImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  //else print('No image selected')
  print('No Image Selected');
}
