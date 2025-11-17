class Urls {
  static String baseURL = 'http://35.73.30.144:2008/api/v1';
  static String ReadProduct = '$baseURL/ReadProduct';
  static String deleteProduct (String id) => '$baseURL/DeleteProduct/$id';
  static String createProduct = '$baseURL/CreateProduct';
  
  static String updateProduct (String id) => '$baseURL/UpdateProduct/$id';
}