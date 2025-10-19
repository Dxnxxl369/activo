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
      await Provider.of<ActivoFijoProvider>(context, listen: false).updateActivoFijo(_editedActivo);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Manejo de error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Activo Fijo'),
        actions: [IconButton(icon: const Icon(Icons.save_outlined), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _editedActivo.nombre,
                      decoration: InputDecoration(
                        labelText: 'Nombre del Activo',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.label_important_outline),
                      ),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedActivo.nombre = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedActivo.descripcion,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.notes_outlined),
                      ),
                      maxLines: 3,
                      onSaved: (v) => _editedActivo.descripcion = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedActivo.valorActual,
                      decoration: InputDecoration(
                        labelText: 'Valor Actual',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.price_change_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedActivo.valorActual = v!,
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Chip(avatar: const Icon(Icons.category_outlined), label: Text('Categoría: ${_editedActivo.categoriaNombre}')),
                        Chip(avatar: const Icon(Icons.location_on_outlined), label: Text('Ubicación: ${_editedActivo.ubicacionNombre}')),
                        Chip(avatar: const Icon(Icons.toggle_on_outlined), label: Text('Estado: ${_editedActivo.estadoNombre}')),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}