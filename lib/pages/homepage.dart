import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Map<String, dynamic> rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });
}

class ProductListView extends StatefulWidget {
  const ProductListView({Key? key}) : super(key: key);

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    with TickerProviderStateMixin {
  List<Product> productList = [];
  List<Product> filteredProductList = [];
  int limit = 15; // Initial limit
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  late TextEditingController _searchController;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getProductList(limit);
    _searchController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list
      // Load more products
      limit += 5; // Increase the limit by 10
      getProductList(limit);
    }
  }

  Future<void> getProductList(int limit) async {
    setState(() {
      isLoading = true; // Set isLoading to true when loading data
    });
    try {
      final http.Response response = await http.get(
        Uri.parse("https://fakestoreapi.com/products?limit=$limit"),
        headers: {'content-type': 'Application/json'},
      );
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        productList = responseData
            .map((data) => Product(
                  id: data['id'],
                  title: data['title'],
                  price: data['price'].toDouble(),
                  description: data['description'],
                  category: data['category'],
                  image: data['image'],
                  rating: data['rating'],
                ))
            .toList();
        filteredProductList = List.from(productList);
        isLoading = false; // Initialize filtered list with all products
      });
    } catch (e) {
      print("Error fetching product list: $e");
      setState(() {
        isLoading =
            false; // Ensure isLoading is set back to false even if an error occurs
      });
    }
  }

  void _searchProducts(String query) {
    setState(() {
      filteredProductList = productList
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f9fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: _searchProducts,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Showing ${filteredProductList.length} products',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _animation,
                    child: isLoading
                        ? _buildShimmerEffect()
                        : ListView.builder(
                            itemCount: filteredProductList.length,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              Product product = filteredProductList[index];
                              print(productList.length);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  // Adjust the height of the container
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(8),
                                    leading: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(product.image),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      product.title.length > 48
                                          ? '${product.title.substring(0, 48)}...'
                                          : product.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 16),
                                        Text(
                                          product.category,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildStarRating(
                                                product.rating['rate']),
                                            SizedBox(width: 8),
                                            Text(
                                              '\$${product.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // Handle tap on the product
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10, // Example itemCount
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              width: 200,
              height: 16,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8.0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStarRating(num rate) {
    int starCount = rate.round(); // Convert num to int
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < starCount ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 16,
        ),
      ),
    );
  }
}


