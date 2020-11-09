class DistrictItem  {
   String districtName;
   String constituency;
   String subCountry;
   String electoralVillageArea;
 

  DistrictItem({this.districtName, this.constituency, this.subCountry, this.electoralVillageArea});

  DistrictItem.map(dynamic obj) {
    this.districtName = obj["field1"];
    this.constituency = obj["field2"];
    this.subCountry = obj["field3"];
    this.electoralVillageArea = obj["field4"];
  }

  DistrictItem.fromMap(Map<String, dynamic> map) {
    this.districtName = map["field1"];
    this.constituency = map["field2"];
    this.subCountry = map["field3"];
    this.electoralVillageArea = map["field4"];
  }

}