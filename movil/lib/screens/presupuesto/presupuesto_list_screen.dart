// lib/screens/presupuesto/presupuesto_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/presupuesto_provider.dart';
import 'presupuesto_edit_screen.dart';

class PresupuestoListScreen extends StatefulWidget {
  const PresupuestoListScreen({super.key});

  @override
  State<PresupuestoListScreen> createState() => _PresupuestoListScreenState();
}

class _PresupuestoListScreenState extends State<PresupuestoListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos los datos cuando la pantalla se inicia por primera vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PresupuestoProvider>(context, listen: false).fetchPresupuestos();
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocurrió un Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presupuestoProvider = Provider.of<PresupuestoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos'),
      ),
      body: presupuestoProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => presupuestoProvider.fetchPresupuestos(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0), // Añadimos padding a la lista
                itemCount: presupuestoProvider.presupuestos.length,
                itemBuilder: (ctx, i) {
                  final presupuesto = presupuestoProvider.presupuestos[i];
                  return Card(
                    elevation: 3,
                    shadowColor: Colors.black.withOpacity(0.1),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo[100],
                          child: const Icon(Icons.attach_money, color: Colors.indigo),
                        ),
                        title: Text(presupuesto.descripcion, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Monto: \$${presupuesto.montoTotal}'),
                            Text('Empresa: ${presupuesto.empresaNombre}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón de Editar con un estilo más definido
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.orange),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => PresupuestoEditScreen(presupuesto: presupuesto),
                                  ),
                                );
                              },
                            ),
                            // Botón de Borrar
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                try {
                                  await presupuestoProvider.deletePresupuesto(presupuesto.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Presupuesto eliminado'), backgroundColor: Colors.green)
                                  );
                                } catch (error) {
                                  _showErrorDialog('No se pudo eliminar el presupuesto.');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}