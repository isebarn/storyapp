class HttpResponse<T> {
  Status? status;
  T? responseBody;
  String? message;

  HttpResponse.loading(this.message) : status = Status.loading;
  HttpResponse.completed(this.responseBody) : status = Status.completed;
  HttpResponse.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $responseBody";
  }
}

enum Status { loading, completed, error }
