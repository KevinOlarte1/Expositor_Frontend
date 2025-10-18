import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/stats_card.dart';

class CustomAppBar extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const CustomAppBar({super.key, required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Color(0xFF2b2b2b)),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarUrl)),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hola",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
