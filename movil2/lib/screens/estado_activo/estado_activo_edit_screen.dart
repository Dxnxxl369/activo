// lib/screens/estado_activo/estado_activo_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/estado_activo.dart';
import '../../providers/estado_activo_provider.dart';

class EstadoActivoEditScreen extends StatefulWidget {
  final EstadoActivo item;
  const EstadoActivoEditScreen({super.key, required this.item});

  @override
  State<EstadoActivoEditScreen> createState() => _EstadoActivoEditScreenState();
}

class _EstadoActivoEditScreenState extends State<EstadoActivoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombre = widget.item.nombre;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      final updatedItem = EstadoActivo(id: widget.item.id, nombre: _nombre);
      await Provider.of<EstadoActivoProvider>(context, listen: false).updateItem(updatedItem);
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
        title: const Text('Editar Estado'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: _nombre,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Estado',
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                      validator: (v) => v!.isEmpty ? 'Ingrese un nombre' : null,
                      onSaved: (v) => _nombre = v!,
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