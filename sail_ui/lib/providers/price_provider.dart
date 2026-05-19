import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sail_ui/env.dart';
import 'package:sail_ui/extensions/formatting.dart';

/// Provider that fetches and maintains the current LTC/USD exchange rate.
class PriceProvider extends ChangeNotifier {
  double? ltcusd;
  DateTime? lastUpdated;
  String? error;
  bool isFetching = false;
  Timer? _fetchTimer;

  /// URL for the CoinGecko Litecoin price API.
  static const String _tickerUrl = 'https://api.coingecko.com/api/v3/simple/price?ids=litecoin&vs_currencies=usd';

  PriceProvider() {
    // Fetch once immediately
    fetch();
    // Then start periodic fetch
    _startFetchingTimer();
  }

  void _startFetchingTimer() {
    if (Environment.isInTest) {
      return;
    }

    _fetchTimer = Timer.periodic(Duration(seconds: 10), (timer) => fetch());
  }

  /// Fetch the latest LTC/USD price.
  Future<void> fetch() async {
    if (isFetching) {
      return;
    }

    isFetching = true;
    error = null;

    try {
      final response = await http.get(Uri.parse(_tickerUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Extract USD price
        if (data.containsKey('litecoin') && data['litecoin'] is Map<String, dynamic>) {
          final usdData = data['litecoin'] as Map<String, dynamic>;

          if (usdData.containsKey('usd')) {
            final price = usdData['usd'];

            // Convert to double if needed
            if (price is num) {
              ltcusd = price.toDouble();
              lastUpdated = DateTime.now();
              error = null;
            } else {
              error = 'Invalid price format from API';
            }
          } else {
            error = 'USD price data missing "usd" field';
          }
        } else {
          error = 'USD price data not found in response';
        }
      } else {
        error = 'Failed to fetch price: HTTP ${response.statusCode}';
      }
    } catch (e) {
      error = 'Error fetching price: $e';
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  /// Format the LTC price as a USD string
  String get formattedPrice {
    if (ltcusd == null) {
      return 'Loading...';
    }

    return '\$${formatWithThousandSpacers(ltcusd!.round())}';
  }

  /// Get the age of the last price update
  String get priceAge {
    if (lastUpdated == null) {
      return 'Never updated';
    }

    final now = DateTime.now();
    final difference = now.difference(lastUpdated!);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }

  /// Convert LTC amount to USD.
  double? ltcToUsd(double ltcAmount) {
    if (ltcusd == null) {
      return null;
    }
    return ltcAmount * ltcusd!;
  }

  /// Convert USD amount to LTC.
  double? usdToLtc(double usdAmount) {
    if (ltcusd == null || ltcusd == 0) {
      return null;
    }
    return usdAmount / ltcusd!;
  }

  @override
  void dispose() {
    _fetchTimer?.cancel();
    super.dispose();
  }
}
