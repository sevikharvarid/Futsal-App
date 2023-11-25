import 'package:flutter/material.dart';

class NumberInputDialog extends StatefulWidget {
  const NumberInputDialog({Key? key}) : super(key: key);

  @override
  State<NumberInputDialog> createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Masukkan Jumlah Uang'),
      content: Row(
        children: [
          const Text('Rp.'),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan jumlah uang',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon masukkan jumlah uang';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_numberController.text);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
