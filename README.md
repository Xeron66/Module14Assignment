# Flutter CRUD App (Module 14 Assignment)

A simple Flutter CRUD (Create, Read, Update, Delete) application demonstrating API integration, state management, and clean project structure.  
This project uses a mock REST API and follows an organized folder architecture for scalability and readability.

---

## 📸 Screenshots

### **Home Screen**
![Home Screen](screenshots/screen1.png)

### **Create / Edit Product Screen**
![Create Product](screenshots/screen2.png)

---

## 📁 Project Structure
```
lib/
│
├── CRUD/
│ ├── api_collection/
│ │ └── CRUD.postman_collection.json
│ ├── controller/
│ │ └── product_controller.dart
│ ├── model/
│ │ └── product_model.dart
│ ├── utils/
│ │ └── urls.dart
│ ├── widgets/
│ └── c2_crud_app.dart
│
└── main.dart
```

---

# 📂 File Segments

---

## 1️⃣ `main.dart`

### **Overview**
The entry point of the Flutter application.  
Initializes the app and routes to the main CRUD screen.

### **Code**
```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module 14 Assignment',
      home: C2ApiCall()
    );
  }
}
```

## 2️⃣ `c2_crud_app.dart`

### **Overview**
This is the main screen of the CRUD app, this is where all the widgets are being built and viewed.

### **Code**
```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(

      // ---------- App Bar ----------
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),

      // ---------- Floating Action Button ----------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productDialog('Add Product', null);
        },child: Icon(Icons.add),
      ),

      // ---------- Body ----------
      body: ProductController.isLoading 
      ? Center(child: CircularProgressIndicator())
      : GridView.builder( . . .
```

## 3️⃣ `model/product_model.dart`

### **Overview**
Defines the Product model used throughout the app.
Handles JSON serialization/deserialization.

### **Code**
```dart
class ProductModel {
  String? status;
  List<Data>? data;

  ProductModel({this.status, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
```

## 4️⃣ `controller/product_controller.dart`

### **Overview**
Handles all CRUD operations:
Fetch, Create, Update, Delete.
Uses HTTP API defined in urls.dart.

### **Code**
```dart
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
```

## 5️⃣ `utils/urls.dart`

### **Overview**
Stores your API endpoints in one place. Helps avoid hard-coding URLs.

### **Code**
```dart
class Urls {
  static String baseURL = 'http://35.73.30.144:2008/api/v1';
  static String ReadProduct = '$baseURL/ReadProduct';
  static String deleteProduct (String id) => '$baseURL/DeleteProduct/$id';
  static String createProduct = '$baseURL/CreateProduct';
  
  static String updateProduct (String id) => '$baseURL/UpdateProduct/$id';
}
```

## 6️⃣ `api_collection/CRUD.postman_collection.json`

### **Overview**
A Postman API collection for testing CRUD endpoints.

### **Screen Shot**
<img width="1920" height="961" alt="image" src="https://github.com/user-attachments/assets/4ccd8ad2-999d-410d-934a-c2f2a81f735f" />

## 🚀 Installation & Setup Guide

### 1️⃣ Clone the Repository
**Clone The Repo**
```bash
git clone https://github.com/YourUsername/Module14Assignment.git
```

**Move to the Folder**
```bash
cd Module14Assignment
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Run the App

```bash
flutter run
```
