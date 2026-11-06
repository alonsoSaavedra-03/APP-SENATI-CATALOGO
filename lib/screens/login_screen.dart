import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/auth_json_service.dart';
import '../theme/app_theme.dart';
import '../widgets/visor_json_dialog.dart';

/// Pantalla de Inicio de Sesión y Registro previa al catálogo SENATI.
/// Guarda los datos del usuario y la sesión activa en un archivo JSON antes de ingresar.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _esRegistro = false;
  bool _ocultarPassword = true;
  bool _guardando = false;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    AuthJsonService.instance.inicializar();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _cambiarModo(bool registro) {
    if (_esRegistro == registro) return;
    setState(() {
      _esRegistro = registro;
      _mensajeError = null;
      _formKey.currentState?.reset();
    });
  }

  void _autocompletarDemo() {
    setState(() {
      _esRegistro = false;
      _mensajeError = null;
      _correoCtrl.text = AuthJsonService.usuarioDemo.correo;
      _passwordCtrl.text = AuthJsonService.usuarioDemo.password;
    });
  }

  String? _validarNombre(String? v) {
    if (!_esRegistro) return null;
    if (v == null || v.trim().isEmpty) return 'Ingresa tu nombre completo';
    if (v.trim().length < 3) return 'El nombre debe tener al menos 3 caracteres';
    return null;
  }

  String? _validarCorreoOUsuario(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Ingresa tu correo o usuario';
    }
    if (_esRegistro && v.trim().length < 3) {
      return 'Ingresa un correo o usuario válido';
    }
    return null;
  }

  String? _validarPassword(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Ingresa tu contraseña';
    }
    if (v.trim().length < 4) {
      return 'La contraseña debe tener al menos 4 caracteres';
    }
    return null;
  }

  Future<void> _enviar() async {
    setState(() => _mensajeError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final ResultadoAuth resultado;
    if (_esRegistro) {
      resultado = await AuthJsonService.instance.registrarUsuario(
        nombre: _nombreCtrl.text,
        correo: _correoCtrl.text,
        password: _passwordCtrl.text,
      );
    } else {
      resultado = await AuthJsonService.instance.iniciarSesion(
        correoOUsuario: _correoCtrl.text,
        password: _passwordCtrl.text,
      );
    }

    if (!mounted) return;
    setState(() => _guardando = false);

    if (!resultado.exito) {
      setState(() => _mensajeError = resultado.mensaje);
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.disponible,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(resultado.mensaje)),
            ],
          ),
        ),
      );

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    final esEscritorio = ancho >= 860;

    return Scaffold(
      backgroundColor: AppTheme.fondoGeneral,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: esEscritorio ? 32 : 16,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: esEscritorio ? 940 : 460),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.fondoTarjeta,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borde),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: esEscritorio
                    ? IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: _PanelInstitucional(),
                            ),
                            Expanded(
                              flex: 6,
                              child: _construirFormulario(context),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _EncabezadoMovil(),
                          _construirFormulario(context),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirFormulario(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 26),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selector Iniciar sesión / Registrarse
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.fondoGeneral,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borde),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _TabBotonModo(
                      key: const Key('tabLogin'),
                      texto: 'Iniciar sesión',
                      icono: Icons.login_rounded,
                      activo: !_esRegistro,
                      onTap: () => _cambiarModo(false),
                    ),
                  ),
                  Expanded(
                    child: _TabBotonModo(
                      key: const Key('tabRegistro'),
                      texto: 'Registrarse',
                      icono: Icons.person_add_alt_1_rounded,
                      activo: _esRegistro,
                      onTap: () => _cambiarModo(true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              _esRegistro
                  ? 'Crear cuenta en JSON'
                  : 'Acceso al Catálogo SENATI',
              style: const TextStyle(
                color: AppTheme.textoPrincipal,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _esRegistro
                  ? 'Tus datos se guardarán en usuarios_sesion.json antes de entrar al catálogo.'
                  : 'Ingresa tus credenciales para registrar tu sesión en JSON y acceder al catálogo.',
              style: const TextStyle(
                color: AppTheme.textoSecundario,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),

            if (_mensajeError != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.error.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppTheme.error,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _mensajeError!,
                        style: const TextStyle(
                          color: AppTheme.error,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            if (_esRegistro) ...[
              TextFormField(
                key: const Key('campoNombreLogin'),
                controller: _nombreCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo *',
                  hintText: 'Ej. Juan Pérez',
                  prefixIcon: Icon(Icons.badge_outlined, size: 19),
                ),
                validator: _validarNombre,
              ),
              const SizedBox(height: 12),
            ],

            TextFormField(
              key: const Key('campoCorreoLogin'),
              controller: _correoCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo institucional o usuario *',
                hintText: 'admin@senati.pe',
                prefixIcon: Icon(Icons.alternate_email_rounded, size: 19),
              ),
              validator: _validarCorreoOUsuario,
            ),
            const SizedBox(height: 12),

            TextFormField(
              key: const Key('campoPasswordLogin'),
              controller: _passwordCtrl,
              obscureText: _ocultarPassword,
              onFieldSubmitted: (_) => _enviar(),
              decoration: InputDecoration(
                labelText: 'Contraseña *',
                hintText: '••••••',
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 19),
                suffixIcon: IconButton(
                  tooltip: _ocultarPassword
                      ? 'Mostrar contraseña'
                      : 'Ocultar contraseña',
                  onPressed: () =>
                      setState(() => _ocultarPassword = !_ocultarPassword),
                  icon: Icon(
                    _ocultarPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 19,
                  ),
                ),
              ),
              validator: _validarPassword,
            ),
            const SizedBox(height: 18),

            FilledButton.icon(
              key: const Key('btnSubmitLogin'),
              onPressed: _guardando ? null : _enviar,
              icon: _guardando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      _esRegistro
                          ? Icons.save_alt_rounded
                          : Icons.login_rounded,
                      size: 18,
                    ),
              label: Text(
                _esRegistro
                    ? 'Guardar en JSON e Ingresar'
                    : 'Iniciar sesión y guardar JSON',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de acceso rápido con cuenta demo y visor JSON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.fondoGeneral,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borde),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 16,
                        color: AppTheme.primario,
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Cuenta demo precargada en JSON:',
                          style: TextStyle(
                            color: AppTheme.textoPrincipal,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        key: const Key('btnAutocompletarDemo'),
                        onPressed: _autocompletarDemo,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        icon: const Icon(Icons.bolt_rounded, size: 15),
                        label: const Text(
                          'Autocompletar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Usuario: admin@senati.pe   ·   Clave: 123456',
                    style: TextStyle(
                      color: AppTheme.textoSecundario,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const Key('btnVerJsonLogin'),
                      onPressed: () => VisorJsonDialog.mostrar(context),
                      icon: const Icon(Icons.data_object_rounded, size: 16),
                      label: const Text('Ver archivo JSON guardado'),
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBotonModo extends StatelessWidget {
  final String texto;
  final IconData icono;
  final bool activo;
  final VoidCallback onTap;

  const _TabBotonModo({
    super.key,
    required this.texto,
    required this.icono,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: activo ? AppTheme.primario : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icono,
                size: 16,
                color: activo ? Colors.white : AppTheme.textoSecundario,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  texto,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: activo ? Colors.white : AppTheme.textoSecundario,
                    fontSize: 13,
                    fontWeight: activo ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelInstitucional extends StatelessWidget {
  const _PanelInstitucional();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primario, Color(0xFF1D4B87)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.acento,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PORTAL DE ACCESO SENATI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Catálogo de Hardware y Periféricos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Autenticación con respaldo automático en formato JSON para control de usuarios y sesiones.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.storage_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Persistencia JSON activa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Cada registro e inicio de sesión se serializa en usuarios_sesion.json antes de ingresar.',
                  style: TextStyle(
                    color: Color(0xFFD0DAE8),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EncabezadoMovil extends StatelessWidget {
  const _EncabezadoMovil();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primario, Color(0xFF1D4B87)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.acento,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.developer_board_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catálogo SENATI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Inicio de sesión con respaldo en JSON',
                  style: TextStyle(
                    color: Color(0xFFD0DAE8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
