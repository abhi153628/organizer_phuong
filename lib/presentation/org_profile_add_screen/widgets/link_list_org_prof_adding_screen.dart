import 'package:flutter/material.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';

class EventRulesInput extends StatefulWidget {
  final Function(List<String>) onRulesChanged;
  const EventRulesInput({super.key, required this.onRulesChanged});

  @override
  State<EventRulesInput> createState() => _EventRulesInputState();
}

class _EventRulesInputState extends State<EventRulesInput> {
  final List<TextEditingController> _controllers = [];
  final List<String> _rules = [];

  @override
  void initState() {
    super.initState();
    _addNewRule();
  }

  void _addNewRule() {
    _controllers.add(TextEditingController());
    _rules.add('');
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D21),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          const SizedBox(height: 16),
          ...List.generate(_controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _controllers[index],
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter rule or requirement',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (value) {
                        _rules[index] = value;
                        widget.onRulesChanged(_rules);
                      },
                    ),
                  ),
                  IconButton(
                    icon:  Icon(Icons.delete, color: purple),
                    onPressed: () {
                      setState(() {
                        _controllers[index].dispose();
                        _controllers.removeAt(index);
                        _rules.removeAt(index);
                        widget.onRulesChanged(_rules);
                      });
                    },
                  ),
                ],
              ),
            );
          }),
          Center(
            child: TextButton.icon(
              onPressed: _addNewRule,
              icon:  Icon(Icons.add, color: purple),
              label:  Text(
                'Add Rule',
                style: TextStyle(color: purple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}