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
      onHover: (hovering) {
        setState(() => _isHovering = hovering);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.only(left: 1, top: 8, bottom: 8),
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
            SizedBox(width: 18),
            Expanded(
              child: Text(
                widget.label,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white, fontSize: 16),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoverMenuItemHelper extends StatefulWidget {
  final String label;
  final IconData icon;
  final void Function()? onTap;

  const HoverMenuItemHelper({
    required this.label,
    required this.icon,
    this.onTap,
    super.key,
  });

  @override
  _HoverMenuItemHelperState createState() => _HoverMenuItemHelperState();
}

class _HoverMenuItemHelperState extends State<HoverMenuItemHelper> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovering) {
        setState(() => _isHovering = hovering);
      },
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.only(left: 1, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: _isHovering
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ], 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: Color(0xFF00D4FF), size: 20),
            SizedBox(width: 18),
            Expanded(
              child: Text(
                widget.label,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16,
                  height: 1.2,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
