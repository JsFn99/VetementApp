import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ClothingClassifier {
  late Interpreter _interpreter;
  final List<String> _classNames = [
    'Haut', 'Pantalon', 'Pull', 'Robe', 'Manteau',
    'Sandale', 'Chemise', 'Basket', 'Sac', 'Bottine'
  ];

  ClothingClassifier() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/model_3.tflite');
      print("Model loaded successfully!");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  List<List<List<List<double>>>> _preprocessImage(Uint8List imageData) {
    final image = img.decodeImage(imageData)!;

    // Convert to grayscale
    final grayscale = img.grayscale(image);

    // Resize to 28x28
    final resized = img.copyResize(grayscale, width: 28, height: 28);

    // Normalize pixel values and convert to a 2D list of doubles
    List<List<List<List<double>>>> inputTensor = List.generate(
      1, // Batch size
          (_) => List.generate(
        28, // Height
            (_) => List.generate(
          28, // Width
              (_) => List.filled(1, 0.0), // Channels (1 for grayscale)
        ),
      ),
    );

    for (int y = 0; y < resized.height; y++) {
      for (int x = 0; x < resized.width; x++) {
        final pixel = resized.getPixel(x, y);
        final normalizedPixel = img.getLuminance(pixel) / 255.0;
        inputTensor[0][y][x][0] = normalizedPixel;
      }
    }

    return inputTensor;
  }

  Future<Map<String, dynamic>> predict(Uint8List imageData) async {
    try {
      // Preprocess the image
      final inputTensor = _preprocessImage(imageData);

      // Prepare the output tensor (shape [1, 10] to match model output)
      var output = List.generate(1, (_) => List.filled(10, 0.0));

      // Run inference
      _interpreter.run(inputTensor, output);

      // Get prediction
      final probabilities = output[0]; // First (and only) batch
      final maxIndex = probabilities.indexWhere((val) => val == probabilities.reduce((a, b) => a > b ? a : b));

      return {
        'category': _classNames[maxIndex],
        'confidence': probabilities[maxIndex]
      };
    } catch (e) {
      print('Model inference error: $e'); // Log the error
      throw Exception('Model inference failed');
    }
  }
}
