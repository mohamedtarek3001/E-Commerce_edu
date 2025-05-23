import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled2/ecommerce_app/business_logic/blocs_cubits/product_cubit.dart';

import '../../widgets/custom_input_field.dart';

class ProductAdditionScreen extends StatelessWidget {
  ProductAdditionScreen({super.key});

  var commonTextStyle = const TextStyle(color: Color(0xff576A69), fontSize: 17, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                'Hello john_doe',
                style: commonTextStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Upload product', style: TextStyle(color: Color(0xff22C7B6), fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Product Images',
                    style: commonTextStyle,
                  ),
                  BlocConsumer<ProductCubit, ProductState>(
                    listener: (context, state) {
                      if (state is ImagePicked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.greenAccent,
                            content: Text('Image Picked Successfully'),
                          ),
                        );
                      } else if (state is ImagePickedError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(state.error),
                          ),
                        );
                      }
                      if (state is ImageUploaded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.greenAccent,
                            content: Text('Image Uploaded Successfully'),
                          ),
                        );
                      } else if (state is ImageUploadError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(state.error),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      var image = context.read<ProductCubit>().image;
                      return InkWell(
                        onTap: () async {
                          await context.read<ProductCubit>().pickImage();
                        },
                        child: Container(
                          height: 142,
                          width: width,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: image != null ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xCCD9E1E7),
                            ),
                          ),
                          child: image != null
                              ? Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              state is ImageUploading
                                  ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff22C7B6),
                                ),
                              )
                                  : Container(),
                            ],
                          )
                              : Column(
                            children: [
                              SvgPicture.asset('assets/appIcons/UploadIcon.svg'),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Supported formats: JPEG, PNG, GIF, MP4, PDF, PSD, AI, Word, PPT',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xff676767), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      return ProductInputField(
                        isPassword: false,
                        isVisible: true,
                        title: 'Name',
                        controller: context.read<ProductCubit>().nameController,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      return ProductInputField(
                        isPassword: false,
                        isVisible: true,
                        title: 'Description',
                        maxLines: 4,
                        controller: context.read<ProductCubit>().descriptionController,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return ProductInputField(
                              isPassword: false,
                              isVisible: true,
                              title: 'Price',
                              controller: context.read<ProductCubit>().priceController,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return ProductInputField(
                              isPassword: false,
                              isVisible: true,
                              title: 'quantity',
                              controller: context.read<ProductCubit>().quantityController,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocConsumer<ProductCubit, ProductState>(
                    listener: (context, state) {
                      if (state is ProductCreationSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.greenAccent,
                            content: Text('Product Created Successfully'),
                          ),
                        );
                      } else if (state is ProductCreationFail) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(state.error),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          backgroundColor: const Color(0xff22C7B6),
                          foregroundColor: Colors.white,
                          minimumSize: Size(width, 56),
                          maximumSize: Size(width, 56),
                        ),
                        onPressed: state is ProductCreationLoading
                            ? null
                            : () async {
                          await context.read<ProductCubit>().uploadProduct();
                        },
                        child: state is ProductCreationLoading
                            ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Save changes',
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
