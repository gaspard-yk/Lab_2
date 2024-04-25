import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'objects.dart';

class ProductDetailScreen extends StatefulWidget {
  final String foodId;

  ProductDetailScreen({required this.foodId});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? product;
  List<Product> favoriteProducts = [];
  late SharedPreferences prefs;

  bool isFavorite(Product product) {
    return favoriteProducts
        .any((favorite) => favorite.foodId == product.foodId);
  }

  void add_to_Favorite(Product product) {
    if (isFavorite(product)) {
      favoriteProducts
          .removeWhere((favorite) => favorite.foodId == product.foodId);
      prefs.setStringList(
          'favoriteProducts',
          favoriteProducts
              .map((product) => jsonEncode(product.toMap()))
              .toList());
    } else {
      favoriteProducts.add(product);
      prefs.setStringList(
          'favoriteProducts',
          favoriteProducts
              .map((product) => jsonEncode(product.toMap()))
              .toList());
    }
    setState(() {});
  }

  Future<void> _fetchProductDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://api.edamam.com/api/food-database/v2/parser?ingr=${Uri.encodeComponent(widget.foodId)}&app_id=9a0d6573&app_key=63ec1258039b935f000bab51f1097967'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data != null &&
          data['hints'] != null &&
          data['hints'].isNotEmpty &&
          data['hints'][0]['food'] != null) {
        setState(() {
          product = Product.fromMap(data['hints'][0]['food']);
        });
      } else {
        throw Exception('Failed to load product details');
      }
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    _fetchProductDetails();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    List<String> favoriteProductsJson =
        prefs.getStringList('favoriteProducts') ?? [];
    favoriteProducts = favoriteProductsJson
        .map((jsonString) => Product.fromMap(jsonDecode(jsonString)))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Характеристики'),
        actions: [
          if (product != null)
            IconButton(
              icon: Icon(
                isFavorite(product!) ? Icons.favorite : Icons.favorite_border,
                color: isFavorite(product!) ? Colors.red : Colors.black,
              ),
              onPressed: () {
                add_to_Favorite(product!);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: product == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImageWithRetry(
                                  product!.image.isNotEmpty
                                      ? product!.image
                                      : 'https://via.placeholder.com/150', // Use a placeholder image when the image URL is empty
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text('Название: ${product!.label}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                    'Категория: ${product!.categoryLabel}',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text('Питательная ценность:',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            'Калории: ${product!.nutrients['ENERC_KCAL']} kcal',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                            'Белки: ${product!.nutrients['PROCNT']} g',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                            'Жиры: ${product!.nutrients['FAT']} g',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                            'Углеводы: ${product!.nutrients['CHOCDF']} g',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

//  TableCell(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text(
//                     forecast.dtText,
//                     style: TextStyle(color: Colors.white, fontSize: 10),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),