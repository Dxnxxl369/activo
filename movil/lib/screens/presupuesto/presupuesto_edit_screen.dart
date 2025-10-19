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
    _editedPresupuesto = widget.presupuesto;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await Provider.of<PresupuestoProvider>(context, listen: false).updatePresupuesto(_editedPresupuesto);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      // Manejo de error
    } finally {
       if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Presupuesto'),
        actions: [
          IconButton(icon: const Icon(Icons.save_outlined), onPressed: _saveForm),
        ],
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
                      initialValue: _editedPresupuesto.descripcion,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.description_outlined),
                      ),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedPresupuesto.descripcion = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedPresupuesto.montoTotal,
                      decoration: InputDecoration(
                        labelText: 'Monto Total',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedPresupuesto.montoTotal = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                       initialValue: _editedPresupuesto.fechaInicio,
                       decoration: InputDecoration(
                         labelText: 'Fecha Inicio (YYYY-MM-DD)',
                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                         prefixIcon: const Icon(Icons.calendar_today_outlined),
                       ),
                       onSaved: (v) => _editedPresupuesto.fechaInicio = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                       initialValue: _editedPresupuesto.fechaFin,
                       decoration: InputDecoration(
                         labelText: 'Fecha Fin (YYYY-MM-DD)',
                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                         prefixIcon: const Icon(Icons.event_outlined),
                       ),
                       onSaved: (v) => _editedPresupuesto.fechaFin = v!,
                    ),
                    const SizedBox(height: 24),
                    Chip(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      avatar: const Icon(Icons.business),
                      label: Text('Empresa: ${_editedPresupuesto.empresaNombre}', style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}