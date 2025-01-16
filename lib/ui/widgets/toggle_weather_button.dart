import 'package:flutter/material.dart';

/// ToggleWeatherButton allows users to show or hide the weather card.
class ToggleWeatherButton extends StatelessWidget {
  final bool isCardVisible;
  final VoidCallback onTap;

  const ToggleWeatherButton({
    super.key,
    required this.isCardVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(left: 8),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Icon(
          isCardVisible ? Icons.close : Icons.cloud,
          color: Colors.white,
        ),
      ),
    );
  }
}
