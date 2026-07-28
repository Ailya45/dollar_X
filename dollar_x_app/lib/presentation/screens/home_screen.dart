import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:dollar_x_app/presentation/constants/colors.dart';
import 'package:dollar_x_app/presentation/providers/current_rate_provider.dart';
import 'package:dollar_x_app/presentation/providers/clipboard_provider.dart';
import 'package:dollar_x_app/presentation/providers/rates_provider.dart';
import 'package:dollar_x_app/presentation/providers/ui_state_providers.dart';
import 'package:dollar_x_app/presentation/widgets/action_buttons.dart';
import 'package:dollar_x_app/presentation/widgets/calculator_sheet.dart';
import 'package:dollar_x_app/presentation/widgets/conversion_card.dart';
import 'package:dollar_x_app/presentation/widgets/date_navigation_bar.dart';
import 'package:dollar_x_app/presentation/widgets/rate_change_indicator.dart';
import 'package:dollar_x_app/presentation/widgets/rate_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pantalla principal de la aplicaci¢n.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _dollarController;
  late final TextEditingController _bsController;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _dollarController = TextEditingController(text: '1');
    _bsController = TextEditingController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _dollarController.dispose();
    _bsController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Conversi¢n y validaci¢n
  // ---------------------------------------------------------------------------

  void _convertFrom() {
    final value = _dollarController.text;
    if (value.isNotEmpty) {
      final parsed = double.tryParse(_normalizeNumber(value));
      final rate = ref.read(currentRateForCurrencyProvider);
      if (parsed != null && rate != null && rate > 0) {
        _bsController.text = (parsed * rate).toStringAsFixed(2);
      }
    }
  }

  void _convertTo() {
    final value = _bsController.text;
    if (value.isNotEmpty) {
      final parsed = double.tryParse(_normalizeNumber(value));
      final rate = ref.read(currentRateForCurrencyProvider);
      if (parsed != null && rate != null && rate > 0) {
        _dollarController.text = (parsed / rate).toStringAsFixed(2);
      }
    }
  }

  void _swapFields() {
    final temp = _dollarController.text;
    _dollarController.text = _bsController.text;
    _bsController.text = temp;
    _convertFrom();
  }

  String _normalizeNumber(String text) {
    String result = text.trim();
    if (result.contains(',') && result.contains('.')) {
      final lastComma = result.lastIndexOf(',');
      final lastDot = result.lastIndexOf('.');
      if (lastComma > lastDot) {
        result = result.replaceAll('.', '').replaceAll(',', '.');
      } else {
        result = result.replaceAll(',', '');
      }
    } else if (result.contains(',')) {
      final parts = result.split(',');
      if (parts.length == 2 && parts[1].length <= 2) {
        result = result.replaceAll(',', '.');
      } else {
        result = result.replaceAll(',', '');
      }
    }
    return result;
  }

  void _validatorsUSD(String value) {
    final hasDecimal = value.contains('.');
    final startsWithZero = value.isNotEmpty && value[0] == '0';
    final isDecimalWithLeadingZero = hasDecimal && startsWithZero;
    if ((value.length > 1) &&
        value[0].contains('0') &&
        !isDecimalWithLeadingZero) {
      _dollarController.text = _dollarController.text.replaceFirst('0', '');
    }
    if (value.isEmpty || _dollarController.text.isEmpty) {
      _bsController.text = '0.00';
      _dollarController.selection = TextSelection.fromPosition(
        TextPosition(offset: _dollarController.text.length),
      );
    }
  }

  void _validatorsBS(String value) {
    final hasDecimal = value.contains('.');
    final startsWithZero = value.isNotEmpty && value[0] == '0';
    final isDecimalWithLeadingZero = hasDecimal && startsWithZero;
    if ((value.length > 1) &&
        value[0].contains('0') &&
        !isDecimalWithLeadingZero) {
      _bsController.text = _bsController.text.replaceFirst('0', '');
    }
    if (value.isEmpty || _bsController.text.isEmpty) {
      _dollarController.text = '0.00';
      _bsController.selection = TextSelection.fromPosition(
        TextPosition(offset: _bsController.text.length),
      );
    }
  }

  String? _getDollarError() {
    final text = _dollarController.text;
    if (text.isEmpty) return null;
    if (double.tryParse(_normalizeNumber(text)) == null) return 'Valor inv lido';
    return null;
  }

  String? _getBsError() {
    final text = _bsController.text;
    if (text.isEmpty) return null;
    if (double.tryParse(_normalizeNumber(text)) == null) return 'Valor inv lido';
    return null;
  }

  // ---------------------------------------------------------------------------
  // Acciones
  // ---------------------------------------------------------------------------

  void _openCalculator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CalculatorSheet(),
    );
  }

  void _refreshRates() {
    ref.invalidate(currentRatesProvider);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final displayRatesAsync = ref.watch(displayRatesProvider);
    final currency = ref.watch(selectedCurrencyProvider);
    final rateAsync = displayRatesAsync.whenData((rates) => rates?[currency]);
    final currentRate = rateAsync.valueOrNull;

    // Recalcular conversi¢n cuando cambia la tasa
    ref.listen<double?>(currentRateForCurrencyProvider, (previous, next) {
      if (next != null && next > 0 && previous != next) {
        _convertFrom();
      }
    });

    // Animar cuando los datos se cargan
    ref.listen<AsyncValue<Map<CurrencyType, double>?>>(
      displayRatesProvider,
      (previous, next) {
        if ((previous == null || previous.isLoading) && next.hasValue) {
          _animController.forward();
        }
      },
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(rateAsync, currency),
      body: _buildBody(currentRate),
    );
  }

  PreferredSizeWidget _buildAppBar(
    AsyncValue<double?> rateAsync,
    CurrencyType currency,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 100,
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Dollar X',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          RateChip(
            rateAsync: rateAsync,
            selectedCurrency: currency,
            onRefresh: _refreshRates,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(double? currentRate) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.backgroundGradient,
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const DateNavigationBar(),
            const Spacer(flex: 1),
            Expanded(
              flex: 7,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: ConversionCard(
                    selectedCurrency: ref.watch(selectedCurrencyProvider),
                    dollarController: _dollarController,
                    bsController: _bsController,
                    dollarError: _getDollarError(),
                    bsError: _getBsError(),
                    onDollarChanged: (value) {
                      _validatorsUSD(value);
                      _convertFrom();
                    },
                    onBsChanged: (value) {
                      _validatorsBS(value);
                      _convertTo();
                    },
                    onSwap: _swapFields,
                    onCurrencyChanged: (type) {
                      ref.read(selectedCurrencyProvider.notifier).state = type;
                    },
                    onCopyDollar: (ctx) =>
                        ClipboardProvider.copy(ctx, _dollarController.text),
                    onCopyBs: (ctx) =>
                        ClipboardProvider.copy(ctx, _bsController.text),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const RateChangeIndicator(),
            const Spacer(flex: 1),
            ActionButtons(
              onCalculator: _openCalculator,
              onRefresh: _refreshRates,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
