import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController {
  postOrder(int userId, String name, String address, String phone, int areaid,
      int charge) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/596810BITS/order/store');
    final jsons = {
      'userid': userId.toString(),
      'fullname': name.toString(),
      'shipping': address.toString(),
      'phone': phone.toString(),
      'area_id': areaid.toString(),
      'deliverycharge': charge.toString(),
      'payment': 'COD'
    };
    final response = await http
        .post(url, body: jsons, headers: {'Accept': 'application/json'});
    print(response.body);
  }
}
