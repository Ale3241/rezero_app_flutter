import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';

/// Un obstáculo en coordenadas del MUNDO (no de la pantalla).
/// hand = true -> Mano Invisible que cuelga desde arriba.
class Obstacle {
  final double x;
  final double w;
  final double h;
  final bool hand;
  const Obstacle(this.x, this.w, this.h, {this.hand = false});
}

/// Misma semilla = mismo camino en cada bucle (Subaru "recuerda").
List<Obstacle> generateObstacles(int seed) {
  final rnd = Random(seed);
  final list = <Obstacle>[];
  var x = 900.0;
  for (int i = 0; i < 200; i++) {
    final isHand = rnd.nextInt(100) < 35;
    final w = isHand ? 60.0 : 30 + rnd.nextInt(15).toDouble();
    final h = isHand ? 0.0 : 40 + rnd.nextInt(3) * 10.0;
    list.add(Obstacle(x, w, h, hand: isHand));
    x += w + 320 + rnd.nextInt(240);
  }
  return list;
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;

  static const double _gravity = 2200;
  static const double _jumpSpeed = 850;
  static const double _playerW = 40;
  static const double _playerH = 56;
  static const double _crouchScale = 0.55;
  static const double _handBottom = 38; // altura del borde inferior de la mano
  static const double _groundHeight = 90;
  static const int _seed = 42;

  late final List<Obstacle> _obstacles;
  double _screenW = 400;

  // Estado del jugador
  double _y = 0;
  double _vy = 0;
  double _scroll = 0;
  bool _dead = false;
  bool _canRestart = false;
  bool _crouching = false;
  final Set<int> _crouchPointers = {};

  // Memoria entre bucles
  int _loop = 1;
  double _best = 0;
  final List<double> _deathMarks = [];
  bool _flash = false;

  // Sonido de "Subaru volvió" (al aparecer y al revivir)
  final _returnPlayer = AudioPlayer();

  Future<void> _playReturnSound() async {
    try {
      await _returnPlayer.stop();
      await _returnPlayer.play(AssetSource('sounds/return_by_death.mp3'));
    } catch (_) {
      // Si falla el audio, el juego sigue funcionando
    }
  }

  // Mensaje de ayuda de cada bucle
  bool _hintVisible = true;
  int _hintToken = 0;

  int get _meters => (_scroll / 50).floor();
  int get _recordMeters => (max(_best, _scroll) / 50).floor();

  /// Bucle 4 en adelante: la pista acelera.
  double get _speed => min(520.0, 300.0 + max(0, _loop - 3) * 35.0);

  /// Bucle 1: nadie agacha. Bucle 2: izquierda agacha. Bucle 3+: invertido.
  bool _isCrouchSide(bool left) {
    if (_loop == 1) return false;
    if (_loop == 2) return left;
    return !left;
  }

  String get _hint {
    switch (_loop) {
      case 1:
        return 'Toca la pantalla para saltar';
      case 2:
        return 'Manos Invisibles: mantén IZQUIERDA para agacharte, '
            'toca DERECHA para saltar';
      case 3:
        return '¡Controles invertidos! IZQUIERDA salta, '
            'mantén DERECHA para agacharte';
      default:
        return '¡El tiempo se acelera!';
    }
  }

  String get _nextRule {
    switch (_loop) {
      case 1:
        return 'Aparecerán las Manos Invisibles';
      case 2:
        return 'Los controles se invertirán';
      default:
        return 'El tiempo se acelerará';
    }
  }

  @override
  void initState() {
    super.initState();
    _obstacles = generateObstacles(_seed);
    _ticker = createTicker(_onTick)..start();
    _showHint();
    _playReturnSound(); // Subaru aparece
  }

  void _showHint() {
    final token = ++_hintToken;
    _hintVisible = true;
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted && token == _hintToken) {
        setState(() => _hintVisible = false);
      }
    });
  }

  void _onTick(Duration elapsed) {
    var dt = (elapsed - _last).inMicroseconds / 1000000;
    _last = elapsed;
    if (dt > 0.05) dt = 0.05;
    if (_dead) return;

    setState(() {
      _scroll += _speed * dt;

      if (_y > 0 || _vy > 0) {
        _vy -= _gravity * dt;
        _y += _vy * dt;
        if (_y <= 0) {
          _y = 0;
          _vy = 0;
        }
      }

      _crouching = _crouchPointers.isNotEmpty && _y == 0;

      if (_hitsObstacle()) _die();
    });
  }

  bool _hitsObstacle() {
    final playerX = _screenW * 0.2;
    final pLeft = playerX + 8;
    final pRight = playerX + _playerW - 8;
    final headTop = _y + (_crouching ? _playerH * _crouchScale : _playerH);

    for (final o in _obstacles) {
      if (o.hand && _loop < 2) continue; // las manos aparecen desde el bucle 2
      var oLeft = o.x - _scroll;
      var oRight = oLeft + o.w;
      if (o.hand) {
        oLeft += 6;
        oRight -= 6;
      }
      if (oRight < 0) continue;
      if (oLeft > _screenW) break;

      final overlapsX = pRight > oLeft && pLeft < oRight;
      if (!overlapsX) continue;

      if (o.hand) {
        if (headTop - 4 > _handBottom) return true; // cabeza dentro de la mano
      } else if (_y < o.h - 4) {
        return true; // pies más bajos que el tope del bloque
      }
    }
    return false;
  }

  void _die() {
    _dead = true;
    _canRestart = false;
    _crouching = false;
    _crouchPointers.clear();
    _deathMarks.add(_scroll + _screenW * 0.2);
    if (_deathMarks.length > 8) _deathMarks.removeAt(0);
    if (_scroll > _best) _best = _scroll;
    // Evita reiniciar por accidente con el mismo toque que te mató
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _canRestart = true);
    });
  }

  void _jump() {
    if (_y == 0) _vy = _jumpSpeed;
  }

  void _restart() {
    _playReturnSound(); // Subaru revive
    setState(() {
      _loop++;
      _scroll = 0;
      _y = 0;
      _vy = 0;
      _dead = false;
      _crouching = false;
      _crouchPointers.clear();
      _flash = true;
      _showHint();
    });
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _flash = false);
    });
  }

  void _onPointerDown(PointerDownEvent e) {
    if (_dead) {
      if (_canRestart) _restart();
      return;
    }
    final left = e.localPosition.dx < _screenW / 2;
    if (_isCrouchSide(left)) {
      _crouchPointers.add(e.pointer);
    } else {
      _jump();
    }
  }

  void _onPointerEnd(PointerEvent e) {
    _crouchPointers.remove(e.pointer);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _returnPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Juega Conmigo')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          _screenW = constraints.maxWidth;
          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _onPointerDown,
            onPointerUp: _onPointerEnd,
            onPointerCancel: _onPointerEnd,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1) El juego
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GamePainter(
                      y: _y,
                      scroll: _scroll,
                      playerW: _playerW,
                      playerH: _playerH,
                      groundHeight: _groundHeight,
                      obstacles: _obstacles,
                      deathMarks: _deathMarks,
                      crouching: _crouching,
                      handsOn: _loop >= 2,
                      crouchScale: _crouchScale,
                      handBottom: _handBottom,
                    ),
                  ),
                ),

                // 2) HUD
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: IgnorePointer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Bucle $_loop',
                            style: const TextStyle(
                                color: AppColors.blood,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Text('$_meters m  ·  récord $_recordMeters m'),
                      ],
                    ),
                  ),
                ),

                // 3) Ayuda del bucle actual
                Positioned(
                  top: 44,
                  left: 24,
                  right: 24,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _hintVisible && !_dead ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.purple),
                        ),
                        child: Text(_hint, textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),

                // 4) Etiquetas de las zonas táctiles (desde el bucle 2)
                if (_loop >= 2)
                  Positioned(
                    bottom: 28,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.5,
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  _isCrouchSide(true) ? 'AGACHARSE' : 'SALTAR',
                                  style: const TextStyle(letterSpacing: 2),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _isCrouchSide(false)
                                      ? 'AGACHARSE'
                                      : 'SALTAR',
                                  style: const TextStyle(letterSpacing: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // 5) Pantalla de muerte
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _dead ? 1 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        color: const Color(0xCC0A0A0F),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'RETORNO POR MUERTE',
                              textAlign: TextAlign.center,
                              style: theme.appBarTheme.titleTextStyle
                                  ?.copyWith(
                                      fontSize: 26, color: AppColors.blood),
                            ),
                            const SizedBox(height: 12),
                            Text('Llegaste a $_meters m'),
                            const SizedBox(height: 4),
                            Text('Bucle $_loop  →  Bucle ${_loop + 1}'),
                            const SizedBox(height: 10),
                            Text(_nextRule,
                                style: const TextStyle(
                                    color: AppColors.purple,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            const Text('Toca para volver atrás en el tiempo'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 6) Destello morado al reiniciar
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _flash ? 0.7 : 0,
                      duration: _flash
                          ? Duration.zero
                          : const Duration(milliseconds: 600),
                      child: Container(color: AppColors.purple),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GamePainter extends CustomPainter {
  final double y;
  final double scroll;
  final double playerW;
  final double playerH;
  final double groundHeight;
  final List<Obstacle> obstacles;
  final List<double> deathMarks;
  final bool crouching;
  final bool handsOn;
  final double crouchScale;
  final double handBottom;

  _GamePainter({
    required this.y,
    required this.scroll,
    required this.playerW,
    required this.playerH,
    required this.groundHeight,
    required this.obstacles,
    required this.deathMarks,
    required this.crouching,
    required this.handsOn,
    required this.crouchScale,
    required this.handBottom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final groundTop = size.height - groundHeight;

    // Suelo
    canvas.drawRect(
      Rect.fromLTWH(0, groundTop, size.width, groundHeight),
      Paint()..color = AppColors.surface,
    );
    canvas.drawLine(
      Offset(0, groundTop),
      Offset(size.width, groundTop),
      Paint()
        ..color = AppColors.purple
        ..strokeWidth = 3,
    );

    // Marcas del suelo que se mueven
    const gap = 60.0;
    final offset = scroll % gap;
    final markPaint = Paint()
      ..color = AppColors.purple.withValues(alpha: 0.4)
      ..strokeWidth = 2;
    for (double x = -offset; x < size.width; x += gap) {
      canvas.drawLine(
        Offset(x, groundTop + 25),
        Offset(x + 20, groundTop + 25),
        markPaint,
      );
    }

    // Obstáculos
    final blockPaint = Paint()..color = AppColors.blood;
    final shinePaint = Paint()..color = Colors.white.withValues(alpha: 0.25);
    for (final o in obstacles) {
      if (o.hand && !handsOn) continue;
      final sx = o.x - scroll; // del mundo a la pantalla
      if (sx + o.w < 0) continue;
      if (sx > size.width) break;

      if (o.hand) {
        _drawHand(canvas, sx, groundTop - handBottom);
      } else {
        final r = Rect.fromLTWH(sx, groundTop - o.h, o.w, o.h);
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(6)),
          blockPaint,
        );
        canvas.drawRect(
          Rect.fromLTWH(sx + 4, groundTop - o.h + 4, o.w - 8, 4),
          shinePaint,
        );
      }
    }

    // Fantasmas de tus muertes anteriores
    for (final mark in deathMarks) {
      final gx = mark - scroll;
      if (gx + playerW < 0 || gx > size.width) continue;
      final gy = groundTop - playerH;
      canvas.saveLayer(
        Rect.fromLTWH(gx - 10, gy - 20, playerW + 20, playerH + 30),
        Paint()..color = Colors.white.withValues(alpha: 0.25),
      );
      _drawSubaru(canvas, Offset(gx, gy), 0, false);
      canvas.restore();
    }

    // Subaru (agachado = aplastado verticalmente desde los pies)
    final playerX = size.width * 0.2;
    final feetY = groundTop - y;
    if (crouching) {
      canvas.save();
      canvas.translate(playerX, feetY);
      canvas.scale(1, crouchScale);
      _drawSubaru(canvas, Offset(0, -playerH), scroll / 14, false);
      canvas.restore();
    } else {
      _drawSubaru(
          canvas, Offset(playerX, feetY - playerH), scroll / 14, y > 0);
    }
  }

  /// Mano Invisible: cuelga desde arriba hasta [bottomY].
  void _drawHand(Canvas canvas, double sx, double bottomY) {
    final body = Paint()..color = const Color(0xCC3A0D5C);
    final edge = Paint()
      ..color = AppColors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final cx = sx + 30;

    // Brazo
    canvas.drawRect(Rect.fromLTRB(cx - 10, 0, cx + 10, bottomY - 22), body);

    // Palma
    final palm = RRect.fromRectAndRadius(
      Rect.fromLTRB(cx - 24, bottomY - 28, cx + 24, bottomY - 8),
      const Radius.circular(8),
    );
    canvas.drawRRect(palm, body);
    canvas.drawRRect(palm, edge);

    // Dedos
    for (int i = 0; i < 4; i++) {
      final fx = cx - 22 + i * 12.0;
      final f = RRect.fromRectAndRadius(
        Rect.fromLTWH(fx, bottomY - 14, 9, 14),
        const Radius.circular(4),
      );
      canvas.drawRRect(f, body);
      canvas.drawRRect(f, edge);
    }
  }

  void _drawSubaru(Canvas canvas, Offset origin, double phase, bool airborne) {
    final swing = airborne ? 0.7 : sin(phase);

    // Paleta de Subaru
    final skin = Paint()..color = const Color(0xFFF1C9A5);
    final hair = Paint()..color = const Color(0xFF15131A);
    final jacketWhite = Paint()..color = const Color(0xFFF4F4F4);
    final deepGrey = Paint()..color = const Color(0xFF3E3E48);
    final orange = Paint()..color = const Color(0xFFFF8A1F);
    final pants = Paint()..color = const Color(0xFF24222B);
    final white = Paint()..color = Colors.white;
    final iris = Paint()..color = const Color(0xFF4A2E1B);

    canvas.save();
    canvas.translate(origin.dx, origin.dy);

    void limb(Offset pivot, double length, double width, double angle,
        Paint paint,
        {Paint? stripe, Paint? cuff}) {
      canvas.save();
      canvas.translate(pivot.dx, pivot.dy);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-width / 2, 0, width, length),
          Radius.circular(width / 2),
        ),
        paint,
      );
      if (stripe != null) {
        canvas.drawRect(Rect.fromLTWH(-1, 2, 2, length - 7), stripe);
      }
      if (cuff != null) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(-width / 2 - 1, length - 5, width + 4, 5),
            const Radius.circular(2),
          ),
          cuff,
        );
      }
      canvas.restore();
    }

    // Piernas
    limb(const Offset(20, 38), 18, 9, swing * 0.8, pants, cuff: orange);
    limb(const Offset(20, 38), 18, 9, -swing * 0.8, pants, cuff: orange);

    // Chaqueta blanca con hombros gris oscuro
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8, 22, 24, 18),
        const Radius.circular(6),
      ),
      jacketWhite,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTWH(8, 22, 24, 6),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      ),
      deepGrey,
    );
    canvas.drawRect(
      const Rect.fromLTWH(19.5, 28, 1.5, 12),
      Paint()..color = const Color(0xFFB9B9C2),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(14, 20, 12, 5),
        const Radius.circular(2),
      ),
      jacketWhite,
    );

    // Cabeza
    canvas.drawCircle(const Offset(20, 13), 11, skin);

    // Pelo negro de puntas
    final hairPath = Path()
      ..moveTo(9, 12)
      ..lineTo(7, 1)
      ..lineTo(14, 6)
      ..lineTo(16, -4)
      ..lineTo(21, 5)
      ..lineTo(26, -3)
      ..lineTo(28, 6)
      ..lineTo(34, 0)
      ..lineTo(31, 12)
      ..close();
    canvas.drawPath(hairPath, hair);

    // Ojos sanpaku y boca
    canvas.drawOval(const Rect.fromLTWH(16, 11, 6, 7), white);
    canvas.drawOval(const Rect.fromLTWH(25, 11, 6, 7), white);
    canvas.drawCircle(const Offset(20.5, 14.5), 1.4, iris);
    canvas.drawCircle(const Offset(29.5, 14.5), 1.4, iris);
    canvas.drawLine(
      const Offset(23, 20),
      const Offset(28, 20),
      Paint()
        ..color = Colors.black87
        ..strokeWidth = 1.5,
    );

    // Brazo delantero
    limb(const Offset(20, 27), 14, 7, swing * 0.9, deepGrey,
        stripe: orange, cuff: orange);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GamePainter old) => true;
}
