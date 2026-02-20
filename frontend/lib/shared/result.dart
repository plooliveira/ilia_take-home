// Result abstract and Ok and Err classes

abstract class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  final T value;

  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final String error;

  const Err(this.error);
}
