import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class HireScreen extends StatelessWidget {
  const HireScreen({super.key});

  // ✏️ EDITA ESTOS DATOS CON LOS TUYOS
  static const _name = 'Solin Alexander Mordan Acosta';
  static const _role = 'Desarrollador de Software';
  static const _bio =
      'Desarrollador móvil en formación, en plena etapa de pruebas con '
      'Flutter. Construí esta app desde cero, con diseño propio y un juego '
      'original. Listo para aprender rápido en un equipo real.';
  static const _skills = ['Flutter', 'Dart', 'Git', 'UI/UX', 'Firebase'];

  // (icono, etiqueta, texto visible, enlace real)
  static const _contacts = [
    (
      Icons.email,
      'Correo',
      'alexacosta3241@gmail.com',
      'mailto:alexacosta3241@gmail.com',
    ),
    (Icons.phone, 'Teléfono', '+1 939 732 1796', 'tel:+9397321796'),
    (Icons.code, 'GitHub', 'github.com/Ale3241', 'https://github.com/Ale3241'),
    (
      Icons.work,
      'LinkedIn',
      'https://linkedin.com/in/solin-alexander-mordan-acosta-29bb5b24b',
      'https://linkedin.com/in/solin-alexander-mordan-acosta-29bb5b24b',
    ),
  ];

  Future<void> _open(BuildContext context, String url) async {
    try {
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!ok && context.mounted) _showError(context);
    } catch (_) {
      if (context.mounted) _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('No se pudo abrir el enlace')));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Contrátame')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tarjeta de presentación
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.purple, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withValues(alpha: 0.25),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              children: [
                // Foto con borde degradado morado -> rojo
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.purple, AppColors.blood],
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile/me.jpg',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 140,
                        height: 140,
                        color: AppColors.background,
                        child: const Icon(
                          Icons.person,
                          size: 72,
                          color: AppColors.purple,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _name,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                const Text(
                  _role,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blood,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 28, color: Color(0x33FFFFFF)),
                Text(
                  _bio,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final s in _skills)
                      Chip(
                        label: Text(s),
                        backgroundColor: AppColors.background,
                        side: const BorderSide(color: AppColors.purple),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Contacto', style: textTheme.titleMedium),
          const SizedBox(height: 8),

          for (final (icon, label, text, url) in _contacts)
            Card(
              color: AppColors.surface,
              child: ListTile(
                leading: Icon(icon, color: AppColors.purple),
                title: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: AppColors.blood),
                ),
                subtitle: Text(text, style: textTheme.bodyLarge),
                trailing: const Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: AppColors.blood,
                ),
                onTap: () => _open(context, url),
              ),
            ),
        ],
      ),
    );
  }
}
