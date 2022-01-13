import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/homeproduct.dart';
import '../widgets/slideshowitems.dart';
import '../controllers/productController.dart';
import '../controllers/categoryController.dart';
import '../controllers/wishlistController.dart';
import '../widgets/toppicks.dart';
import '../controllers/cartController.dart';
import '../screens/cartScreen.dart';
import '../models/product.dart';
import '../screens/product_view_screen.dart';
import '../screens/category_screen_items.dart';
import '../screens/notifications_screen.dart';
import '../controllers/bannerController.dart';
import '../controllers/notificationController.dart';
import '../controllers/toppicksController.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/hamro";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productController = Get.put(ProductController());
  final categoryController = Get.put(CategoryController());
  final wishlistController = Get.put(WishlistController());
  final cartController = Get.put(CartController());
  final bannerController = Get.put(BannerController());
  final toppicksController = Get.put(ToppicksController());
  final notificationController = Get.put(NotificationController());

  final searchKey = GlobalKey<FormState>();

  String userName = "";
  String token = "";
  int userid = 0;
  String? uphoto;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
      cartController.fetchCart(userid.toString());
    });
    notificationController.fetchNotification();
    bannerController.fetchBanner();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
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
            style: Theme.of(context).textTheme.headline5,
          ),
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
                        style: Theme.of(context).textTheme.headline5,
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
      backgroundColor: Theme.of(context).backgroundColor,
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
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          NotificationScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.notifications_none_outlined,
                                ),
                              ),
                              // const Positioned(
                              //   top: 10,
                              //   right: 15,
                              //   child: CircleAvatar(
                              //     maxRadius: 5,
                              //     backgroundColor: Colors.red,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: SizedBox(
                          width: mediaQuery.height * 0.12,
                          child: Image.asset('assets/logo/logo.png'),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      CartScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.shopping_cart_outlined,
                                ),
                                Positioned(
                                  right: 0,
                                  top: -5,
                                  child: CircleAvatar(
                                      child: FittedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Obx(
                                            () {
                                              return Text(
                                                  '${cartController.length.value}');
                                            },
                                          ),
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                      maxRadius: 7),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                                child: Text(
                                  'Search on Hamro Electronics..',
                                  style: Theme.of(context).textTheme.subtitle1,
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
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    top: 1.0,
                    bottom: 20.0,
                  ),
                  child: Text(
                    "Let's shop Somethings?",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Column(
                  children: [
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
                            height: mediaQuery.height * 0.353,
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
                                    photopath1: toppicksController
                                        .toppicks[i].photoPath1,
                                  );
                                });
                              },
                              itemCount: toppicksController.toppicks.length,
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: mediaQuery.height * 0.36,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, i) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      width: mediaQuery.width * 0.4,
                                      height: mediaQuery.height * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      width: mediaQuery.width * 0.4,
                                      height: mediaQuery.height * 0.03,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      width: mediaQuery.width * 0.2,
                                      height: mediaQuery.height * 0.02,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade300,
                                      ),
                                    )
                                  ],
                                );
                              },
                              itemCount: 5,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.01,
                    ),
                    title(context, 'Categories'),
                    FutureBuilder(
                        future: categoryController.fetchCtaegory(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                                            arguments: categoryController
                                                .category[i].id);
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
                                                  top: mediaQuery.height *
                                                      0.005),
                                              child: Text(
                                                categoryController
                                                    .category[i].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                textAlign: TextAlign.center,
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
                            return SizedBox(
                              height: mediaQuery.height * 0.14,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryController.category.length,
                                itemBuilder: (ctx, i) {
                                  return Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey.shade300,
                                        maxRadius: 30,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(3),
                                        width: mediaQuery.width * 0.2,
                                        height: mediaQuery.height * 0.02,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                  ],
                ),
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
    // IconButton(
    //   onPressed: () {
    //     query = "";
    //   },
    //   icon: const Icon(
    //     Icons.close,
    //   ),
    // );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // IconButton(
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    //   icon: const Icon(
    //     Icons.backpack,
    //   ),
    // );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    List<int> matchQueryId = [];
    List<String> matchQueryImage = [];
    List<int> matchQueryPrice = [];
    List<int> matchQueryDisPrice = [];

    for (var p in product) {
      if (p.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(p.name);
        matchQueryImage.add(p.photoPath1);
        matchQueryPrice.add(p.price);
        matchQueryDisPrice.add(p.discountedPrice ?? 0);
        matchQueryId.add(p.id);
      }
    }
    var mediaQuery = MediaQuery.of(context).size;

    return ListView.builder(
      itemBuilder: (ctx, i) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductViewScreen.routeName,
                arguments: matchQueryId[i]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: mediaQuery.height * 0.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/logo/logo.png',
                        image:
                            'https://hamroelectronics.com.np/images/product/${matchQueryImage[i]}',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: mediaQuery.width * 0.6,
                    child: Padding(
                      padding: EdgeInsets.only(left: mediaQuery.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            matchQuery[i],
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            maxLines: 2,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: mediaQuery.height * 0.01),
                            child: Row(
                              children: [
                                matchQueryDisPrice[i] == 0
                                    ? Text(
                                        'Rs ${matchQueryPrice[i]}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red[800],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Rs ${matchQueryPrice[i]}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: mediaQuery.width * 0.01),
                                            child: Text(
                                              'Rs ${matchQueryDisPrice[i]}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red[800],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
