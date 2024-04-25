import 'package:flutter/material.dart';
import 'objects.dart';
import 'product_details.dart';

class FavoritesTab extends StatefulWidget {
  final List<Product> products;

  FavoritesTab({required this.products});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = widget.products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];

              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: ListTile(
                  title: Text(product.label,
                      style: TextStyle(color: Colors.black)),
                  // ignore: unnecessary_null_comparison
                  leading: product.image != null && product.image.isNotEmpty
                      ? SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child:
                              Image.network(product.image, fit: BoxFit.cover),
                        )
                      : SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: Icon(Icons.image, color: Colors.black),
                        ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(foodId: product.foodId),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
