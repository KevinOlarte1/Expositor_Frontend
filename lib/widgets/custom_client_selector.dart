import 'package:flutter/material.dart';
import '../models/cliente.dart';

Future<Cliente?> mostrarSelectorCliente(
  BuildContext context, {
  required List<Cliente> clientes,
  Cliente? clienteActual,
}) async {
  Cliente? clienteSeleccionado = clienteActual;

  await showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E1E1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Seleccionar cliente",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: clientes.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Colors.white24, height: 1),
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
                  final bool isSelected =
                      clienteActual != null && cliente.id == clienteActual.id;

                  return ListTile(
                    title: Text(
                      cliente.nombre,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      clienteSeleccionado = cliente;
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );

  return clienteSeleccionado;
}
