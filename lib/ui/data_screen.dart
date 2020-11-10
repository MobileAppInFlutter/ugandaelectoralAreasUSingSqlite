import 'package:flutter/material.dart';
import 'package:working_with_sqlt/model/district.model.dart';
import 'package:working_with_sqlt/ui/candidate_for_given_district.dart';
import 'package:working_with_sqlt/ui/search_screen.dart';
import 'package:working_with_sqlt/util/database_client.dart';

class DbData extends StatefulWidget {
  @override
  _DbDataState createState() => new _DbDataState();
}

class _DbDataState extends State<DbData> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();
  final List<DistrictItem> _districtItemList = <DistrictItem>[];

  @override
  void initState() {
    super.initState();
    _readToDoList();
  }

  void _handleSearch(String text) async {
    _textEditingController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(2.0),
                reverse: false,
                itemCount: _districtItemList.length,
                itemBuilder: (_, int index) {
                  return Card(
                    color: Colors.white70,
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(children: [
                            Text('District Name:'),Text('${_districtItemList[index].districtName}'),
                          ],),
                          Row(children: [
                            Text('Constuency Name:'),Text('${_districtItemList[index].constituency}'),
                          ],),
                          Row(children: [
                            Text('Sub County Name:'),Text('${_districtItemList[index].subCountry}'),
                          ],),
                          Row(children: [
                            Text('Electoral Village Name:'),Expanded(child: Text('${_districtItemList[index].electoralVillageArea}')),
                          ],)
                        ],
                      ),
                    ),
                    
                   
                  );
                }),
          ),
         
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        elevation: 10.0,
        highlightElevation: 10.0,
        child: new ListTile(
          title: new Icon(Icons.search),
        ),
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchScreen())),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 6.0,
        color: Colors.lightBlue,
        notchMargin: 2.0,
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[    
           Padding(
             padding: const EdgeInsets.all(12.0),
             child: InkWell(child: Text('Candidates'), onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => CandidateForAgivenDistrict()))
             
          ,
           ))
           ],
        ),
      ),
    );
  }

  

  _readToDoList() async {
    List districtItems = await db.getItems();
    districtItems.forEach((item) {
      DistrictItem districtItem = DistrictItem.fromMap(item);
      setState(() {
        _districtItemList.add(DistrictItem.map(item));
      });
      // print("Db items: ${districtItem.districtName}");
    });
  }

 


 
  }



 

