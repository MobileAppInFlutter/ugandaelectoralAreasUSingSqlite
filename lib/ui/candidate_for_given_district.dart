import 'package:flutter/material.dart';
import 'package:working_with_sqlt/model/candidate.model.dart';
import 'package:working_with_sqlt/util/database_client.dart';

class CandidateForAgivenDistrict extends StatefulWidget {
  @override
  _CandidateForAgivenDistrictState createState() =>
      _CandidateForAgivenDistrictState();
}

class _CandidateForAgivenDistrictState
    extends State<CandidateForAgivenDistrict> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController _searchController = TextEditingController();

  List<Candidate> _searchResult = [];
  void _search() async {
    print('${_searchController.text}');
    var result = await databaseHelper.getCandidateForGivenDistrict(
        _searchController.text.toUpperCase().trim());
    setState(() {
      _searchResult = [];
      _searchResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search for area candidates'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            Form(
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                    labelText: 'Enter district',
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
                  child: _searchResult.length != null
                      ? ListView.builder(
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
                                        Text(
                                            '${_searchResult[--index].districtName}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('SurName:'),
                                        Text('${_searchResult[index].surname}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Other Name:'),
                                        Text(
                                            '${_searchResult[index].otherName}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Political Party:'),
                                        Expanded(
                                          child: Text(
                                              '${_searchResult[index].politicalParty}'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                )),
          ]),
        ));
  }
}
