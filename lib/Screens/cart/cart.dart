import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CartScreen extends StatefulWidget {
  final bool fromDetails;

  const CartScreen({Key? key, this.fromDetails = false}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('cart');
  List<Map<String, dynamic>> _cartItems = [];
  double _totalPrice = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final cartData = await _dbRef.child(user.uid).get();
      if (cartData.exists) {
        final items = Map<String, dynamic>.from(cartData.value as Map);
        setState(() {
          _cartItems = items.entries.map((entry) {
            return {
              ...Map<String, dynamic>.from(entry.value),
              'key': entry.key,
            };
          }).toList();
          _totalPrice = _cartItems.fold(
              0.0, (sum, item) => sum + (item['price'] ?? 0.0));
          _isLoading = false;
        });
      } else {
        setState(() {
          _cartItems = [];
          _totalPrice = 0.0;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeItem(int index) async {
    User? user = _auth.currentUser;
    final key = _cartItems[index]['key'];

    if (user != null && key != null) {
      try {
        await _dbRef.child(user.uid).child(key).remove();
        setState(() {
          _cartItems.removeAt(index);
          _totalPrice = _cartItems.fold(
              0.0, (sum, item) => sum + (item['price'] ?? 0.0));
        });
      } catch (e) {
        print('Error removing item: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression')),
        );
      }
    } else {
      print('Invalid key for item: $key');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de supprimer cet article')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: widget.fromDetails
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        )
            : null,
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (widget.fromDetails && details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: _cartItems.isEmpty
            ? const Center(
          child: Text(
            "Votre panier est vide.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        item['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['title']),
                      subtitle: Text(
                          "Taille : ${item['size']}\nPrix : \$${item['price']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,
                            color: Color(0xFFFFA500)), // Orange pour la suppression
                        onPressed: () => _removeItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F1FD), // Bleu clair
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total :",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${_totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFA500), // Total en orange
                    ),
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
