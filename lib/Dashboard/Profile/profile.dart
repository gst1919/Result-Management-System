import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class profile extends StatefulWidget{
  @override
  _profileState createState()=> _profileState();
}

class _profileState extends State<profile>{
  String myEmail;
  String name;
  String Roll_num;
  String branch;
  String course;
  String batch;
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.lightBlueAccent,
        //automaticallyImplyLeading: false,
        title: Text("Profile" ,style: TextStyle(fontSize: 26,),),
    ),

    body: SingleChildScrollView(
      child: Center(
        child: FutureBuilder(
          future: _fetch(),
          builder: (context , snapshot){
            if(snapshot.connectionState != ConnectionState.done)
              return Center(
                child: Container(
                  margin: EdgeInsets.only(top: 150),
                  child: Column(
                      children: <Widget>[
                          CupertinoActivityIndicator(
                          radius:10,
                        ),

                      ]),
                ),
              );

              return Container(
                margin: EdgeInsets.only(top: 15),
                color: Colors.white54,
                child: Column(
                      children: <Widget>[
                         CircleAvatar(
                           backgroundColor: Colors.black12,
                           radius: 60,
                             child: ClipOval(
                               child: Image.network(
                                 'https://image.flaticon.com/icons/png/128/1077/1077063.png',
                                 width: 100,
                                 height: 100,
                                 fit: BoxFit.cover,
                                 color: Colors.pinkAccent,
                               ),
                             )
                         ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        ListTile(
                          leading: Icon(Icons.home,color: Colors.pinkAccent,),
                          title: Text(
                              "Name",
                              textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.black),

                          ),
                          subtitle: Text(name,style: TextStyle(fontSize: 14),),
                          dense: true,
                        ),
                        Divider(thickness: 0.5,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                        ),
                        ListTile(
                          leading: Icon(Icons.email,color: Colors.pinkAccent,),
                          title: Text(
                            "Email",
                            textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.black),

                          ),
                          subtitle: Text(myEmail,style: TextStyle(fontSize: 14),),
                          dense: true,
                        ),
                        Divider(thickness: 0.5,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                        ),
                        ListTile(
                          leading: Icon(Icons.format_list_numbered,color: Colors.pinkAccent,),
                          title: Text(
                            "Roll Number",
                            textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.black),

                          ),
                          subtitle: Text(Roll_num,style: TextStyle(fontSize: 14),),
                          dense: true,
                        ),
                        Divider(thickness: 0.5,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                        ),
                        ListTile(
                          leading: Icon(Icons.article_outlined,color: Colors.pinkAccent,),
                          title: Text(
                            "Course",
                            textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.black),

                          ),
                          subtitle: Text(course,style: TextStyle(fontSize: 14),),
                          dense: true,
                        ),
                        Divider(thickness: 0.5,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                        ),
                        ListTile(
                          leading: Icon(Icons.brightness_5_sharp,color: Colors.pinkAccent,),
                          title: Text(
                            "Branch",
                            textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(branch,style: TextStyle(fontSize: 14),),
                          dense: true,
                        ),
                        Divider(thickness: 0.5,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                        ),
                        ListTile(
                          leading: Icon(Icons.batch_prediction,color: Colors.pinkAccent,),
                          title: Text(
                            "Batch",
                            textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(batch,style: TextStyle(fontSize: 14),),
                          dense: true,
                        ),
                      ],

                ));
          }


        ),
      ),
    )

    );


  }


 _fetch() async{
  final firebaseuser = await FirebaseAuth.instance.currentUser();

  if(firebaseuser!=null){
  await Firestore.instance
        .collection('Student')
        .document(firebaseuser.uid)
        .get()
        .then((ds){
         myEmail=ds.data['Email'];
         name=ds.data['Name'];
         Roll_num = ds.data['Roll Number'];
         branch=ds.data['Branch'];
         course=ds.data['Course'];
         batch = ds.data['Batch'];
    //print(myEmail);
  }).catchError((e){
    print(e);
  });
  }
}
}