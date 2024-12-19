import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../../model/clothing_classifier.dart';

class NewArticleScreen extends StatefulWidget {
  const NewArticleScreen({Key? key}) : super(key: key);

  @override
  _NewArticleScreenState createState() => _NewArticleScreenState();
}

class _NewArticleScreenState extends State<NewArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('clothes');
  final ClothingClassifier _classifier = ClothingClassifier();

  String? _previewImageUrl;
  String? _predictedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _imageUrlController.addListener(() {
      setState(() {
        _previewImageUrl = _imageUrlController.text.trim();
      });

      if (_previewImageUrl != null && _previewImageUrl!.isNotEmpty) {
        _predictCategory();
      }
    });
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _predictCategory() async {
    try {
      setState(() {
        _isLoading = true;
        _predictedCategory = null;
      });

      final response = await http.get(Uri.parse(_previewImageUrl!));
      if (response.statusCode == 200) {
        final imageData = response.bodyBytes;
        final result = await _classifier.predict(imageData);
        setState(() {
          _predictedCategory = result['category'];
          _categoryController.text = _predictedCategory ?? '';
          _isLoading = false;
        });
      } else {
        throw Exception('Image not found');
      }
    } catch (e) {
      print('Prediction error: $e');
      setState(() {
        _predictedCategory = 'Erreur lors de la prédiction';
        _categoryController.text = _predictedCategory ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _addArticle() async {
    if (_formKey.currentState!.validate() && _predictedCategory != null) {
      try {
        await _dbRef.push().set({
          'title': _titleController.text,
          'size': _sizeController.text,
          'brand': _brandController.text,
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'imageUrl': _imageUrlController.text,
          'category': _predictedCategory,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article ajouté avec succès')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez fournir une URL valide pour prédire la catégorie')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un article', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E90FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Preview Section
                if (_previewImageUrl != null && _previewImageUrl!.isNotEmpty)
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                        maxWidth: double.infinity,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _previewImageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Text(
                              'URL invalide',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un titre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Predicted Category Field
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Catégorie'),
                    enabled: false,
                    style: TextStyle(color: Colors.black),
                  ),
                const SizedBox(height: 16),

                // Size Field
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(labelText: 'Taille'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une taille';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Brand Field
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Marque'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une marque';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Price Field
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Veuillez entrer un prix valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Image URL Field
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une URL d\'image';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Add Article Button
                Center(
                  child: ElevatedButton(
                    onPressed: _addArticle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2661FA),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Valider',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
