import 'package:flutter/material.dart';

class HoverMenuItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final void Function()? onTap;

  const HoverMenuItem({
    required this.label,
    required this.icon,
    this.onTap,
    super.key,
  });

  @override
  _HoverMenuItemState createState() => _HoverMenuItemState();
}

class _HoverMenuItemState extends State<HoverMenuItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) {
        setState(() => _isHovering = hovering);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.only(left: 26, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: _isHovering
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Icon(widget.icon, color: Color(0xFF00D4FF)),
            SizedBox(width: 10),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}