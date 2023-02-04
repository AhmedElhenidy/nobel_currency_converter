import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nobel_currency_converter/data/model/currency_model.dart';
class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String defaultImageUrl= "https://cdn.britannica.com/33/4833-004-828A9A84/Flag-United-States-of-America.jpg";
  final valueController = TextEditingController(text: "0");
  String selectedCountryCode = "USD";
  String convertedValue = "0";
  List<CurrencyModel> currencies =[];
  bool loading = false;
  bool convertLoading = false;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    listAllCurrencies().then((value) {
      setState(() {
        loading = false;
      });
    },
      onError: (error){
      setState(() {
        loading = false;
        convertedValue = error.toString();
      });
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Nobel Currency Converter",),
      ),
      body: loading
          ?
          Center(
            child: CircularProgressIndicator(),
          )
          :
      SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: (){
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (ctx){
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32,vertical: 16),
                            decoration: BoxDecoration(
                               color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              )
                            ),
                            height: 700,
                            child: ListView.separated(
                              itemCount: currencies.length,
                              itemBuilder: (context,index){
                                return InkWell(
                                  onTap: (){
                                    selectedCountryCode =currencies[index].code??"USD";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Text(currencies[index].name??"",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(currencies[index].symbol??""),
                                      const SizedBox(width: 6,),
                                      Text(currencies[index].code??""),
                                    ],
                                  ),
                                );
                              }, separatorBuilder: (BuildContext context, int index) {
                                return Divider(
                                  color: Colors.blue,
                                );
                            },

                            ),
                          );
                        },
                      );
                    },
                    child: Text(selectedCountryCode,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                ),
                SizedBox(width: 32,),
                Expanded(
                  child: TextField(
                    controller: valueController,
                    keyboardType:TextInputType.number ,
                    decoration: InputDecoration(
                      hintText:"input amount to convert"
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(defaultImageUrl,
                    width: 60,
                    height: 30,
                  ),
                  Text(convertedValue),

                ],
              ),
            ),
            SizedBox(height: 32,),
            convertLoading
                ?
                CircularProgressIndicator()
                :
            TextButton(
              onPressed: ()async{
                setState(() { convertLoading =true;});
                double? convertedDouble = double.tryParse(valueController.text);
                if(convertedDouble==null){
                  convertedValue= "invalid input";
                }else{
                  convert(selectedCountryCode,convertedDouble).then((value) {
                    convertedValue = value;
                    setState(() { convertLoading =false;});
                  },
                    onError: (error){
                      convertedValue = error.toString();
                      setState(() { convertLoading =false;});
                    }
                  );
                }

              },
              child: Text("Convert"),
            ),
          ],
        ),
      ),
    );
  }
  Future<String> convert(String currency,double value)async{
    Uri uri= Uri(
      scheme: "https",
      host: "api.freecurrencyapi.com",
      path: "v1/latest",
      queryParameters: {
        "apikey":"N8na7dQL8kt7phAWoSS4brbPX97Ubjo9ydW8JyMN",
        "currencies":currency,
      },
    );
    print(uri);
    var response = await http.get(uri);
    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      var decodedBody = json.decode(response.body) as Map<String,dynamic>;
      num rate  = decodedBody["data"][currency];
      print(rate);
      double convertedValue = value/rate.toDouble();
      print(convertedValue);
      return convertedValue.toStringAsFixed(2);
    }else{
      print(response.toString());
      return "Error";
    }

  }

  Future listAllCurrencies()async{
    setState(() {
      loading = true;
    });
    Uri uri= Uri(
      scheme: "https",
      host: "api.freecurrencyapi.com",
      path: "v1/currencies",
      queryParameters: {
        "apikey":"N8na7dQL8kt7phAWoSS4brbPX97Ubjo9ydW8JyMN",
        "currencies":"",
      },
    );
    print(uri);
    var response = await http.get(uri);
    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      var decodedBody = json.decode(response.body) as Map<String,dynamic>;
      print(decodedBody);
      Map<String,dynamic> mappedCountries = decodedBody["data"];
      print(mappedCountries);
      currencies =  mappedCountries.entries.map(
              (e) => CurrencyModel.fromJson(e.value as Map<String,dynamic>)
      ).toList();
    }else{
      print(response.toString());
      return [];
    }
  }
}
