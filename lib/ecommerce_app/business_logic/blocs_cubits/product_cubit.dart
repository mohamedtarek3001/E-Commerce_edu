import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model_layer/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());
  late ImagePicker picker;

  File? image;
  String? imageUrl;
  late FirebaseFirestore fireStore;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  var supabaseService = Supabase.instance.client;



  Future pickImage() async {
    try{
      picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null){
        image = File(pickedImage.path);
        emit(ImagePicked());
        await uploadImage();
        return null;
      }else{
        image = null;
        emit(ImageNotPicked());
        return false;
      }
    } catch(e){
      emit(ImagePickedError(e.toString()));
      return e.toString();
    }

  }
  
  Future uploadImage() async{
    if(image == null){
      return false;
    }
    try{
      emit(ImageUploading());
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';
      imageUrl = await supabaseService.storage.from('pictures').upload(path, image!);
      if(imageUrl != null){
        imageUrl = "https://ipyemewznxaiwpenndob.supabase.co/storage/v1/object/public/$imageUrl";
        emit(ImageUploaded());
        return null;
      }else{
        emit(ImageNotUploaded());
        return false;
      }
    } catch(e){
      emit(ImageUploadError(e.toString()));
      print(e.toString());
      return e.toString();
    }
  }

  List<ProductModel>? products = [];

  ProductModel createProduct(String productId){
    return ProductModel(
      id: productId,
      image: imageUrl,
      name: nameController.text,
      price: double.tryParse(priceController.text??''),
      description: descriptionController.text,
      quantity: int.tryParse(quantityController.text),
    );
  }


  Future uploadProduct() async{
    fireStore = FirebaseFirestore.instance;
    try{
      emit(ProductCreationLoading());
      String productId = fireStore.collection('Products').doc().id;
      await fireStore.collection('Products').doc(productId).set(
        createProduct(productId).toJson(),
      );
      emit(ProductCreationSuccess());
    }catch (e){
      emit(ProductCreationFail(e.toString()));
    }
  }


  Future getProducts() async{
    fireStore = FirebaseFirestore.instance;
    try{
      emit(ProductRetrievingLoading());
      var rawProducts = await fireStore.collection('Products').get();
      products = rawProducts.docs.map((e) => ProductModel.fromJson(e.data()),).toList();
      emit(ProductRetrievingSuccess());
    }catch (e){
      emit(ProductRetrievingFail(e.toString()));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsStream() async*{
    fireStore = FirebaseFirestore.instance;
    yield* fireStore.collection('Products').snapshots();
  }


}
