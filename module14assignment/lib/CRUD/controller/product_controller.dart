import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:module14assignment/CRUD/model/product_model.dart';
import 'package:module14assignment/CRUD/utils/urls.dart';

class ProductController {

  static List<Data> products = [];
  static bool isLoading = false;

  Future fetchProducts() async {
    final response = await http.get(Uri.parse(Urls.ReadProduct));

    if(response.statusCode == 200) {
      isLoading = false;
      final data = jsonDecode(response.body);  // json to string

      ProductModel model = ProductModel.fromJson(data);
      products = model.data ?? [];             // stores instances of Data
    }
  }

  Future<bool> deleteProduct (String productId) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(productId)));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createProduct (Data data) async {
    final response = await http.post(Uri.parse(Urls.createProduct),
      headers: {
        "Content-Type": 'application/json'
      },
      body: jsonEncode(
        {
          "ProductName": data.productName,
          "ProductCode": DateTime.now().microsecondsSinceEpoch,
          "Img": data.img,
          "Qty": data.qty,
          "UnitPrice": data.unitPrice,
          "TotalPrice": data.totalPrice
        }
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


Future<bool> updateProduct (Data data) async {
    // 1. Get the ID. This is essential for the URL.
    //    We must check for null here in case data.sId is not provided.
    final String? pId = data.sId;
    if (pId == null) {
      return false;
    }

    // 2. Create a dynamic map for *only* the fields we want to update.
    final Map<String, dynamic> fieldsToUpdate = {};

    // 3. Check each field. If it's not null, add it to the map.
    //    This prevents sending nulls and overwriting existing data.
    if (data.productName != null && data.productName!.isNotEmpty) {
      fieldsToUpdate['ProductName'] = data.productName;
    }
    if (data.img != null && data.img!.isNotEmpty) {
      fieldsToUpdate['Img'] = data.img;
    }
    if (data.qty != null) {
      fieldsToUpdate['Qty'] = data.qty;
    }
    if (data.unitPrice != null) {
      fieldsToUpdate['UnitPrice'] = data.unitPrice;
    }
    if (data.totalPrice != null) {
      fieldsToUpdate['TotalPrice'] = data.totalPrice;
    }

    // 4. (Safety Check) If no new data was provided, don't make an API call.
    if (fieldsToUpdate.isEmpty) {
      return true; // Not a failure, just nothing to do.
    }

    // 5. Send the request with the *partial* data.
    final response = await http.post(Uri.parse(Urls.updateProduct(pId)),
      headers: {
        "Content-Type": 'application/json'
      },
      // Encode the dynamic map, which only contains the fields you provided
      body: jsonEncode(fieldsToUpdate)
    );
    
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}