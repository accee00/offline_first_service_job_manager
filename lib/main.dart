import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/network_bloc.dart';

void main() {
  runApp(BlocProvider(create: (_) => NetworkBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF69FF47),
          error: Color(0xFFFF3D57),
          surface: Color(0xFF1A1A1A),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'monospace',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: Color(0xFFE0E0E0),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: Color(0xFF9E9E9E),
            letterSpacing: 0.5,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _ConnectivityBanner(),

          Expanded(child: _Body()),
        ],
      ),
    );
  }
}

class _ConnectivityBanner extends StatelessWidget {
  const _ConnectivityBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        final isOnline = state.isOnline;
        final isInitial = state.status == NetworkStatus.initial;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            bottom: 12,
            left: 20,
            right: 20,
          ),
          color: isInitial
              ? const Color(0xFF1A1A1A)
              : isOnline
              ? const Color(0xFF0A2A0A)
              : const Color(0xFF2A0A0A),
          child: Row(
            children: [
              // Pulsing dot.
              _PulsingDot(isOnline: isOnline, isInitial: isInitial),
              const SizedBox(width: 12),
              Text(
                isInitial
                    ? 'CHECKING CONNECTION...'
                    : isOnline
                    ? 'CONNECTED'
                    : 'NO INTERNET',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                  color: isInitial
                      ? const Color(0xFF757575)
                      : isOnline
                      ? const Color(0xFF69FF47)
                      : const Color(0xFFFF3D57),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final bool isOnline;
  final bool isInitial;
  const _PulsingDot({required this.isOnline, required this.isInitial});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isInitial
        ? const Color(0xFF757575)
        : widget.isOnline
        ? const Color(0xFF69FF47)
        : const Color(0xFFFF3D57);

    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.6 * 255).toInt()),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NETWORK MONITOR',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'auto-sync queue · offline support',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 32),

          const _StatusCard(),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            border: Border.all(
              color: state.isOnline
                  ? Color(0xFF69FF47).withAlpha((0.3 * 255).toInt())
                  : state.isOffline
                  ? const Color(0xFFFF3D57).withAlpha((0.3 * 255).toInt())
                  : const Color(0xFF333333),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'STATUS',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 2,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    state.isOnline
                        ? Icons.wifi_rounded
                        : state.isOffline
                        ? Icons.wifi_off_rounded
                        : Icons.wifi_find_rounded,
                    color: state.isOnline
                        ? const Color(0xFF69FF47)
                        : state.isOffline
                        ? const Color(0xFFFF3D57)
                        : const Color(0xFF757575),
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.status == NetworkStatus.initial
                            ? 'Initialising...'
                            : state.isOnline
                            ? 'Internet Available'
                            : 'No Internet Access',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
