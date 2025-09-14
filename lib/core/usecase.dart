/// Core: definición simple de UseCase para usar en domain layer.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}
