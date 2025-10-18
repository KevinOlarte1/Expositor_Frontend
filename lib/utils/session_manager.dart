class SessionManager {
  static String? vendedorNombre;
  static int? vendedorId;
  static String? token;

  static void setVendedor({required int id, required String nombre}) {
    vendedorId = id;
    vendedorNombre = nombre;
  }

  static void clearSession() {
    vendedorId = null;
    vendedorNombre = null;
    token = null;
  }

  static bool get isLoggedIn => vendedorId != null;
}
