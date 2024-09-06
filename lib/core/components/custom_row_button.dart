import 'package:flutter/material.dart';

class CustomSegmentedButton extends StatefulWidget {
  const CustomSegmentedButton({
    super.key,
    required this.items,
    this.onValueChanged,
  });

  final List<String> items;
  final void Function(String)? onValueChanged;

  @override
  _CustomSegmentedButtonState createState() => _CustomSegmentedButtonState();
}

class _CustomSegmentedButtonState extends State<CustomSegmentedButton> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    // Başlangıçta ilk elemanı seçili yap
    _selectedValue = widget.items.isNotEmpty ? widget.items[0] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: ToggleButtons(
        isSelected: widget.items.map((item) => item == _selectedValue).toList(),
        onPressed: (index) {
          setState(() {
            _selectedValue = widget.items[index];
            if (widget.onValueChanged != null) {
              widget.onValueChanged!(_selectedValue);
            }
          });
        },
        children: widget.items
            .map((item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.black),
                  ),
                ))
            .toList(),
        color: Colors.blue, // Düğme metin rengi
        selectedColor: Colors.white, // Seçili düğme metin rengi
        borderColor: Colors.transparent, // Düğme kenarlık rengi
        selectedBorderColor: Colors.transparent, // Seçili düğme kenarlık rengi
        borderRadius: BorderRadius.circular(8), // Kenar yuvarlama
        fillColor: Colors.blue, // Düğme arka plan rengi
        splashColor: Colors.blueAccent, // Tıklama efekt rengi
      ),
    );
  }
}
