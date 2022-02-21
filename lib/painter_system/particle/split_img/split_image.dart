
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'particle.dart';
import 'package:image/image.dart' as image;
import 'particle_manage.dart';
import 'world_render.dart';

/// create by 张风捷特烈 on 2020/11/5
/// contact me by email 1981462002@qq.com
/// 说明:

class SplitImage extends StatefulWidget {
  @override
  _SplitImageState createState() => _SplitImageState();
}

class _SplitImageState extends State<SplitImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ParticleManage pm = ParticleManage();
  Random random = Random();

  @override
  void initState() {
    super.initState();
    initParticles();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(pm.tick);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void theWorld() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_,constraints){
        pm.size = constraints.biggest;
        return Stack(
          children: [
            GestureDetector(
              onTap: theWorld,
              child: CustomPaint(
                size: pm.size,
                painter: WorldRender(manage: pm),
              ),
            ),
            // Positioned(
            //     right: 0,
            //     child: IconButton(
            //   onPressed: initParticles,
            //   icon: Icon(Icons.refresh,color: Colors.blue,),
            // ))
          ],
        );
      },
    );

  }

  void initParticles() async {
    ByteData data = await rootBundle.load("assets/images/flutter.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    image.Image? imageSrc = image.decodeImage(bytes);

    if(imageSrc==null) return;

    double offsetX=  (pm.size.width-imageSrc.width)/2;
    double offsetY=  (pm.size.height-imageSrc.height)/2;

    for (int i = 0; i < imageSrc.width; i++) {
      for (int j = 0; j < imageSrc.height; j++) {
        if (imageSrc.getPixel(i, j) == 0xff000000) {
          Particle particle = Particle(
              x: i * 1.0+ offsetX,
              y: j * 1.0+ offsetY,
                  vx: 4 * random.nextDouble() * pow(-1, random.nextInt(20)),
                  vy: 4 * random.nextDouble() * pow(-1, random.nextInt(20)),
                  ay: 0.1,
              size: 0.5,
              color: Colors.blue); //产生粒子---每个粒子拥有随机的一些属性信息
          pm.particles.add(particle);
        }
      }
    }
    pm.tick(run: false);
  }
}