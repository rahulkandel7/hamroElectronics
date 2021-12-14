import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamro_electronics/controllers/bannerController.dart';
import 'package:hamro_electronics/controllers/toppicksController.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/authController.dart';

import '../widgets/homeproduct.dart';
import '../widgets/slideshowitems.dart';
import '../controllers/productController.dart';
import '../controllers/categoryController.dart';
import '../controllers/wishlistController.dart';
import '../widgets/toppicks.dart';
import '../controllers/cartController.dart';
import '../models/product.dart';
import '../screens/product_view_screen.dart';
import '../screens/category_screen_items.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/notifications_screen.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/hamro";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authController = Get.put(AuthController());
  final productController = Get.put(ProductController());
  final categoryController = Get.put(CategoryController());
  final wishlistController = Get.put(WishlistController());
  final cartController = Get.find<CartController>();
  final bannerController = Get.put(BannerController());
  final toppicksController = Get.put(ToppicksController());

  final searchKey = GlobalKey<FormState>();

  String userName = "";
  String token = "";
  int userid = 0;
  String uphoto = "";

  _getUserName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');
    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      userName = userDecoded["name"];
      userid = userDecoded["id"] as int;
      uphoto = userDecoded["photopath"];
      token = _prefs.getString('token').toString();
    });
  }

  @override
  void initState() {
    super.initState();
    productController.fetchproducts();
    _getUserName().then((_) {
      wishlistController.fetchWishlist(userid.toString());
    });
    categoryController.fetchCtaegory();
    cartController.fetchCart(userid.toString());
    toppicksController.fetchToppicks();
  }

  //Widget For title
  Widget title(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          // TextButton(
          //   style: TextButton.styleFrom(
          //     primary: Colors.grey[700],
          //   ),
          //   onPressed: () => print('See more'),
          //   child: const Text(
          //     'See More',
          //     style: TextStyle(
          //       fontSize: 16,
          //       color: Colors.indigo,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  _onRefresh() async {
    await productController.fetchproducts();
  }

  getItems() {
    return Obx(() {
      return Column(
        children: categoryController.category.map((element) {
          var selectedCategory = productController.product
              .where((p0) => p0.categoryId == element.id)
              .toList();

          return SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        element.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.grey[700],
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              CategoryScreenItems.routeName,
                              arguments: element.id);
                        },
                        child: const Text(
                          'See More',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        return HomeProduct(
                          userid: userid,
                          id: selectedCategory[i].id,
                          name: selectedCategory[i].name,
                          price: selectedCategory[i].price,
                          discountedPrice: selectedCategory[i].discountedPrice,
                          photopath1: selectedCategory[i].photoPath1,
                        );
                      },
                      itemCount: selectedCategory.length < 10
                          ? selectedCategory.length
                          : 10,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: double.infinity,
                    child: Image.network(
                      'https://hamroelectronics.com.np/images/slide/main2.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  showFlashSale() {
    return Obx(() {
      return Visibility(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Flash Sale',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      const Card(
                        color: Colors.indigo,
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 8.0,
                          ),
                          child: Text(
                            '12',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: const Text(
                          ':',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Card(
                        color: Colors.indigo,
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 8.0,
                          ),
                          child: Text(
                            '42',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: const Text(
                          ':',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Card(
                        color: Colors.indigo,
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 8.0,
                          ),
                          child: Text(
                            '55',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  var flashproduct = productController.product
                      .where((p0) => p0.flashSale == 1)
                      .toList();
                  return Toppicks(
                    userid: userid,
                    id: flashproduct[i].id,
                    name: flashproduct[i].name,
                    price: flashproduct[i].price,
                    discountedPrice: flashproduct[i].discountedPrice,
                    photopath1: flashproduct[i].photoPath1,
                  );
                },
                itemCount: productController.product
                    .where((p0) => p0.flashSale != 0)
                    .toList()
                    .length,
              ),
            ),
          ],
        ),
        visible: productController.product
                    .where((p0) => p0.flashSale == 1)
                    .toList()
                    .length ==
                0
            ? false
            : true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.height * 0.01,
                    horizontal: mediaQuery.width * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(NotificationScreen.routeName);
                                },
                                icon: const Icon(
                                  Icons.notifications_none_outlined,
                                  size: 30,
                                ),
                              ),
                              const Positioned(
                                top: 10,
                                right: 15,
                                child: CircleAvatar(
                                  maxRadius: 5,
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: mediaQuery.height * 0.12,
                        child: Image.asset('assets/logo/logo.png'),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(EditProfileScreen.routeName);
                            },
                            child: CircleAvatar(
                              maxRadius: mediaQuery.width * 0.05,
                              backgroundImage: NetworkImage(
                                  'https://hamroelectronics.com.np/images/users/$uphoto'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * 0.03,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(
                              productController.product.toList()),
                        );
                      },
                      child: Container(
                        width: mediaQuery.width * 0.93,
                        height: mediaQuery.height * 0.05,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade500,
                          ),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.width * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FittedBox(
                                fit: BoxFit.fill,
                                child: const Text(
                                  'Search on Hamro Electronics..',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.search_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    top: 14.0,
                    bottom: 4.0,
                  ),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      'Hello $userName 👋',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 18.0,
                    top: 1.0,
                    bottom: 20.0,
                  ),
                  child: Text(
                    "Let's shop Somethings?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                ),
                CarouselSlider.builder(
                  itemCount: bannerController.banner.length,
                  itemBuilder: (context, index, realIndex) => SlideShowItem(
                    url: bannerController.banner[index].image,
                  ),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 160,
                    // aspectRatio: 21 / 9,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                showFlashSale(),
                title(context, 'Top Picks'),
                FutureBuilder(
                    future: toppicksController.fetchToppicks(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          height: mediaQuery.height * 0.36,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return Obx(() {
                                return HomeProduct(
                                  userid: userid,
                                  id: toppicksController.toppicks[i].id,
                                  name: toppicksController.toppicks[i].name,
                                  price: toppicksController.toppicks[i].price,
                                  discountedPrice: toppicksController
                                      .toppicks[i].discountedPrice,
                                  photopath1:
                                      toppicksController.toppicks[i].photoPath1,
                                );
                              });
                            },
                            itemCount: toppicksController.toppicks.length,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                          ),
                        );
                      }
                    }),
                SizedBox(
                  height: mediaQuery.height * 0.01,
                ),
                title(context, 'Categories'),
                FutureBuilder(
                    future: categoryController.fetchCtaegory(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          height: mediaQuery.height * 0.14,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryController.category.length,
                            itemBuilder: (ctx, i) {
                              return Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        CategoryScreenItems.routeName,
                                        arguments:
                                            categoryController.category[i].id);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: mediaQuery.width * 0.02,
                                    ),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://hamroelectronics.com.np/images/categories/${categoryController.category[i].image}'),
                                          maxRadius: 30,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: mediaQuery.height * 0.002),
                                          child: Text(
                                            categoryController.category[i].name,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                          ),
                        );
                      }
                    }),
                SizedBox(
                  height: mediaQuery.height * 0.1,
                  width: double.infinity,
                  child: Image.network(
                    'https://hamroelectronics.com.np/images/slide/main1.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                getItems(),
                SizedBox(
                  height: mediaQuery.height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<Product> product;

  CustomSearchDelegate(this.product);
  @override
  List<Widget>? buildActions(BuildContext context) {
    IconButton(
      onPressed: () {
        query = "";
      },
      icon: const Icon(
        Icons.close,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.backpack,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    List<int> matchQueryId = [];

    for (var p in product) {
      if (p.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(p.name);
        matchQueryId.add(p.id);
      }
    }

    return ListView.builder(
      itemBuilder: (ctx, i) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductViewScreen.routeName,
                arguments: matchQueryId[i]);
          },
          child: ListTile(
            title: Text(matchQuery[i]),
          ),
        );
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    List<int> matchQueryId = [];

    for (var p in product) {
      if (p.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(p.name);
        matchQueryId.add(p.id);
      }
    }

    return ListView.builder(
      itemBuilder: (ctx, i) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductViewScreen.routeName,
                arguments: matchQueryId[i]);
          },
          child: ListTile(
            title: Text(matchQuery[i]),
          ),
        );
      },
      itemCount: matchQuery.length,
    );
  }
}
