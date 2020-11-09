import 'package:flutter/material.dart';
import 'package:working_with_sqlt/model/district.model.dart';
import 'package:working_with_sqlt/util/database_client.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController _searchController = TextEditingController();

  List<DistrictItem> _searchResult = [];
  void _search() async {
    print('${_searchController.text}');
    var result = await databaseHelper
        .getLocationDetails(_searchController.text.toUpperCase().trim());
    setState(() {
      _searchResult = [];
      _searchResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            Form(
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                    labelText: 'Enter electoral village',
                    suffix: InkWell(
                      child: Text('Search'),
                      onTap: _search,
                    )),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.78,
                  child: _searchResult.length != null ? ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('${++index} District Name:'),
                                  Text('${_searchResult[--index].districtName}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Constuency Name:'),
                                  Text('${_searchResult[index].constituency}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Sub County Name:'),
                                  Text('${_searchResult[index].subCountry}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Electoral Village Name:'),
                                  Text(
                                      '${_searchResult[index].electoralVillageArea}'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ): Container(),
                )),
          ]),
        ));
  }
}
