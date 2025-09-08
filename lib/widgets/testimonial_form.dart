import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';

class TestimonialForm extends StatefulWidget {
  final void Function(String text, String author) onSubmit;

  const TestimonialForm({super.key, required this.onSubmit});

  @override
  State<TestimonialForm> createState() => _TestimonialFormState();
}

class _TestimonialFormState extends State<TestimonialForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_textController.text, _authorController.text);
      _textController.clear();
      _authorController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Thank you for your feedback!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Card(
      elevation: 0,
      color: isLight ? AppColors.lightCard : AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                "Share Your Experience",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isLight
                      ? AppColors.lightTextPrimary
                      : AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Testimonial input
              TextFormField(
                controller: _textController,
                style: TextStyle(
                  color: isLight
                      ? AppColors.lightTextPrimary
                      : AppColors.darkTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: "Write your experience...",
                  filled: true,
                  fillColor: isLight
                      ? AppColors.lightInputFill
                      : AppColors.darkInputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? "Please write something"
                    : null,
              ),
              const SizedBox(height: 12),

              // Author input
              TextFormField(
                controller: _authorController,
                style: TextStyle(
                  color: isLight
                      ? AppColors.lightTextPrimary
                      : AppColors.darkTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: "Your name",
                  filled: true,
                  fillColor: isLight
                      ? AppColors.lightInputFill
                      : AppColors.darkInputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter your name"
                    : null,
              ),
              const SizedBox(height: 16),

              // Submit button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLight
                        ? AppColors.lightPrimary
                        : AppColors.darkPrimary,
                    foregroundColor: isLight
                        ? AppColors.lightTextPrimary
                        : AppColors.darkTextPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleSubmit,
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
