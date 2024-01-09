import 'package:flutter/material.dart';

class HoverColorListTile extends StatefulWidget {
  final Widget title;
  final Color hoverColor;
  final Function()? onTap;

  HoverColorListTile(
      {required this.title, required this.hoverColor, this.onTap});

  @override
  _HoverColorListTileState createState() => _HoverColorListTileState();
}

class _HoverColorListTileState extends State<HoverColorListTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onHover(true),
      onExit: (event) => onHover(false),
      child: Container(
        color: isHovered ? widget.hoverColor : Color(0xFFA0E9FF),
        child: ListTile(
          title: widget.title,
          onTap: widget.onTap,
          // Add other ListTile properties as needed
        ),
      ),
    );
  }

  void onHover(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
