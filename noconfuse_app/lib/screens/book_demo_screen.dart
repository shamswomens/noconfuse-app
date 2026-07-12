import 'package:flutter/material.dart';
import '../theme.dart';

class BookDemoScreen extends StatefulWidget {
  const BookDemoScreen({super.key});

  @override
  State<BookDemoScreen> createState() => _BookDemoScreenState();
}

class _BookDemoScreenState extends State<BookDemoScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book a demo")),
      body: _submitted ? _successView() : _formView(),
    );
  }

  Widget _formView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Want a walkthrough of live price tracking, alerts, and store integrations? "
          "Leave your details and our team will reach out to schedule a demo.",
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Full name"),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Phone number"),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: "What would you like to see? (optional)"),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter your name and phone number.")),
              );
              return;
            }
            setState(() => _submitted = true);
          },
          child: const Text("Request demo"),
        ),
      ],
    );
  }

  Widget _successView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.good, size: 56),
            const SizedBox(height: 16),
            const Text("Request received!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              "Thanks, ${_nameController.text.trim().isEmpty ? 'there' : _nameController.text.trim()}. "
              "Our team will reach out shortly to schedule your demo.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to home"),
            ),
          ],
        ),
      ),
    );
  }
}
