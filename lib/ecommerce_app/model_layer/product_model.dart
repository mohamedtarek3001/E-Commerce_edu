class ProductModel{
  String? id;
  String? name;
  String? description;
  String? image;
  double? price;
  int? quantity;


  ProductModel({this.id, this.name, this.description, this.image, this.price, this.quantity});

  factory ProductModel.fromJson(Map<String,dynamic> json){
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }


  toJson(){
    return {
      'id':id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}