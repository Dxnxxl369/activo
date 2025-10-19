// lib/screens/activo_fijo/activofijo_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/activo_fijo.dart';
import '../../providers/activofijo_provider.dart';

class ActivoFijoEditScreen extends StatefulWidget {
  final ActivoFijo activoFijo;

  const ActivoFijoEditScreen({super.key, required this.activoFijo});

  @override
  State<ActivoFijoEditScreen> createState() => _ActivoFijoEditScreenState();
}

class _ActivoFijoEditScreenState extends State<ActivoFijoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late ActivoFijo _editedActivo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editedActivo = widget.activoFijo;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    
    try {
      await Provider.of<ActivoFijoProvider>(context, listen: false)
          .updateActivoFijo(_editedActivo);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar'), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Activo Fijo'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _editedActivo.nombre,
                        decoration: const InputDecoration(labelText: 'Nombre del Activo'),
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                        onSaved: (v) => _editedActivo.nombre = v!,
                      ),
                      TextFormField(
                        initialValue: _editedActivo.descripcion,
                        decoration: const InputDecoration(labelText: 'Descripción'),
                        onSaved: (v) => _editedActivo.descripcion = v!,
                      ),
                       TextFormField(
                        initialValue: _editedActivo.valorActual,
                        decoration: const InputDecoration(labelText: 'Valor Actual'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                        onSaved: (v) => _editedActivo.valorActual = v!,
                      ),
                      const SizedBox(height: 20),
                      Chip(label: Text('Categoría: ${_editedActivo.categoriaNombre}')),
                      Chip(label: Text('Ubicación: ${_editedActivo.ubicacionNombre}')),
                      Chip(label: Text('Estado: ${_editedActivo.estadoNombre}')),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}