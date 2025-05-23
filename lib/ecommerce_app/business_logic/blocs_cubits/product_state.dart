part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}
final class ImagePicked extends ProductState {}
final class ImageNotPicked extends ProductState {}

final class ImagePickedError extends ProductState {
  final String error;
  ImagePickedError(this.error);
}

final class ProductCreationLoading extends ProductState {}
final class ProductCreationSuccess extends ProductState {}
final class ProductCreationFail extends ProductState {
  final String error;
  ProductCreationFail(this.error);
}


final class ProductRetrievingLoading extends ProductState {}
final class ProductRetrievingSuccess extends ProductState {}
final class ProductRetrievingFail extends ProductState {
  final String error;
  ProductRetrievingFail(this.error);
}


final class ImageUploading extends ProductState {}

final class ImageUploaded extends ProductState {}

final class ImageNotUploaded extends ProductState {}

final class ImageUploadError extends ProductState {
  final String error;
  ImageUploadError(this.error);
}
