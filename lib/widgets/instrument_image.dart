import 'package:flutter/material.dart';
import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';

class InstrumentImage extends StatelessWidget {
  final Instrument instrument;
  final double? width;
  final double? height;
  final BoxFit fit;

  const InstrumentImage({
    super.key,
    required this.instrument,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Ako postoji slika prikazi je
    if (instrument.slikaUrl != null && instrument.slikaUrl!.isNotEmpty) {
      return Image.asset(
        instrument.slikaUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          // ako ne prikazi ikonicu
          return _buildIconPlaceholder();
        },
      );
    }
    return _buildIconPlaceholder();
  }

  Widget _buildIconPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            instrument.categoryColor.withOpacity(0.3),
            instrument.categoryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Icon(
        instrument.icon,
        size: (height != null && width != null) 
            ? (height! < width! ? height! * 0.4 : width! * 0.4)
            : 60,
        color: instrument.categoryColor,
      ),
    );
  }
}
