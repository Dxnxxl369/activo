// lib/screens/presupuesto/presupuesto_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/presupuesto.dart';
import '../../providers/presupuesto_provider.dart';

class PresupuestoEditScreen extends StatefulWidget {
  final Presupuesto presupuesto;

  const PresupuestoEditScreen({super.key, required this.presupuesto});

  @override
  State<PresupuestoEditScreen> createState() => _PresupuestoEditScreenState();
}

class _PresupuestoEditScreenState extends State<PresupuestoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Presupuesto _editedPresupuesto;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Creamos una copia del presupuesto para poder editarla sin afectar el original
    _editedPresupuesto = Presupuesto(
        id: widget.presupuesto.id,
        descripcion: widget.presupuesto.descripcion,
        fechaInicio: widget.presupuesto.fechaInicio,
        fechaFin: widget.presupuesto.fechaFin,
        montoTotal: widget.presupuesto.montoTotal,
        empresaId: widget.presupuesto.empresaId,
        empresaNombre: widget.presupuesto.empresaNombre
    );
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await Provider.of<PresupuestoProvider>(context, listen: false)
          .updatePresupuesto(_editedPresupuesto);
      Navigator.of(context).pop(); // Volver a la lista
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocurrió un error'),
          content: const Text('No se pudo guardar el presupuesto.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Presupuesto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedPresupuesto.descripcion,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese una descripción.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedPresupuesto.descripcion = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _editedPresupuesto.montoTotal,
                      decoration: const InputDecoration(labelText: 'Monto Total'),
                      keyboardType: TextInputType.number,
                       validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese un monto.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor, ingrese un número válido.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedPresupuesto.montoTotal = value!;
                      },
                    ),
                    // Las fechas se podrían implementar con un date picker para una mejor UX
                    TextFormField(
                       initialValue: _editedPresupuesto.fechaInicio,
                       decoration: const InputDecoration(labelText: 'Fecha Inicio (YYYY-MM-DD)'),
                       onSaved: (value) {
                        _editedPresupuesto.fechaInicio = value!;
                      },
                    ),
                     TextFormField(
                       initialValue: _editedPresupuesto.fechaFin,
                       decoration: const InputDecoration(labelText: 'Fecha Fin (YYYY-MM-DD)'),
                       onSaved: (value) {
                        _editedPresupuesto.fechaFin = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    // La empresa no se edita en el móvil, solo se muestra
                    Chip(
                      label: Text('Empresa: ${_editedPresupuesto.empresaNombre}'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}