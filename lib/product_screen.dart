import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_details.dart';

class ProductList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> _products = [];
  String _searchQuery = 'apple';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _searchProducts() async {
    final response = await http.get(
      Uri.parse(
          'https://api.edamam.com/api/food-database/v2/parser?ingr=$_searchQuery&app_id=9a0d6573&app_key=63ec1258039b935f000bab51f1097967'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _products = jsonDecode(response.body)['hints'];
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Справочник продуктов'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var query = await showDialog<String>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Поиск'),
                    content: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(hintText: 'Введите запрос'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          _searchProducts();
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
              if (query != null) {
                setState(() {
                  _searchQuery = query;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.all(16.0),
          child: _products.isEmpty
              ? Center(
                  child: Text(
                    'Введите запрос',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        title: Text(_products[index]['food']['label'],
                            style: TextStyle(color: Colors.black)),
                        leading: _products[index]['food']['image'] != null &&
                                _products[index]['food']['image'].isNotEmpty
                            ? SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: Image.network(
                                    _products[index]['food']['image'],
                                    fit: BoxFit.cover),
                              )
                            : SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: Icon(Icons.image, color: Colors.white),
                              ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                  foodId: _products[index]['food']['foodId']),
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
