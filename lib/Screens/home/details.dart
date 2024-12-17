import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely cast the arguments to Map<String, dynamic>
    final data = ModalRoute.of(context)!.settings.arguments as Map?;

    if (data == null || data is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: const Color(0xFF2661FA),
        ),
        body: const Center(
          child: Text('Invalid data passed to the screen.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(data['title']),
        backgroundColor: const Color(0xFF2661FA),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image of the clothing item with rounded corners and a shadow
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                data['imageUrl'],
                height: 250,
                width: double.infinity,
                fit: BoxFit.contain, // Better scaling for the image
              ),
            ),
            const SizedBox(height: 24),
            // Title with bold and large text
            Text(
              data['title'],
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            // Category
            _buildDetailRow("Catégorie", data['category']),
            const SizedBox(height: 8),
            // Size
            _buildDetailRow("Taille", data['size']),
            const SizedBox(height: 8),
            // Brand
            _buildDetailRow("Marque", data['brand']),
            const SizedBox(height: 8),
            // Price
            Text(
              "Prix : \$${data['price']}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            // Add to cart button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action to add the item to the cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ajouté au panier")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2661FA), // Button color
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 40.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Ajouter au Panier',
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label : ",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
