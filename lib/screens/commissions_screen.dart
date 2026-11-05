import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';

class CommissionsScreen extends StatefulWidget {
  const CommissionsScreen({super.key});

  @override
  State<CommissionsScreen> createState() => _CommissionsScreenState();
}

class _CommissionsScreenState extends State<CommissionsScreen> {
  // Form ko handle karne ke liye key
  final _formKey = GlobalKey<FormState>();

  // Controllers (Input fields se data lene ke liye)
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _budgetController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedType = 'Portrait & character art';
  String _selectedTimeline = 'Within 1 month';

  bool _isLoading = false;

  final List<String> _artTypes = [
    'Portrait & character art',
    'Custom illustration',
    'Traditional / watercolour',
    'Digital artwork',
  ];

  final List<String> _timelines = [
    'No fixed deadline',
    'Within 2 weeks',
    'Within 1 month',
    'For a specific gift date',
  ];

  Future<void> _submitForm() async {
    // Validate karo ki saare required fields bhare hain ya nahi
    if (!_formKey.currentState!.validate()) return;

    // Keyboard hide karo
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      await ApiService.submitCommission(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        artworkType: _selectedType,
        budget: _budgetController.text.trim(),
        message: _messageController.text.trim(),
        timeline: _selectedTimeline,
      );

      // Success Message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Enquiry submitted successfully! KalaVista will contact you soon.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Form clear karo
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _budgetController.clear();
        _messageController.clear();
      }
    } catch (e) {
      // Error Message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EFE6),
        elevation: 0,
        title: Text(
          'Commissions',
          style: GoogleFonts.cormorantGaramond(
            color: const Color(0xFF2B2028),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Commission a custom artwork.',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2B2028),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill out this brief and the artist will get back to you with a quote.',
                style: GoogleFonts.manrope(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // Name Field
              _buildLabel('Your Name *'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('e.g., Poornendu Bajpai'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),

              // Email Field
              _buildLabel('Email Address *'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('you@example.com'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Artwork Type Dropdown
              _buildLabel('Artwork Type *'),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: _inputDecoration(''),
                items: _artTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              const SizedBox(height: 20),

              // Budget Field
              _buildLabel('Approximate Budget (Optional)'),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('e.g., 5000'),
              ),
              const SizedBox(height: 20),

              // Timeline Dropdown
              _buildLabel('Ideal Timeline'),
              DropdownButtonFormField<String>(
                value: _selectedTimeline,
                decoration: _inputDecoration(''),
                items: _timelines.map((time) {
                  return DropdownMenuItem(value: time, child: Text(time));
                }).toList(),
                onChanged: (val) => setState(() => _selectedTimeline = val!),
              ),
              const SizedBox(height: 20),

              // Message Field
              _buildLabel('Your Idea / Message *'),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: _inputDecoration(
                  'Describe the artwork you want to create...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please describe your idea';
                  if (value.length < 10)
                    return 'Please write a bit more detail';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFa84d3f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Send Commission Brief',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widgets for styling
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: const Color(0xFF2B2028),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
