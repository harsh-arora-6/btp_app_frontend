class RMUModel{
  double cktBkrRating =0.0;
  int way=0;

  RMUModel(this.cktBkrRating,this.way);
  factory RMUModel.fromJson(Map<String,dynamic>json){
    return RMUModel(json['circuit_breaker_rating'].toDouble(),
      json['way']
    );
  }

  Map toJson()=> {
    "circuit_breaker_rating" : cktBkrRating,
    "way": way
  };

}