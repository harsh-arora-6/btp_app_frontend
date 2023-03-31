class LTModel{
  int incomers=0;
  int outgoing=0;
  double current_in=0.0;
  double current_out=0.0;

  LTModel(this.incomers,this.outgoing,this.current_in,this.current_out);
  factory LTModel.fromJson(Map<String,dynamic>json){
    return LTModel(json['incomers'],
      json['outgoers'],
      json['incomer_rated_current'].toDouble(),
      json['outgoer_rated_current'].toDouble()
    );
  }

  Map toJson()=> {
    "incomers" : incomers,
    "outgoers": outgoing,
    "incomer_rated_current": current_in,
    "outgoer_rated_current": current_out
  };

}