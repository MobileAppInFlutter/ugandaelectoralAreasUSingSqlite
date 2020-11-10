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

  Candidate.map(dynamic obj) {
    this.surname = obj["field1"];
    this.otherName = obj["field2"];
    this.sex = obj["field3"];
    this.politicalParty = obj["field4"];
    this.symbol = obj["field5"];
    this.categoryName = obj["field6"];
    this.districtName = obj["field7"];
    this.electoralAreaName = obj["field8"];
    this.status = obj['field9'];
  }

  Candidate.fromMap(Map<String, dynamic> map) {
    this.surname = map["field1"];
    this.otherName = map["field2"];
    this.sex = map["field3"];
    this.politicalParty = map["field4"];
    this.symbol = map["field5"];
    this.categoryName = map["field6"];
    this.districtName = map["field7"];
    this.electoralAreaName = map["field8"];
    this.status = map['field9'];
  }
}
