class transformerModel{
  String id="";
  String name="";
  double ratedPower=0.0;
  double impedance=0.0;
  String nextMant= "";
  double primaryVolt=0.0;
  double secondaryVolt=0.0;
  int manYear=0;
  String substationId="";

  transformerModel(this.id,this.name,this.ratedPower,this.impedance,this.nextMant,this.primaryVolt,this.secondaryVolt,this.manYear,this.substationId);
  factory transformerModel.fromJson(Map<String,dynamic>json){
    return transformerModel(json['_id'],
        json['name'],
        json['rated_power'].toDouble(),
        json['impedance'].toDouble(),
        json['next_maintenance'],
        json['rated_primary_voltage'].toDouble(),
        json['rated_secondary_voltage'].toDouble(),
        json['year_of_manufacture'],
        json['substation']
       );
  }

  Map toJson()=> {
    "name":name,
    "rated_power":ratedPower,
    "impedance":impedance,
    "next_maintenance":nextMant,
    "rated_primary_voltage":primaryVolt,
    "rated_secondary_voltage":secondaryVolt,
    "year_of_manufacture":manYear
  };

}