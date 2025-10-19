// lib/screens/proveedor/proveedor_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/proveedor.dart';
import '../../providers/proveedor_provider.dart';

class ProveedorEditScreen extends StatefulWidget {
  final Proveedor proveedor;

  const ProveedorEditScreen({super.key, required this.proveedor});

  @override
  State<ProveedorEditScreen> createState() => _ProveedorEditScreenState();
}

class _ProveedorEditScreenState extends State<ProveedorEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Proveedor _editedProveedor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editedProveedor = widget.proveedor;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    
    try {
      await Provider.of<ProveedorProvider>(context, listen: false).updateProveedor(_editedProveedor);
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
        title: const Text('Editar Proveedor'),
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
                      initialValue: _editedProveedor.nombre,
                      decoration: InputDecoration(
                        labelText: 'Nombre del Proveedor',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.store_outlined),
                      ),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedProveedor.nombre = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedProveedor.direccion,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.location_city_outlined),
                      ),
                      onSaved: (v) => _editedProveedor.direccion = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedProveedor.telefono,
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      onSaved: (v) => _editedProveedor.telefono = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedProveedor.email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v != null && v.isNotEmpty && !v.contains('@')) {
                          return 'Email no válido';
                        }
                        return null;
                      },
                      onSaved: (v) => _editedProveedor.email = v!,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}