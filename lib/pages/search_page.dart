import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                label: Text('Search by email'),
                  suffixIcon: IconButton(onPressed: (){
                  },icon: Icon(Icons.search)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.grey.shade400))
              ),

            )
          ],
        ),
      ),
    );
  }
}
