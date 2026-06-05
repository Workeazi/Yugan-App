import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kartly_e_commerce/core/constants/app_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/services/api_service.dart';
import '../../../data/repositories/site_settings_properties_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../model/wallet_payment_methods_model.dart';

class WalletRechargeController extends GetxController {
  final WalletRepository repo;
  WalletRechargeController({required this.repo});

  final RxBool isLoadingMethods = false.obs;
  final RxString methodsError = ''.obs;
  final Rx<WalletPaymentMethods?> methods = Rx<WalletPaymentMethods?>(null);

  final RxInt currentTabIndex = 0.obs;

  final RxInt selectedOfflineMethodId = RxInt(0);
  final RxString rechargeAmount = ''.obs;
  final RxString transactionId = ''.obs;
  final RxInt currencyId = RxInt(1);
  final Rx<File?> transactionProof = Rx<File?>(null);

  final RxBool isSubmitting = false.obs;
  final RxMap<String, String?> fieldErrors = <String, String?>{}.obs;

  final RxnDouble minAmount = RxnDouble(null);
  final RxnDouble maxAmount = RxnDouble(null);
  final RxBool isLimitsLoaded = false.obs;

  final RxInt selectedOnlineMethodId = 0.obs;
  final RxString onlineAmount = ''.obs;
  final RxBool isGeneratingLink = false.obs;
  final RxMap<String, String?> onlineFieldErrors = <String, String?>{}.obs;

  late final Razorpay _razorpay;
  int? _pendingWalletRechargeId;
  String? _pendingRazorpayPi;

  @override
  void onInit() {
    super.onInit();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorpaySuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorpayError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorpayExternalWallet);

