import 'package:flutter/material.dart';

class IncomePopup extends StatefulWidget {
  final List<String> categories;
  final void Function(String category, double amount, String description, TimeOfDay time) onAdd;
  final VoidCallback onCancel;

  const IncomePopup({
    required this.categories,
    required this.onAdd,
    required this.onCancel,
    super.key,
  });

  @override
  State<IncomePopup> createState() => _ExpensePopupState();
}

class _ExpensePopupState extends State<IncomePopup> {
  String? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("Gider Ekle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: const Text("Kategori Seçin"),
                    items: widget.categories
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Tutar"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Açıklama"),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text("Saat: ${_selectedTime.format(context)}"),
                      TextButton(
                        onPressed: _pickTime,
                        child: const Text("Seç"),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: widget.onCancel,
                        child: const Text("İptal"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final amount = double.tryParse(_amountController.text) ?? 0.0;
                          if (_selectedCategory != null && amount > 0) {
                            widget.onAdd(
                              _selectedCategory!,
                              amount,
                              _descriptionController.text,
                              _selectedTime,
                            );
                          }
                        },
                        child: const Text("Ekle"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
