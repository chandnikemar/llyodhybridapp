// Enum for representing different states of the resource
enum Status { loading, success, error }


class Resource<T> {
  final Status status;
  final T? data;
  final String? message;

  Resource._(this.status, {this.data, this.message});

  // Factory constructor for success state
  factory Resource.success(T data) {
    return Resource._(Status.success, data: data);
  }

  // Factory constructor for error state
  factory Resource.error(String message) {
    return Resource._(Status.error, message: message);
  }

  // Factory constructor for loading state
  factory Resource.loading() {
    return Resource._(Status.loading);
  }
}
