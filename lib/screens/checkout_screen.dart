import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/areaController.dart';
import '../models/area.dart';
import '../controllers/cartController.dart';
import '../controllers/orderController.dart';
import '../screens/navbar.dart';

class CheckOutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final areaController = Get.put(AreaController());
  final orderController = Get.put(OrderController());
  final cartController = Get.find<CartController>();

  final _orderForm = GlobalKey<FormState>();

  final FocusNode _shippingAddress = FocusNode();
  final FocusNode _phone = FocusNode();

  String _fullName = "";
  String _shipping = "";
  String _phoneNumber = "";

  String areaName = "Select Area";

  late int userId;
  late String? userName;
  late String userPhone;
  late String userAddress;

  _getUserInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');

    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      userId = userDecoded["id"] as int;
      userName = userDecoded["name"];
      userPhone = userDecoded["phone"];
      userAddress = userDecoded["address"];
    });
  }

  int orderedPrice = 0;

  @override
  void initState() {
    super.initState();
    orderedPrice = cartController.tc.value;
    areaController.fetchArea();
    _getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _shippingAddress.dispose();
    _phone.dispose();
  }

  int charge = 0;
  int areaId = 0;

  submitOrder() {
    _orderForm.currentState!.save();

    if (!_orderForm.currentState!.validate()) {
      return;
    }

    orderController
        .postOrder(userId, _fullName, _shipping, _phoneNumber, areaId, charge)
        .then((_) {
      Navigator.of(context).pushNamed(Navbar.routeName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Order Placed Sucessfully',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              1000,
            ),
          ),
          elevation: 5.0,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 29,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: mediaQuery.height * 0.02),
              child: Center(
                child: Text(
                  'Billing Info',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            Center(
              child: Text(
                'Total Products: ${cartController.length}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.05),
              child: Form(
                key: _orderForm,
                child: Column(
                  children: [
                    //Full Name
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQuery.height * 0.02,
                      ),
                      child: TextFormField(
                        initialValue: userName.toString(),
                        onSaved: (value) {
                          _fullName = value.toString();
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_shippingAddress);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Full Name";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'John Doe',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.indigo,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[300],
                            fontFamily: 'Poppins',
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.indigo,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          floatingLabelStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.indigo,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.indigo.shade100,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        cursorColor: Colors.indigo,
                        enabled: true,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    //Shipping Address
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQuery.height * 0.02,
                      ),
                      child: TextFormField(
                        initialValue: userAddress,
                        focusNode: _shippingAddress,
                        onSaved: (value) {
                          _shipping = value.toString();
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_phone);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Shipping Details";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'SahidChowk, Narayanghat',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Shipping Address',
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.indigo,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[300],
                          ),
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Colors.indigo,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          floatingLabelStyle: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.indigo,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.indigo.shade100,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        cursorColor: Colors.indigo,
                        enabled: true,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    //Phone Field
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQuery.height * 0.02,
                      ),
                      child: TextFormField(
                        initialValue: userPhone,
                        focusNode: _phone,
                        onSaved: (value) {
                          _phoneNumber = (value.toString());
                        },
                        validator: (value) {
                          if (value!.length != 10) {
                            return "Enter valid Phone Number";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.indigo,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[300],
                            fontFamily: 'Poppins',
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                            color:
                                Get.isDarkMode ? Colors.white : Colors.indigo,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          floatingLabelStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.indigo,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.indigo.shade100,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        cursorColor: Colors.indigo,
                        enabled: true,
                        enableSuggestions: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.02),
                      child: DropdownButtonFormField(
                        style: Theme.of(context).textTheme.bodyText1,
                        dropdownColor: Theme.of(context).backgroundColor,
                        validator: (value) {
                          if (areaId == 0) {
                            return "Select Sipping Area";
                          } else {
                            return null;
                          }
                        },
                        items: areaController.area.map((ele) {
                          return DropdownMenuItem(
                            value: ele.name,
                            child: Row(
                              children: [
                                const Icon(Icons.place),
                                Text(
                                  ele.name,
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (s) {
                          setState(() {
                            areaName = s.toString();
                          });
                          final Area _a = areaController.findArea(areaName);
                          areaId = _a.id;
                          charge = _a.charge;
                        },
                        decoration: InputDecoration(
                          hintText: 'Shipping Area',
                          hintStyle: Theme.of(context).textTheme.subtitle1,
                          contentPadding:
                              EdgeInsets.only(left: mediaQuery.width * 0.03),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.indigo.shade100,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.02),
                      child: Row(
                        children: [
                          Text(
                            'Order Amount:',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: mediaQuery.width * 0.02),
                            child: Text(
                              'Rs $orderedPrice',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      color: Colors.grey.shade400,
                    ),

                    //Delivery Charge

                    Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.02),
                      child: Row(
                        children: [
                          Text(
                            'Delivery Charge:',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: mediaQuery.width * 0.02),
                            child: Text(
                              'Rs $charge',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      color: Colors.grey.shade400,
                    ),

                    //Total amt
                    Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.02),
                      child: Row(
                        children: [
                          Text(
                            'Total Amount:',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: mediaQuery.width * 0.02),
                            child: Text(
                              'Rs ${orderedPrice + charge}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      color: Colors.grey.shade400,
                    ),

                    //Payment Method
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method:',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              value: true,
                              onChanged: (b) {
                                b = false;
                              },
                            ),
                            FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                'Cash on Delivery',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => submitOrder(),
              child: const Text(
                'Place Order',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
