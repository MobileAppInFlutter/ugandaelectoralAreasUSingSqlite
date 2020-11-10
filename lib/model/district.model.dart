class DistrictItem  {
   String districtName;
   String constituency;
   String subCountry;
   String electoralVillageArea;
 

  DistrictItem({this.districtName, this.constituency, this.subCountry, this.electoralVillageArea});

  DistrictItem.fromMap(Map<String, dynamic> map) {  
    this.districtName = map["district"];
    this.constituency = map["constituency"];
    this.subCountry = map["subcounty"];
    this.electoralVillageArea = map["electoral_area_village"];
  }

}