import 'package:flutter/material.dart';

//语音识别
class SpeakPage extends StatefulWidget {
  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage> with SingleTickerProviderStateMixin {
  String speakTips = '长按说话';
  String speakResult = '';
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    animation  = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) { //监听状态
        if(status == AnimationStatus.completed) { //完成
          controller.reverse();
        }else if(status == AnimationStatus.dismissed){ //动画关闭
          controller.forward();
        }
      });
    // controller.forward();
    super.initState();
    //启动动画(正向执行)

  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _topItem(),
            _bottomItem()
          ],
        ),
      )
    );
  }
  _topItem() {
     return Column(
       children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Text('你可以这样说',style:TextStyle(fontSize: 16,color: Colors.black54)),
          ) ,
         Text('故宫门票\n北京一日游\n迪士尼乐园',
           textAlign: TextAlign.center,
           style: TextStyle(
               fontSize: 15,color:Colors.grey
           ),),
         Padding(
           padding: EdgeInsets.all(20),
           child: Text(speakResult,style: TextStyle(color: Colors.blue),),
         )
       ],
     );
  }

  _bottomItem() {
    return FractionallySizedBox(
      child: Stack(
        children: [
          GestureDetector(
            onTapDown:(e) {
              _speakStart();
            },
            onTapUp: (e) {
              _speakStop();
            },
            onTapCancel: () {
              _speakStop();
            },
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(speakTips,style: TextStyle(color: Colors.blue,fontSize: 12),),),
                  Stack(
                    children: [
                      Container( //占坑，避免动画执行过程中导致父布局大小变化
                        width: MIC_SIZE,
                        height: MIC_SIZE,
                      ),
                      Center(
                        child: AnimatedMic(
                          animation:animation,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _speakStart() {
    controller.forward();
  }

  void _speakStop() {
    controller.reset(); //恢复原位
    controller.stop();
  }
}

const double MIC_SIZE = 80;
class AnimatedMic extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 1,end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE,end:MIC_SIZE-20);

  AnimatedMic({Key? key,required Animation<double> animation})
      : super(key:key,listenable: animation);

   @override
  Widget build(BuildContext context) {
     final Animation<double> animation = listenable as Animation<double>;

     return Opacity(
         opacity: _opacityTween.evaluate(animation),
       child:Container(
         width: _sizeTween.evaluate(animation),
         height: _sizeTween.evaluate(animation),
         decoration: BoxDecoration(
           color: Colors.blue,
           borderRadius: BorderRadius.circular(MIC_SIZE/2)
         ),
         child: Icon(
           Icons.mic,
           color: Colors.white,
           size: 30,
         ),
       ),
     );
   }
}