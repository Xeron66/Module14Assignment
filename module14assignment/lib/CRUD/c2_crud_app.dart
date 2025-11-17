import 'package:flutter/material.dart';
import 'package:module14assignment/CRUD/controller/product_controller.dart';
import 'package:module14assignment/CRUD/model/product_model.dart';

class C2ApiCall extends StatefulWidget {
  const C2ApiCall({super.key});

  @override
  State<C2ApiCall> createState() => _C2ApiCallState();
}

class _C2ApiCallState extends State<C2ApiCall> {
  ProductController productController = ProductController();
  

  @override
  void initState(){
    super.initState();
    fetchData();
  }
  
  Future fetchData() async {
    await productController.fetchProducts();

    if (mounted) setState(() {});
  }
  
  productDialog(String label, Data? item) {
    TextEditingController productNameController = TextEditingController();
    TextEditingController productImageController = TextEditingController();
    TextEditingController productQuantityController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();
    
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text(label),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: 'Name'
              ),
            ),
            SizedBox(height: 8,),
        
            TextField(
              controller: productImageController,
              decoration: InputDecoration(
                labelText: 'Image'
              ),
            ),
            SizedBox(height: 8,),
        
            TextField(
              controller: productQuantityController,
              decoration: InputDecoration(
                labelText: 'Quantity'
              ),
            ),
            SizedBox(height: 8,),
        
            TextField(
              controller: productUnitPriceController,
              decoration: InputDecoration(
                labelText: 'Unit Price'
              ),
            ),
            SizedBox(height: 8,),
        
            TextField(
              controller: productTotalPriceController,
              decoration: InputDecoration(
                labelText: 'Total Price'
              ),
            ),
            SizedBox(height: 8,),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text('Cancel')
                ),
                ElevatedButton(
                  onPressed: () async {
                    label == 'Add Product' 
                    // using ternary operator to select 
                    // whether its gonna be update or create
                    ? await productController.createProduct(Data(
                      productName: productNameController.text,
                      img: productImageController.text,
                      qty: int.parse(productQuantityController.text),
                      unitPrice: int.parse(productUnitPriceController.text),
                      totalPrice: int.parse(productTotalPriceController.text)
                    ))
                    : await productController.updateProduct(Data(
                      sId: item?.sId,
                      productName: productNameController.text,
                      img: productImageController.text,
                      qty: int.tryParse(productQuantityController.text),
                      unitPrice: int.tryParse(productUnitPriceController.text),
                      totalPrice: int.tryParse(productTotalPriceController.text)
                    ));

                    await fetchData();
                    if (mounted) Navigator.pop(context); 
                  }, 
                  child: Text('Save')
                )
              ],
            )          
          ],
        ),
      ),
    ));
  }


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
      : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8
        ), 
        itemCount: ProductController.products.length,
        itemBuilder: (context, index) {
          final item = ProductController.products[index];
          return Card(
            child: Column(
              children: [
                SizedBox(
                  height: 140,
                  child: Image.network(item.img.toString()),
                ),
                Text(
                  item.productName.toString(),
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Price: \$${item.unitPrice} | Qty: ${item.qty}'
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: (){
                        productDialog('Update Product', item);
                      }, 
                      icon: Icon(Icons.edit, color: Colors.orange,)
                    ),
                    IconButton(
                      onPressed: () async {
                        await ProductController().deleteProduct(item.sId.toString()).then((value) async {
                          if (value) {
                            await fetchData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Product Deleted!'))
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Something Went Wrong!'))
                            );
                          }
                        });
                      }, 
                      icon: Icon(Icons.delete, color: Colors.red,)
                    )
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }
}