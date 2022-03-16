import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GeneratePassword extends StatefulWidget {
  @override
  _GeneratePasswordState createState() => _GeneratePasswordState();
}

class _GeneratePasswordState extends State<GeneratePassword> {
  bool _isWithLetters = true;
  bool _isWithUppercase = false;
  bool _isWithNumbers = false;
  bool _isWithSpecial = false;
  List<String> newPassword = [];
  List<String> passWORD = [];
  final _key = GlobalKey<FormState>();
  Color _color = Colors.blue;
  String isOk = '';
  num n;
  //var excel = Excel.createExcel();
  TextEditingController _password = TextEditingController();
  final password = RandomPasswordGenerator();

Future<bool> _requestPermission(Permission permission) async{

  if(await permission.isGranted){
    return true;
  }
  else{
    var result = await permission.request();
    if(result == PermissionStatus.granted){
      return true;
    }
    else{
      return false;
    }
  }

}

  Future<String> getFilePath() async {
    try{

      if(Platform.isAndroid){

        if(await _requestPermission(Permission.storage)){

          Directory appDocumentsDirectory = await getExternalStorageDirectory(); // 1
          String appDocumentsPath = appDocumentsDirectory.path; // 2
          print(appDocumentsPath);
          String newPath = "";
          List<String> folders =  appDocumentsPath.split("/");
          for(int x=1;x<folders.length;x++){
            String folder = folders[x];
            if(folder != "Android"){
              newPath += "/"+folder;
            }
            else{
              break;
            }
          }

          newPath += "/Result_Management_System";
          appDocumentsDirectory = Directory(newPath);
          String filePath;
          if(!await appDocumentsDirectory.exists()){
            await appDocumentsDirectory.create(recursive: true);
          }
          if(await appDocumentsDirectory.exists()){
            appDocumentsPath = appDocumentsDirectory.path;
            filePath = '$appDocumentsPath/sheet.xlsx'; // 3
          }
          return filePath;
        }
        else{
          return null;
        }

      }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  checkBox(String name, Function onTap, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(name),
        Checkbox(value: value, onChanged: onTap),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.pinkAccent,
          elevation: 8,
          shadowColor: Colors.black12,
          title: Text("Password Generator" ,style: TextStyle(fontSize: 20,),),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Center(
              child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        checkBox('Upper Case', (bool value) {
                          _isWithUppercase = value;
                          setState(() {});
                        }, _isWithUppercase),
                        checkBox('Lower Case', (bool value) {
                          _isWithLetters = value;
                          setState(() {});
                        }, _isWithLetters)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        checkBox('Symbols', (bool value) {
                          _isWithSpecial = value;
                          setState(() {});
                        }, _isWithSpecial),
                        checkBox('Numbers', (bool value) {
                          _isWithNumbers = value;
                          setState(() {});
                        }, _isWithNumbers)
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        validator: (value) {
                          n = num.tryParse(value);
                          if(n == null){
                            return 'Enter Value or Value is not a valid Number';
                          }
                          return null;
                        },
                        controller: _password,
                        maxLength: 4,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Enter Count',
                          labelStyle: TextStyle(color: Colors.blue),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (_key.currentState.validate()) {
                            passWORD.clear();

                            var excel = Excel.createExcel();
                            Sheet sheetObject = excel['Sheet1'];
                            sheetObject.appendRow(["SR No." , "Generated PassWord"]);

                            for(int i=0;i<n;i++) {
                              passWORD.add(password.random_password(
                                  _isWithLetters, _isWithUppercase, _isWithNumbers,
                                  _isWithSpecial, 8));
                              sheetObject.appendRow([i.toString(),passWORD[i]]);
                            }
                            for (var table in excel.tables.keys) {
                              print(table); //sheet Name
                              print(excel.tables[table].maxCols);
                              print(excel.tables[table].maxRows);
                              for (var row in excel.tables[table].rows) {
                                print("$row");
                              }
                            }

                            String file = await getFilePath();
                            //print(file);
                            if(file != null) {
                              excel.encode().then((onValue) {
                                File(file)
                                  ..createSync(recursive: true)
                                  ..writeAsBytesSync(onValue);
                              });
                              _showDialog();
                            }
                            else{
                              _showErrorDialog();
                            }
                            setState(() {
                              newPassword.clear();
                              for(int i=0;i<n;i++) {
                                newPassword.add(passWORD.elementAt(i));
                              }
                            });
                          }
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Generate Password',
                              style: TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),

                    if (newPassword.isNotEmpty && newPassword != null)
                      Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                isOk,
                                style: TextStyle(color: _color, fontSize: 25),
                              ),
                            ),
                          )),
                    if (newPassword.isNotEmpty && newPassword != null)
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: FixedColumnWidth(120.0),
                        children: [
                          TableRow(children :[
                            Text('SR No.',style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                            Text('Password',style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center),
                          ]),
                          for( num i=1; i<=n;i++)
                            TableRow(children :[
                              Text("$i",style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center),
                              Text(newPassword.elementAt(i-1),style: TextStyle(fontSize: 14.0),textAlign: TextAlign.center),
                            ]
                            ),
                        ],
                      ),

                    SizedBox(
                      height: 30,
                    ),

                  ]),
            ),
          ),
        ));
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          elevation: 5,

          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Excel file has been updated ..Please see Result_Management_System folder for excel file'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          elevation: 5,

          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Something went wrong...'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

}

