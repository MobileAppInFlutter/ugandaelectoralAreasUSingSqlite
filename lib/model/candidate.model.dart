class Candidate {
  String surname;
  String otherName;
  String sex;
  String politicalParty;
  String symbol;
  String categoryName;
  String districtName;
  String electoralAreaName;
  String status; // will be changed to boolean

  Candidate(
      this.surname,
      this.otherName,
      this.sex,
      this.politicalParty,
      this.symbol,
      this.categoryName,
      this.districtName,
      this.electoralAreaName,
      this.status);
 
  Candidate.fromMap(Map<String, dynamic> map) {
    this.surname = map["surname"];
    this.otherName = map["other_name"];
    this.sex = map["sex"];
    this.politicalParty = map["political_party"];
    this.symbol = map["symbol"];
    this.categoryName = map["category_name"];
    this.districtName = map["district_name"];
    this.electoralAreaName = map["electoral_area"];
    this.status = map['status'];
  }
}