    loadMethods();
    _loadLimitsFromSiteSettings();
  }

  Future<void> loadMethods() async {
    isLoadingMethods.value = true;
    methodsError.value = '';
    methods.value = null;
    selectedOnlineMethodId.value = 0;
    selectedOfflineMethodId.value = 0;

    try {
      final res = await repo.fetchPaymentMethods();

      final cleanOnline = res.onlineMethods
          .where((e) => e.id > 0 && e.name.trim().isNotEmpty)
          .toList();

      final cleanOffline = res.offlineMethods
          .where((e) => e.id > 0 && e.name.trim().isNotEmpty)
          .toList();

      methods.value = WalletPaymentMethods(
        onlineMethods: cleanOnline,
        offlineMethods: cleanOffline,
      );

      if (cleanOffline.isNotEmpty) {
        selectedOfflineMethodId.value = cleanOffline.first.id;
      } else {
        selectedOfflineMethodId.value = 0;
      }

      if (cleanOnline.isNotEmpty) {
        selectedOnlineMethodId.value = cleanOnline.first.id;
      } else {
        selectedOnlineMethodId.value = 0;
      }
    } catch (e) {
      methods.value = WalletPaymentMethods(
        onlineMethods: [],
        offlineMethods: [],
      );
      selectedOnlineMethodId.value = 0;
      selectedOfflineMethodId.value = 0;
      methodsError.value = e.toString();
    } finally {
      isLoadingMethods.value = false;
    }
  }

  void setTab(int index) => currentTabIndex.value = index;

  void pickOfflineMethod(int id) => selectedOfflineMethodId.value = id;
  void setAmount(String v) => rechargeAmount.value = v;
  void setTxnId(String v) => transactionId.value = v;
  void setCurrency(int v) => currencyId.value = v;
  void setProof(File? f) => transactionProof.value = f;

  void pickOnlineMethod(int id) => selectedOnlineMethodId.value = id;
  void setOnlineAmount(String v) => onlineAmount.value = v;

  bool get isRazorpaySelected {
    final id = selectedOnlineMethodId.value;
    if (id <= 0) return false;

    final list = methods.value?.onlineMethods ?? [];
    final method = list.firstWhereOrNull((e) => e.id == id);
    if (method == null) return false;

    final text = [method.name].join(' ').trim().toLowerCase();

    return text.contains('razorpay') ||
        text.contains('razor pay') ||
        text.contains('razor_pay') ||
        text.contains('razor-pay');
  }

  Future<bool> submitOffline() async {
    fieldErrors.clear();

    final amountRaw = rechargeAmount.value.trim();
    final amountNum = double.tryParse(amountRaw);
    if (amountNum == null) {
      fieldErrors['recharge_amount'] = 'Enter a valid number'.tr;
      _showSnack('Validation'.tr, 'Enter a valid number'.tr);
      return false;
    }

    if (minAmount.value != null && amountNum < (minAmount.value!)) {
      fieldErrors['recharge_amount'] =
          '${'Minimum'.tr} ${minAmount.value!.toStringAsFixed(2)} ${'in selected currency'.tr}.';
      _showSnack('Validation'.tr, fieldErrors['recharge_amount'] ?? '');
      return false;
    }

    if (maxAmount.value != null && amountNum > (maxAmount.value!)) {
      fieldErrors['recharge_amount'] =
          '${'Maximum'.tr} ${maxAmount.value!.toStringAsFixed(2)} ${'in selected currency'.tr}.';
      _showSnack('Validation'.tr, fieldErrors['recharge_amount'] ?? '');
      return false;
    }

    if (transactionId.value.trim().isEmpty) {
      fieldErrors['transaction_id'] = 'Transaction id is required'.tr;
      _showSnack('Validation'.tr, 'Transaction id is required'.tr);
      return false;
    }
    if (selectedOfflineMethodId.value <= 0) {
      fieldErrors['payment_method'] = 'Select a payment method'.tr;
      _showSnack('Validation'.tr, 'Select a payment method'.tr);
      return false;
    }

    isSubmitting.value = true;
    try {
      final res = await repo.submitOfflineRecharge(
        rechargeType: 2,
        rechargeAmount: amountRaw,
        transactionId: transactionId.value.trim(),
        paymentMethodId: selectedOfflineMethodId.value,
        currencyId: currencyId.value,
        transactionImageFile: transactionProof.value,
      );

      final ok =
          (res['success'] == true) ||
          (res['success']?.toString().toLowerCase() == 'true');

      if (ok) {
        _showSnack(
          'Success'.tr,
          'Recharge submitted successfully'.tr,
          success: true,
        );
      }
      return ok;
    } on ApiValidationError catch (ve) {
      fieldErrors.addAll(
        ve.fieldErrors.map(
          (k, v) => MapEntry(k, (v.isNotEmpty ? v.first : null)),
        ),
      );

      final serverMsg = (ve.message.isNotEmpty)
          ? ve.message
          : (ve.fieldErrors['recharge_amount']?.first ??
                ve.fieldErrors.values
                    .firstWhere((l) => l.isNotEmpty, orElse: () => [''])
                    .first);
      if (serverMsg.isNotEmpty) _showSnack('Validation'.tr, serverMsg);
      return false;
    } catch (e) {
      _showSnack('Error'.tr, _extractServerMessage(e));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String?> generateOnlineLink() async {
    onlineFieldErrors.clear();

    final amountRaw = onlineAmount.value.trim();
    final amountNum = double.tryParse(amountRaw);
    if (amountNum == null) {
      onlineFieldErrors['recharge_amount'] = 'Enter a valid number'.tr;
      _showSnack('Validation'.tr, 'Enter a valid number'.tr);
      return null;
    }

    if (minAmount.value != null && amountNum < (minAmount.value!)) {
      onlineFieldErrors['recharge_amount'] =
          '${'Minimum'.tr} ${minAmount.value!.toStringAsFixed(2)} ${'in selected currency'.tr}.';
      _showSnack('Validation'.tr, onlineFieldErrors['recharge_amount'] ?? '');
      return null;
    }

    if (maxAmount.value != null && amountNum > (maxAmount.value!)) {
      onlineFieldErrors['recharge_amount'] =
          '${'Maximum'.tr} ${maxAmount.value!.toStringAsFixed(2)} ${'in selected currency'.tr}.';
      _showSnack('Validation'.tr, onlineFieldErrors['recharge_amount'] ?? '');
      return null;
    }

    if (selectedOnlineMethodId.value <= 0) {
      onlineFieldErrors['payment_method'] = 'Select a payment method'.tr;
      _showSnack('Validation'.tr, 'Select a payment method'.tr);
      return null;
    }

    if (isRazorpaySelected) {
      await startRazorpayRecharge();
      return null;
    }

    isGeneratingLink.value = true;
    try {
      final rawUrl = await repo.generateOnlineRechargeLink(
        rechargeType: 1,
        rechargeAmount: amountRaw,
        paymentMethodId: selectedOnlineMethodId.value,
        currencyId: currencyId.value.toInt(),
      );

      if (rawUrl.isNotEmpty) {
        _showSnack('Success'.tr, 'Payment link generated'.tr, success: true);
        return rawUrl;
      } else {
        _showSnack('Error'.tr, 'Missing url in response'.tr);
        return null;
      }
    } on ApiValidationError catch (ve) {
      onlineFieldErrors.addAll(
        ve.fieldErrors.map(
          (k, v) => MapEntry(k, (v.isNotEmpty ? v.first : null)),
        ),
      );

      final serverMsg = (ve.message.isNotEmpty)
          ? ve.message
          : (ve.fieldErrors['recharge_amount']?.first ??
                ve.fieldErrors.values
                    .firstWhere((l) => l.isNotEmpty, orElse: () => [''])
                    .first);

      if (serverMsg.isNotEmpty) _showSnack('Validation'.tr, serverMsg);
      return null;
    } catch (e) {
      _showSnack('Error'.tr, _extractServerMessage(e));
      return null;
    } finally {
      isGeneratingLink.value = false;
    }
  }

  Future<void> startRazorpayRecharge() async {
    final amountRaw = onlineAmount.value.trim();

    isGeneratingLink.value = true;
    try {
      final resp = await repo.createOnlineRecharge(
        rechargeType: 1,
        rechargeAmount: amountRaw,
        paymentMethodId: selectedOnlineMethodId.value,
        currencyId: currencyId.value.toInt(),
      );

      final ok =
          resp['success'] == true ||
          resp['success']?.toString().toLowerCase() == 'true';

      if (!ok) {
        _showSnack(
          'Error'.tr,
          resp['message']?.toString() ?? 'Could not start payment'.tr,
        );
        return;
      }

      await _openRazorpayCheckout(resp);
    } on ApiValidationError catch (ve) {
      onlineFieldErrors.addAll(
        ve.fieldErrors.map(
          (k, v) => MapEntry(k, (v.isNotEmpty ? v.first : null)),
        ),
      );

      final serverMsg = (ve.message.isNotEmpty)
          ? ve.message
          : (ve.fieldErrors['recharge_amount']?.first ??
                ve.fieldErrors.values
                    .firstWhere((l) => l.isNotEmpty, orElse: () => [''])
                    .first);

      if (serverMsg.isNotEmpty) _showSnack('Validation'.tr, serverMsg);
    } catch (e) {
      _showSnack('Error'.tr, _extractServerMessage(e));
    } finally {
      isGeneratingLink.value = false;
    }
  }

  Map<String, dynamic>? _extractRazorpayPayload(Map<String, dynamic> resp) {
    final candidates = <dynamic>[
      resp['config'],
      resp['razorpay'],
      resp['razorpay_data'],
      resp['payment_data'],
      resp['payment'],
      resp['data'],
      resp,
    ];

    for (final item in candidates) {
      if (item is Map<String, dynamic>) return item;
      if (item is Map) return Map<String, dynamic>.from(item);
    }

    return null;
  }

  String? _extractRazorpayKey(Map<String, dynamic> payload) {
    final raw = payload['key_id'] ?? payload['key'] ?? payload['razorpay_key'];
    final value = raw?.toString().trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? _extractRazorpayPi(Map<String, dynamic> payload) {
    final raw =
        payload['pi'] ??
        payload['payment_intent'] ??
        payload['payment_identifier'];
    final value = raw?.toString().trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? _extractRazorpayOrderId(Map<String, dynamic> payload) {
    final raw =
        payload['order_id'] ??
        payload['razorpay_order_id'] ??
        payload['gateway_order_id'];
    final value = raw?.toString().trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  int? _extractRazorpayAmount(Map<String, dynamic> payload) {
    final raw =
        payload['total_payable_amount'] ??
        payload['amount_in_smallest_unit'] ??
        payload['amount_in_paisa'] ??
        payload['amount_in_subunits'] ??
        payload['amount'] ??
        payload['razorpay_amount'];

    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw.trim());

    return null;
  }

  String _extractRazorpayCurrency(Map<String, dynamic> payload) {
    final raw = payload['currency']?.toString().trim();
    if (raw == null || raw.isEmpty) return 'INR';
    return raw;
  }

  int? _extractWalletRechargeId(Map<String, dynamic> resp) {
    final direct =
        resp['wallet_recharge_id'] ??
        resp['recharge_id'] ??
        resp['transaction_id'] ??
        resp['order_id'];

    if (direct is int) return direct;
    if (direct is String) return int.tryParse(direct);

    final data = resp['data'];
    if (data is Map) {
      final raw =
          data['wallet_recharge_id'] ??
          data['recharge_id'] ??
          data['transaction_id'] ??
          data['order_id'];

      if (raw is int) return raw;
      if (raw is String) return int.tryParse(raw);
    }

    return null;
  }

  Future<void> _openRazorpayCheckout(Map<String, dynamic> resp) async {
    final payload = _extractRazorpayPayload(resp);

    if (payload == null) {
      _showSnack(
        'Payment'.tr,
        'Razorpay config missing from server response'.tr,
      );
      return;
    }

    final key = _extractRazorpayKey(payload);
    final pi = _extractRazorpayPi(payload);
    final razorpayOrderId = _extractRazorpayOrderId(payload);
    final amount = _extractRazorpayAmount(payload);
    final currency = _extractRazorpayCurrency(payload);
    final walletRechargeId = _extractWalletRechargeId(resp);

    if (key == null || pi == null || amount == null) {
      _showSnack('Payment'.tr, 'Incomplete Razorpay config from server'.tr);
      return;
    }

    _pendingWalletRechargeId = walletRechargeId;
    _pendingRazorpayPi = pi;

    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo.appName.trim().isNotEmpty
        ? packageInfo.appName
        : 'E-Commerce';

    final options = <String, dynamic>{
      'key': key,
      'amount': amount,
      'currency': currency,
      'name': appName,
      'description': walletRechargeId != null
          ? 'Wallet Recharge #$walletRechargeId'
          : 'Wallet Recharge',
      'save': 0,
      'remember_customer': false,
      'prefill': {'contact': '', 'email': '', 'name': ''},
      'notes': {
        'type': 'wallet_recharge',
        'wallet_recharge_id': '${walletRechargeId ?? ''}',
        'pi': pi,
      },
    };

    if (razorpayOrderId != null && razorpayOrderId.isNotEmpty) {
      options['order_id'] = razorpayOrderId;
    }

    try {
      _razorpay.open(options);
    } catch (e) {
      _showSnack('Payment'.tr, 'Could not open Razorpay checkout'.tr);
    }
  }

  void _handleRazorpaySuccess(PaymentSuccessResponse response) {
    _verifyWalletRazorpayPayment(response);
  }

  Future<void> _verifyWalletRazorpayPayment(
    PaymentSuccessResponse response,
  ) async {
    final pi = _pendingRazorpayPi;

    if (pi == null || pi.isEmpty) {
      _showSnack('Payment'.tr, 'Missing payment verification context'.tr);
      return;
    }

    isGeneratingLink.value = true;

    try {
      final body = <String, dynamic>{
        'gateway': 'razorpay',
        'pi': pi,
        'payment_id': response.paymentId,
        'razorpay_payment_id': response.paymentId,
        'gateway_order_id': response.orderId,
        'razorpay_order_id': response.orderId,
        'signature': response.signature,
        'razorpay_signature': response.signature,
      };

      if (_pendingWalletRechargeId != null) {
        body['order_id'] = _pendingWalletRechargeId;
        body['wallet_recharge_id'] = _pendingWalletRechargeId;
      }

      final verifyResp = await repo.verifyQueuedPayment(body: body);

      final verifySuccess =
          verifyResp['success'] == true ||
          verifyResp['success']?.toString().toLowerCase() == 'true';

      final paymentStatus =
          verifyResp['payment_status']?.toString().toUpperCase() ?? '';

      if (verifySuccess &&
          (paymentStatus == 'SUCCESS' ||
              paymentStatus == 'PAID' ||
              paymentStatus.isEmpty)) {
        onlineAmount.value = '';
        onlineFieldErrors.clear();
        _pendingWalletRechargeId = null;
        _pendingRazorpayPi = null;

        await _closeOnlineSheetIfOpen();

        _showSnack('Success'.tr, 'Money added successfully'.tr, success: true);

        return;
      }

      _showSnack('Payment'.tr, 'Payment verification failed'.tr);
    } catch (e) {
      _showSnack('Payment'.tr, 'Could not verify Razorpay payment'.tr);
    } finally {
      isGeneratingLink.value = false;
    }
  }

  void _handleRazorpayError(PaymentFailureResponse response) {
    String errorMessage = 'Something went wrong'.tr;

    switch (response.code) {
      case Razorpay.PAYMENT_CANCELLED:
        errorMessage = 'Payment was cancelled by the user';
        break;
      case Razorpay.NETWORK_ERROR:
        errorMessage = 'Network connection issue. Please check your internet';
        break;
      case Razorpay.INVALID_OPTIONS:
        errorMessage = 'Invalid payment details. Contact support';
        break;
      default:
        errorMessage = 'Payment failed';
        break;
    }

    _showSnack('Payment Status'.tr, errorMessage);
  }

  void _handleRazorpayExternalWallet(ExternalWalletResponse response) {}

  String? _firstFieldErrorMsg(dynamic errors) {
    if (errors is Map) {
      for (final v in errors.values) {
        if (v is List &&
            v.isNotEmpty &&
            v.first is String &&
            (v.first as String).trim().isNotEmpty) {
          return (v.first as String).trim();
        }
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
    }
    return null;
  }

  String _extractServerMessage(dynamic err) {
    if (err is ApiValidationError) {
      String msg = err.message.isNotEmpty
          ? err.message
          : (_firstFieldErrorMsg(err.fieldErrors) ?? 'Validation error'.tr);
      return _unescapeUnicode(msg);
    }

    if (err is ApiHttpException) {
      try {
        final decoded = json.decode(err.body);
        if (decoded is Map) {
          final m = decoded['message'];
          if (m is String && m.trim().isNotEmpty) {
            return _unescapeUnicode(m.trim());
          }
          final f = _firstFieldErrorMsg(decoded['errors']);
          if (f != null) return _unescapeUnicode(f);
        }
      } catch (_) {}

      return _friendlyErrorMessage(err.body);
    }

    final raw = err.toString();

    try {
      final decoded = json.decode(raw);
      if (decoded is Map) {
        final m = decoded['message'];
        if (m is String && m.trim().isNotEmpty) {
          return _unescapeUnicode(m.trim());
        }
        final f = _firstFieldErrorMsg(decoded['errors']);
        if (f != null) return _unescapeUnicode(f);
      }
    } catch (_) {}

    final match = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(raw);
    if (match != null && match.groupCount >= 1) {
      return _unescapeUnicode(match.group(1)!.trim());
    }

    return _friendlyErrorMessage(raw);
  }

  String _friendlyErrorMessage(Object error) {
    final text = error.toString().toLowerCase();

    if (text.contains('timeout') ||
        text.contains('timed out') ||
        text.contains('upstream')) {
      return 'Server is taking too long to respond. Please try again.';
    }

    if (text.contains('socket') || text.contains('network')) {
      return 'Please check your internet connection.';
    }

    if (text.contains('500') || text.contains('server')) {
      return 'Server error. Please try again later.';
    }

    return _unescapeUnicode(error.toString());
  }

  String _unescapeUnicode(String s) {
    try {
      final wrapped =
          '"${s.replaceAll(r'\"', r'\\\"').replaceAll('"', r'\"')}"';
      final decoded = json.decode(wrapped);
      if (decoded is String) return decoded;
    } catch (_) {}
    return s.replaceAllMapped(RegExp(r'\\u([0-9a-fA-F]{4})'), (m) {
      final code = int.parse(m.group(1)!, radix: 16);
      return String.fromCharCode(code);
    });
  }

  void _showSnack(String title, String message, {bool success = false}) {
    if (message.trim().isEmpty) return;

    final context = Get.context;
    if (context == null) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: success ? AppColors.primaryColor : AppColors.redColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(message, style: const TextStyle(color: AppColors.whiteColor)),
          ],
        ),
      ),
    );
  }

  Future<void> _loadLimitsFromSiteSettings() async {
    if (isLimitsLoaded.value) return;
    try {
      final settingsRepo = SiteSettingsPropertiesRepository(ApiService());
      final settings = await settingsRepo.fetchSiteSettingsMap();

      double? toDouble(dynamic v) {
        if (v == null) return null;
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString());
      }

      minAmount.value = toDouble(settings['minimum_recharge_amount']);
      maxAmount.value = toDouble(settings['maximum_recharge_amount']);

      isLimitsLoaded.value = true;
    } catch (_) {
      isLimitsLoaded.value = true;
    }
  }

  Future<void> _closeOnlineSheetIfOpen() async {
    final context = Get.context;
    if (context == null) return;

    if (Get.isBottomSheetOpen == true) {
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }
  }

  void showPublicSnack(String title, String message, {bool success = false}) {
    _showSnack(title, message, success: success);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
