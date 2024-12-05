import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:phuong_for_organizer/core/constants/color.dart';
import 'package:phuong_for_organizer/core/widgets/cstm_text.dart';
import 'package:phuong_for_organizer/data/models/genres_types_hosting.dart';

class EditGenreSelected extends StatefulWidget {
  final Function(String) onGenreSelected;
  final String? initialGenre;

  const EditGenreSelected({
    Key? key, 
    required this.onGenreSelected, 
    this.initialGenre
  }) : super(key: key);

  @override
  _EditGenreSelectedState createState() => _EditGenreSelectedState();
}

class _EditGenreSelectedState extends State<EditGenreSelected> {
  String? _selectedGenre;

  @override
  void initState() {
    super.initState();
    _selectedGenre = widget.initialGenre;
  }

  @override
 Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: .09),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurpleAccent, purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: purple.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Theme(
              // Wrap SearchableDropdown with Theme to customize search field
              data: Theme.of(context).copyWith(
                textTheme: TextTheme(
                  titleMedium: TextStyle(color: white), // For search input text
                ),
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: TextStyle(color: white.withOpacity(0.7)),
                  labelStyle: TextStyle(color: white),
                ),
              ),
              child: SearchableDropdown.single(
                style: TextStyle(color: white),
                items: musicGenres.map((genre) {
                  return DropdownMenuItem<String>(
                    value: genre.name,
                    child: Text(
                      genre.name,
                      style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  );
                }).toList(),
                value: _selectedGenre,
                hint: Text(
                  "Select Genre",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                searchHint: Text(
                  "Search genre...",
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
                menuBackgroundColor: black,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGenre = newValue;
                  });
                  widget.onGenreSelected(newValue!); //passing the selected genre to the ascess from the next page
                },
                isExpanded: true,
                closeButton: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: purple.withOpacity(0.3), width: 1),
                    ),
                  ),
                  
                  child:Center(child: TextButton(onPressed: (){Navigator.of(context).pop();}, child: CstmText(text: 'Done', fontSize: 20,fontWeight: FontWeight.bold,color: white,)))
                ),
                dialogBox: true,
             
                underline: Container(),
               
              ),
            ),
          ),
        ],
      ),
    );
  }
}