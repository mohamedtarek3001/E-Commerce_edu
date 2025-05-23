import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/ecommerce_app/business_logic/blocs_cubits/product_cubit.dart';
import 'package:untitled2/ecommerce_app/presentation_layer/widgets/product_card_widget.dart';

import '../../../model_layer/product_model.dart';
import '../../widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final imageUrl = 'https://img.freepik.com/free-vector/gradient-product-card-template_23-2149656335.jpg';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<ProductCubit>(context).getProducts();
          },
          child: SingleChildScrollView(
            child:  Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(color: Color(0x80000000), width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(color: Color(0x80000000), width: 0.5),
                        ),
                        hintText: 'What you are looking for...',
                        hintStyle: const TextStyle(color: Color(0x80000000), fontSize: 14),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[300],
                          size: 30,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Hello Ahmed , ',
                        style: TextStyle(fontSize: 20, color: Color(0xff576A69), fontWeight: FontWeight.w500, height: 2),
                      ),
                      Text(
                        'What you are looking for',
                        style: TextStyle(fontSize: 23, color: Color(0xff576A69), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 160 * 0.775,
                    width: width,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          image: 'assets/appIcons/medicalService.svg',
                          index: index,
                          label: 'Medical Services',
                        );
                      },
                      itemCount: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 260,
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Top rated sale',
                          style: TextStyle(color: Color(0xff576A69), fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: BlocProvider.of<ProductCubit>(context).getProductsStream(),
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              else if(snapshot.hasError){
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }
                              else if(!snapshot.hasData){
                                return const Center(
                                  child: Text('No data'),
                                );
                              }
                              else if(snapshot.hasData){
                                List<ProductModel>? products = [];
                                products = snapshot.data?.docs.map((e) => ProductModel.fromJson(e.data()),).toList();
                                return ListView.separated(
                                  separatorBuilder: (context, index) => const SizedBox(
                                    width: 10,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                      imageUrl: products?[index].image??'',
                                      name: products?[index].name??'',
                                      price: products?[index].price??0.0,
                                      rate: 0.0,
                                    );
                                  },
                                  itemCount: products?.length??0,
                                );
                              } else{
                                return Container();
                              }

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 260,
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Most Recommended',
                          style: TextStyle(color: Color(0xff576A69), fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: BlocBuilder<ProductCubit, ProductState>(
                            builder: (context, state) {
                              if(state is ProductRetrievingLoading){
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }else if (state is ProductRetrievingFail){
                                return Center(
                                  child: Text(state.error),
                                );
                              }
                              return ListView.separated(
                                separatorBuilder: (context, index) => const SizedBox(
                                  width: 10,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    imageUrl: context.read<ProductCubit>().products?[index].image??'',
                                    name: context.read<ProductCubit>().products?[index].name??'',
                                    price: context.read<ProductCubit>().products?[index].price??0.0,
                                    rate: 0,
                                  );
                                },
                                itemCount: context.read<ProductCubit>().products?.length??0,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
        ),
    );
  }
}
