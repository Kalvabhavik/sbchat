
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:glass_kit/glass_kit.dart';

import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import "package:cloud_firestore/cloud_firestore.dart";
class Chat extends StatefulWidget {
  final dynamic name;

  const Chat({super.key,required this.name});



  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _controller=TextEditingController();


  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(1),
        ),

        shadowColor: Colors.deepPurple,
        elevation: 10,
        backgroundColor: Colors.blue[900],
        title: Center(
          child: Text("HELLO ${widget.name.toString().toUpperCase()}", style: GoogleFonts.pressStart2p()),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset("assets/back2.webp", fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 50,

            child: Container(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(stream: db.collection("chats").orderBy("timestamp",descending: true).snapshots(), builder: (context,snp){
                final data=snp.data!.docs;
                if(snp.connectionState==ConnectionState.waiting){

                }
                return ListView.builder(
                  itemCount: data.length,
                    reverse: true,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Positioned(

                          left: 80,
                          child: Row(
                            mainAxisAlignment: data[index]["name"]==widget.name?MainAxisAlignment.end:MainAxisAlignment.start,
                            children: [
                              GlassContainer.frostedGlass(
                                elevation: 5,
                                borderColor: Colors.white,
                                borderRadius:data[index]["name"]==widget.name? BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)):BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                height: 70,
                                width: 200,
                                child: GestureDetector(
                                  onDoubleTap: (){
                                    showDialog(context: context, builder: (context){
                                      return Dialog(
                                        child: Container(
                                          height: 500,
                                          width: 200,
                                          child: Column(
                                            children: [
                                              Card(
                                                  color:Colors.green,
                                                  child: Text("            ${data[index]["name"]}            ")),
                                              Center(
                                                child: Wrap(
                                                  children: [
                                                    Text("${data[index]["text"]}",style: GoogleFonts.pressStart2p(
                                                        fontSize: _controller.text.toString().length+10
                                                    ),)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ),
                                      );
                                    });
                                  },
                                  onLongPress: (){
                                    showDialog(context: context, builder: (context){
                                      return Dialog(
                                        child: Container(
                                          height: 50,
                                          width: 200,
                                          child: TextButton(
                                              style: ButtonStyle(
                                                backgroundColor: WidgetStateColor.transparent,

                                              ),
                                              onPressed: ()async{
                                                await db.collection("chats").doc(data[index].id).delete();
                                                print("deleted");
                                                Navigator.pop(context);

                                          }, child: Text("DELETE")),
                                        ),
                                      );
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                                    ),
                                    child: Column(
                                      children: [
                                        FittedBox(
                                          child: Container(
                                            color:Colors.transparent,
                                            child: Text("${data[index]["name"]}",style: TextStyle(
                                              fontSize: 15
                                            ),),
                                          ),
                                        ),
                                        Wrap(
                                          children: [Container(
                                            color:Colors.transparent,
                                            child: data[index]["text"].length+1<50?Text("${data[index]["text"]}",style: GoogleFonts.pressStart2p(
                                              fontSize: _controller.text.toString().length+10
                                            ),):Text("Long Text pls double tap to View the message"),
                                          ),]
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Colors.blue,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()async {
                      if(_controller.text==""){
                        print("null messagge");
                      }
                      else {
                        try {
                          await db.collection("chats").add({
                            "name": widget.name,
                            "text": _controller.text,
                            "timestamp": FieldValue.serverTimestamp()
                          });
                          print("sent");
                          setState(() {
                            _controller.clear();
                          });
                        }
                        catch (e) {
                          print(e);
                        }
                      }


                    },
                    child: GlassContainer.frostedGlass(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      borderColor: Colors.white,
                      height: 50,
                      width: 50,
                      child: Icon(Icons.send),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
