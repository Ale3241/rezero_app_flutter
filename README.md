# Re:Zero App 🗡️

Aplicación móvil hecha con **Flutter** como proyecto de clase, dedicada a la serie de anime *Re:Zero - Starting Life in Another World*. Incluye una portada con slider, personajes, momentos destacados con video integrado, una ficha técnica de la obra, un minijuego propio y una tarjeta de contacto.

> ⚠️ **Proyecto de fans, sin fines de lucro.** No está afiliado ni respaldado por los creadores, el estudio ni los distribuidores de la serie. Ver [Aviso de derechos de autor](#aviso-de-derechos-de-autor).

## Pantallas

| Pantalla | Qué hace |
|---|---|
| **Portada** | Slider automático de 3 imágenes con indicadores y menú de navegación. |
| **Personajes** | Lista de 3 personajes (Subaru, Emilia, Rem). Al tocar uno se abre su detalle con foto, rasgos y biografía, con animación `Hero`. |
| **Momentos Destacados** | 3 escenas con miniatura y descripción. Al abrir una, el video se reproduce **dentro de la app** (reproductor embebido, no abre YouTube). |
| **Acerca de** | Ficha técnica: creador, ilustrador, estudio, temporadas y episodios. |
| **Juega Conmigo** | Minijuego *runner* "Retorno por Muerte" (ver abajo). |
| **Contrátame** | Tarjeta de presentación con foto, descripción, habilidades y enlaces de contacto. |

## El minijuego: Retorno por Muerte

Un *runner* de un solo botón inspirado en la habilidad de Subaru. Cada vez que mueres, el bucle se reinicia y **cambia una regla**:

| Bucle | Mecánica |
|---|---|
| 1 | Solo saltas bloques. Tocas en cualquier parte de la pantalla. |
| 2 | Aparecen las **Manos Invisibles**: mantén el lado izquierdo para agacharte, toca el derecho para saltar. |
| 3 | **Controles invertidos**: izquierda salta, derecha agacha. |
| 4+ | La pista **acelera** en cada bucle, hasta un tope. |

Los obstáculos se generan con una **semilla fija**, así que el camino es siempre el mismo y los "fantasmas" de tus muertes anteriores aparecen donde moriste, como la memoria de Subaru. No es un juego de preguntas.

Todo el juego (personaje incluido) está dibujado en código con `CustomPainter`, sin imágenes ni motores de juego externos.

## Tecnologías

- [Flutter](https://flutter.dev) y Dart
- [`go_router`](https://pub.dev/packages/go_router): navegación y rutas con parámetros
- [`google_fonts`](https://pub.dev/packages/google_fonts): tipografías Cinzel y Lato
- [`youtube_player_iframe`](https://pub.dev/packages/youtube_player_iframe): video embebido
- [`audioplayers`](https://pub.dev/packages/audioplayers): sonido de reaparición en el juego
- [`url_launcher`](https://pub.dev/packages/url_launcher): enlaces de contacto

## Estructura

```
lib/
├── main.dart
├── router.dart
├── theme/app_theme.dart       # Paleta y tema oscuro
├── models/                    # Character, Moment
├── data/                      # Datos de personajes y momentos
├── widgets/hero_slider.dart   # Slider de la portada
└── screens/                   # Una pantalla por archivo
assets/
├── images/ (slider, characters, moments, about, profile)
└── sounds/
```

## Cómo ejecutarlo

Requisitos: Flutter instalado y un emulador o celular Android.

```bash
git clone https://github.com/Ale3241/rezero_app_flutter.git
cd rezero_app
flutter pub get
flutter run
```

Para generar el APK:

```bash
flutter build apk --release --split-per-abi
```

El archivo queda en `build/app/outputs/flutter-apk/`.

## Limitaciones conocidas

Para ser claros sobre el estado real del proyecto:

- **Requiere internet** para los videos y para descargar las fuentes la primera vez.
- **Los videos dependen de YouTube.** Si el dueño de un video desactiva la inserción o lo elimina, ese momento dejará de reproducirse. En algunos emuladores el reproductor no carga; es más fiable probarlo en un celular real.
- **Solo Android.** No se ha generado ni probado una versión para iOS.
- **El juego es sencillo:** sin guardado del récord entre sesiones, sin pausa y con un solo patrón de obstáculos.
- **Las biografías son resúmenes breves**, escritos de forma general. Pueden omitir detalles de la serie.
- [COMPLETA AQUÍ lo que hayas probado y en qué dispositivos, por ejemplo: "Probado en Pixel 7 (Android 14)"].

## Sobre el uso de IA

Este proyecto se construyó con **Claude (IA de Anthropic) como tutor**. La IA explicó los conceptos paso a paso y escribió o corrigió parte del código; yo lo integré, lo probé, lo adapté a mi gusto y elegí el diseño, el contenido, las escenas y las imágenes. Los efectos de sonido y el material de la serie los conseguí yo por mi cuenta.

## Aviso de derechos de autor

*Re:Zero - Starting Life in Another World* es una obra de **Tappei Nagatsuki** (novela ligera, ilustrada por **Shinichirou Otsuka**), adaptada al anime por el estudio **White Fox**. Los nombres, personajes, imágenes, videos y el efecto de sonido pertenecen a sus respectivos titulares.

Este repositorio es **un trabajo educativo sin fines de lucro**. Si eres titular de derechos y quieres que se retire algún material, abre un *issue* o contáctame y lo eliminaré.

El **código fuente** es propio. Los recursos de la serie no están cubiertos por ninguna licencia de este repositorio.

## Autor

**Solin Alexander Mordan Acosta**, 2023-0209
Desarrollo de software / ITLA

- Correo: alexacosta3241@gmail.com
- GitHub: @Ale3241(https://github.com/Ale3241)
- LinkedIn: Solin Alexander (Alex) Mordan Acosta(https://www.linkedin.com/in/solin-mordan/)

## Descarga

APK de la última versión: **https://drive.google.com/file/d/16yynGpZYxevj9gqk-uCAOcXqrfMjq3nh/view?usp=drive_link**
