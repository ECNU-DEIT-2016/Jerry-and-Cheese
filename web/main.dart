import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:math' as math;

Future main() async {

  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.inputEventMode = InputEventMode.MouseAndTouch;
  StageXL.stageOptions.backgroundColor = Color.White;

  // init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 600, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  //画线
  var arcsShape = new Shape();
  var arcs = 'M 80 480 l 180 0 a25 90 -180 0 1 180 0 l 180 0';   
  /*l 50 -25 a25 25 -30 0 1 50 -25 
  l 50 -25 a25 25 -30 0 1 50 -25
   l 50 -25 a25 25 -30 0 1 50 -25 180 125';*/
  arcsShape.graphics.decodePath(arcs);
  arcsShape.graphics.strokeColor(Color.Blue, 5);
  stage.addChild(arcsShape);


  // load resources

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("flowers", "images/mouse1.png");
  await resourceManager.load();

  var flowers = resourceManager.getBitmapData("flowers");
  var flowersList = <BitmapData>[
    new BitmapData.fromBitmapData(flowers, new Rectangle(0 * 128, 0, 128, 128)),
    //new BitmapData.fromBitmapData(flowers, new Rectangle(1 * 128, 0, 128, 128)),
    //new BitmapData.fromBitmapData(flowers, new Rectangle(2 * 128, 0, 128, 128)),
  ];

  // Create 100 random flowers around the center of the Stage

  var random = new math.Random();

  for (var i = 0; i < 1; i++) {

    var bitmapData = flowersList[random.nextInt(1)];
    var bitmap = new Bitmap(bitmapData);
    bitmap.pivotX = 64;
    bitmap.pivotY = 64;

    var sprite = new Sprite();
    var randomRadius = random.nextDouble() * 200;
    var randomAngle = random.nextDouble() * 2 * math.pi;
    sprite.addChild(bitmap);
    sprite.x = 300 + randomRadius * math.cos(randomAngle);
    sprite.y = 300 + randomRadius * math.sin(randomAngle);
    sprite.addTo(stage);

    // add event handlers to start or stop dragging

    void startDrag(Event e) {
      stage.addChild(sprite); // bring to foreground
      sprite.scaleX = sprite.scaleY = 1.0;
      //sprite.filters.add(new ColorMatrixFilter.adjust(hue: -0.5));
      sprite.startDrag(true);
    }

    void stopDrag(Event e) {
      sprite.scaleX = sprite.scaleY = 1.0;
      sprite.filters.clear();
      sprite.stopDrag();
    }

    sprite.onMouseDown.listen(startDrag);
    sprite.onTouchBegin.listen(startDrag);
    sprite.onMouseUp.listen(stopDrag);
    sprite.onTouchEnd.listen(stopDrag);
    stage.onMouseLeave.listen(stopDrag);
  }
}