import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:glass_kit/glass_kit.dart';
import 'chat.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import "package:cloud_firestore/cloud_firestore.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      )
      );
}


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset("assets/back.jpg",fit: BoxFit.cover,)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: GoogleFonts.pressStart2p(
                    fontSize: 50-30,
                    color: Colors.white
                  ),
                  child: ShaderMask(
                    shaderCallback: ((bounds) {
                      return LinearGradient(colors: [?Colors.blue[900],Colors.cyan,Colors.purple],begin: AlignmentGeometry.topCenter,end: AlignmentGeometry.bottomCenter).createShader(bounds);
                    }),
                    child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [TyperAnimatedText("Enter Your Name..."
                        ,speed: const Duration(milliseconds: 200)
                        ),]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: ((bounds) {
                      return LinearGradient(colors: [?Colors.blue[900],Colors.cyan,Colors.purple],begin: AlignmentGeometry.topCenter,end: AlignmentGeometry.bottomCenter).createShader(bounds);
                    }),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                      controller: _controller,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(_controller.text.toString().isEmpty){
                      _controller.text="Unknown";
                    }
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Chat(name: _controller.text)));
                  },
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [Colors.cyan,Colors.white])
                    ),
                    child: Center(child: Text("Next",style: GoogleFonts.pressStart2p(),)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

