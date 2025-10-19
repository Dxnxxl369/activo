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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el activo'), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Activo Fijo'),
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
                    // --- CAMPO 'codigo_interno' (solo lectura) ---
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Código Interno',
                        prefixIcon: Icon(Icons.qr_code),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _editedActivo.codigoInterno.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // --- CAMPO 'nombre' (editable) ---
                    TextFormField(
                      initialValue: _editedActivo.nombre,
                      decoration: const InputDecoration(labelText: 'Nombre del Activo', prefixIcon: Icon(Icons.label_important_outline)),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedActivo.nombre = v!,
                    ),
                    const SizedBox(height: 16),
                    // --- CAMPO 'valor_actual' (editable) ---
                    TextFormField(
                      initialValue: _editedActivo.valorActual,
                      decoration: const InputDecoration(labelText: 'Valor Actual', prefixIcon: Icon(Icons.price_change_outlined)),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedActivo.valorActual = v!,
                    ),
                    const SizedBox(height: 16),
                    // --- CAMPO 'vida_util' (editable) ---
                    TextFormField(
                      initialValue: _editedActivo.vidaUtil.toString(),
                      decoration: const InputDecoration(labelText: 'Vida Útil (años)', prefixIcon: Icon(Icons.hourglass_bottom_outlined)),
                      keyboardType: TextInputType.number,
                       validator: (v) {
                        if (v == null || v.isEmpty) return 'Campo requerido';
                        if (int.tryParse(v) == null) return 'Ingrese un número válido';
                        return null;
                      },
                      onSaved: (v) => _editedActivo.vidaUtil = int.tryParse(v!) ?? 0,
                    ),
                    const SizedBox(height: 24),
                    // --- Campos de solo lectura ---
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Chip(avatar: const Icon(Icons.category_outlined), label: Text('Categoría: ${_editedActivo.categoriaNombre}')),
                        Chip(avatar: const Icon(Icons.location_on_outlined), label: Text('Ubicación: ${_editedActivo.ubicacionNombre}')),
                        Chip(avatar: const Icon(Icons.toggle_on_outlined), label: Text('Estado: ${_editedActivo.estadoNombre}')),
                      ],
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