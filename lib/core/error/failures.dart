import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.message = ''});
  final String message;

  @override
  List<Object> get props => [message];
}

// Error de servidor (cuando hay problemas con la API)
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Ha ocurrido un error en el servidor'});
}

// Error de conexión a internet
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No hay conexión a internet'});
}

// Error de caché
class CacheFailure extends Failure {
  const CacheFailure(
      {super.message = 'Error al acceder al almacenamiento local',});
}

// Error de datos inválidos
class InvalidDataFailure extends Failure {
  const InvalidDataFailure(
      {super.message = 'Los datos recibidos son inválidos',});
}

// Error genérico para casos no manejados específicamente
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'Ha ocurrido un error inesperado'});
}
