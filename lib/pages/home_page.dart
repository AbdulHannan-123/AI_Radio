

import 'package:airadio/model/radio.dart';
import 'package:airadio/utils/ai_util.dart';
import 'package:alan_voice/alan_voice.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:velocity_x/velocity_x.dart';




// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<MyRadio>? radios;
  // ignore: unused_field
    MyRadio? _selectedRadio;
  // ignore: prefer_final_fields
    Color ?_selectedColor;
  bool _isPlaying = false;
  final sugg = [
    "Play",
    "Stop",
    "Play rock music",
    "Play 107 FM",
    "Play next",
    "Play 104 FM",
    "Pause",
    "Play previous",
    "Play pop music"
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void initState() {
    super.initState();
    setupAlan();
    fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  setupAlan(){
    AlanVoice.addButton(
        "e74d2d304be14820fdde32edc00a22022e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT); 
        AlanVoice.callbacks.add((command)=> _handleCommand(command.data));
  }

  _handleCommand(Map<String , dynamic> response){
    switch (response["command"]) {
      case "play":
      print('this is play');
      _playMusic(UrlSource(_selectedRadio!.url));
      break;

      case "play_channal":
      final id = response["id"];

      _audioPlayer.pause();
        MyRadio newRadio = radios!.firstWhere((element) => element.id==id);
        radios!.remove(newRadio);
        radios!.insert(0, newRadio);
        _playMusic(UrlSource(newRadio.url));

      break;

      case "stop":
      _audioPlayer.stop();      
      break;

      case "next":
      print('this next is called ');
      final index = _selectedRadio!.id;
      MyRadio newRadio;
        if(index+1>radios!.length){
        newRadio = radios!.firstWhere((element) => element.id==1);
        radios!.remove(newRadio);
        radios!.insert(0, newRadio);
        
      _playMusic(UrlSource(newRadio.url));
        print(newRadio.id);
      }else{
        newRadio = radios!.firstWhere((element) => element.id==index+1);
        radios!.remove(newRadio);
        radios!.insert(0, newRadio);
        
      _playMusic(UrlSource(newRadio.url));
      }
    
        break;
      case "prev":
      print('this previos is called ');
      final index = _selectedRadio!.id;
      MyRadio newRadio;
        if(index-1<0){
        newRadio = radios!.firstWhere((element) => element.id==1);
        radios!.remove(newRadio);
        radios!.insert(0, newRadio);
      _playMusic(UrlSource(newRadio.url));
        print(newRadio.id);
      }else{
        newRadio = radios!.firstWhere((element) => element.id==index-1);
        radios!.remove(newRadio);
        radios!.insert(0, newRadio);
        
      _playMusic(UrlSource(newRadio.url));
      }
    
        break;
      default:
      // ignore: avoid_print
      print("command was ${response["command"]}");
      break;
    }
  }

  fetchRadios()async{
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios![0];
    
    int? finalcolor = int.tryParse(_selectedRadio!.color);
    _selectedColor =Color(finalcolor!);

    // ignore: avoid_print
   // print(radios);
   // print('1');
    setState(() {
      
    });
  }

  // ignore: unused_element
  _playMusic(Source url){
    _audioPlayer.play(url);
   
    // ignore: unrelated_type_equality_checks
    _selectedRadio =  radios!.firstWhere((element) => url == url);
    // ignore: avoid_print
    print(_selectedRadio!.name);
    setState(() {
      
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: prefer_const_constructors
      drawer: Drawer(
        child: Container(
          color: _selectedColor?? AIColors.primarycolor2,
          child: radios!=null
          ?[
            100.heightBox,
            "All Channanls".text.xl.white.semiBold.make().px16(),
            20.heightBox,
            ListView(
              padding: Vx.m0,
              shrinkWrap: true,
              children: radios!.map((e)=>ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(e.icon),
                ),
                title: "${e.name} FM".text.white.make(),
                subtitle: e.tagline.text.white.make(),
              )).toList(),
            ).expand()
          ].vStack(crossAlignment: CrossAxisAlignment.start)
          :const Offstage(),
        ),
      ),
      body: Stack(
        // ignore: sort_child_properties_last
        children: [
          VxAnimatedBox().size(context.screenWidth, context.screenHeight)
          .withGradient(LinearGradient(
            colors:[
              AIColors.primarycolor2,
              _selectedColor?? AIColors.primarycolor1,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          
          ))
          .make(),
         [ AppBar(
            title:"Ai Radio".text.xl4.bold.white.make().shimmer(
              primaryColor: Vx.purple300,
              secondaryColor: Vx.white,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(100.0).p16(),
          "Start with  - Hey Alan 👌".text.italic.semiBold.white.make(),
          10.heightBox,

          VxSwiper.builder(
           itemCount: sugg.length,
           height: 50.0,
           viewportFraction: 0.35,
           autoPlay: true,
           autoPlayAnimationDuration: 3.seconds,
           autoPlayCurve: Curves.linear,
           enableInfiniteScroll: true,
           itemBuilder: (context , index){
            final s = sugg[index];
            return Chip(
              label: s.text.make(),
              backgroundColor: Vx.randomColor,
            );
          })
          ].vStack(),
          30.heightBox,
          radios != null ? VxSwiper.builder(
            itemCount: radios!.length,
            // aspectRatio: context.mdWindowSize == MobileDeviceSize.small?255.0
            //   :context.mdWindowSize == MobileDeviceSize.medium
            //   ? 2.0
            //   : 3.0,
            aspectRatio: 1.0,        //// please use this line if you want to use it on android 

            // aspectRatio: 2.0,
            enlargeCenterPage: true,
            onPageChanged: (index) {
              _selectedRadio = radios?[index];
              // ignore: avoid_print
              print(_selectedRadio);
             final colorHex =radios?[index].color;
             int? finalcolor = int.tryParse(colorHex!);
            //  print(colorHex);
              _selectedColor =Color(finalcolor!);
              // ignore: avoid_print
              print(_selectedColor);
              setState(() {
                
              });
            },
            itemBuilder:(context, index) {
            final rad = radios![index];

            return VxBox(
              child: ZStack([

                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: VxBox(
                    child: rad.category.text.uppercase.white.make()
                    .p16(),
                  )
                  .height(40).black.alignCenter
                  .withRounded(value: 10)
                  .make(),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: VStack([
                    
                    rad.name.text.xl3.white.bold.make(),
                    5.heightBox,
                    rad.tagline.text.sm.semiBold.white.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: 
                    // ignore: prefer_const_constructors
                    [Icon(CupertinoIcons.play_circle,
                     color: Colors.white,
                ),
                10.heightBox,
                "Double Tap to Play".text.gray300.make(),
                ].vStack()
                )
              ],
              // clip: Clip.antiAlias,
              )
            ).clip(Clip.antiAlias)
            .bgImage(DecorationImage(
              image: NetworkImage(rad.image),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)
            ))
            .border(color: Colors.black,width: 5.0)
            .withRounded(value: 60.0)
            .make()
            .onInkDoubleTap(() {
              setState(() {
                _playMusic(UrlSource(rad.url));
              });
             })
            .p16();
            // .centered();
           },
           ).centered():const Center(child: CircularProgressIndicator(),),
           Align(
            alignment: Alignment.bottomCenter,
            child: [
              if(_isPlaying)
              "Playing now - ${_selectedRadio!.name} FM".text.white.makeCentered(),
              Icon(
              _isPlaying
                  ? CupertinoIcons.stop_circle
                  :CupertinoIcons.play_circle,
               color: Colors.white,
               size: 50.0,
               ).onInkTap(() {
                if(_isPlaying){
                  _audioPlayer.stop();
                }else{
                  _playMusic(UrlSource(_selectedRadio!.url));
                  // ignore: avoid_print
                  print(_selectedRadio!.url);
                }
               }),
               
               ].vStack()
           ).pOnly(bottom: context.percentHeight * 12)                       
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}


///////////////////////////// a method to convert the color into hex;

// int? hexColor(String color){
//   String newColor = '#$color';
//   newColor = newColor.replaceAll('0xff', '');
//   int? finalcolor = int.tryParse(newColor);
//   return finalcolor;
// }