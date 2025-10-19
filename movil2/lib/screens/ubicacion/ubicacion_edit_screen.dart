// lib/screens/ubicacion/ubicacion_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ubicacion.dart';
import '../../providers/ubicacion_provider.dart';

class UbicacionEditScreen extends StatefulWidget {
  final Ubicacion item;
  const UbicacionEditScreen({super.key, required this.item});

  @override
  State<UbicacionEditScreen> createState() => _UbicacionEditScreenState();
}

class _UbicacionEditScreenState extends State<UbicacionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Ubicacion _editedItem;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editedItem = widget.item;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<UbicacionProvider>(context, listen: false).updateItem(_editedItem);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Error handling
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Ubicación'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: _editedItem.nombre,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la Ubicación',
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                      ),
                      validator: (v) => v!.isEmpty ? 'Ingrese un nombre' : null,
                      onSaved: (v) => _editedItem.nombre = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedItem.direccion,
                      decoration: const InputDecoration(
                        labelText: 'Dirección (Opcional)',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      onSaved: (v) => _editedItem.direccion = v,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedItem.descripcion,
                      decoration: const InputDecoration(
                        labelText: 'Descripción (Opcional)',
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                      maxLines: 3,
                      onSaved: (v) => _editedItem.descripcion = v,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveForm,
                      child: const Text('Guardar Cambios'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}