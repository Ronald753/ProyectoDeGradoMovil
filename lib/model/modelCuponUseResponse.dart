class CuponResponse {
  final int? idCupon;
  final int? porcentajeDescuento;
  final String? error;

  CuponResponse({this.idCupon, this.porcentajeDescuento, this.error});

  // Método para convertir un JSON a un objeto CuponResponse
  factory CuponResponse.fromJson(Map<String, dynamic> json) {
    return CuponResponse(
      idCupon: json['id_cupon'],
      porcentajeDescuento: json['porcentaje_descuento'],
      error: json['error'],
    );
  }

  // Método para convertir el objeto CuponResponse a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id_cupon': idCupon,
      'porcentaje_descuento': porcentajeDescuento,
      'error': error,
    };
  }
}