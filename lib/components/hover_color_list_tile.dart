import 'package:flutter/material.dart';

class HoverColorListTile extends StatefulWidget {
  final Widget title;
  final Color hoverColor;
  final Function()? onTap;

  const HoverColorListTile(
      {super.key, required this.title, required this.hoverColor, this.onTap});

  @override
  State<HoverColorListTile> createState() => _HoverColorListTileState();
}

class _HoverColorListTileState extends State<HoverColorListTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onHover(true),
      onExit: (event) => onHover(false),
      child: Container(
        color: isHovered ? widget.hoverColor : const Color(0xFFA0E9FF),
        child: ListTile(
          title: widget.title,
          onTap: widget.onTap,
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
