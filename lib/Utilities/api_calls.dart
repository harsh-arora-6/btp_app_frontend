// void createTransformer(transformerModel transformer) async {
//   print("creating transformer");
//   var body = transformer.toJson();
//   print(jsonEncode(body));
//
//   try {
//     http.Response response = await http.post(
//         Uri.parse('$baseUrl/transformers/createtransformer'),
//         body: jsonEncode(body),
//         headers: {'Content-Type': 'application/json'});
//     print(response.body);
//   } catch (e) {
//     print(e);
//   }
// }
