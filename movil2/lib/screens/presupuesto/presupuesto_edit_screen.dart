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
        title: const Text('Editar Presupuesto'),
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
                      initialValue: _editedPresupuesto.descripcion,
                      decoration: const InputDecoration(labelText: 'Descripción', prefixIcon: Icon(Icons.description_outlined)),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedPresupuesto.descripcion = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedPresupuesto.montoTotal.toString(),
                      decoration: const InputDecoration(labelText: 'Monto Total', prefixIcon: Icon(Icons.attach_money)),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      onSaved: (v) => _editedPresupuesto.montoTotal = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                       initialValue: _editedPresupuesto.fechaInicio,
                       decoration: const InputDecoration(labelText: 'Fecha Inicio (YYYY-MM-DD)', prefixIcon: Icon(Icons.calendar_today_outlined)),
                       onSaved: (v) => _editedPresupuesto.fechaInicio = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                       initialValue: _editedPresupuesto.fechaFin,
                       decoration: const InputDecoration(labelText: 'Fecha Fin (YYYY-MM-DD)', prefixIcon: Icon(Icons.event_outlined)),
                       onSaved: (v) => _editedPresupuesto.fechaFin = v!,
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