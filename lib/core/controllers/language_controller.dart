import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/site_settings_properties_model.dart';
import '../../data/repositories/site_settings_properties_repository.dart';
import '../../modules/category/controller/category_controller.dart';
import '../../modules/compare/controller/compare_controller.dart';
import '../config/app_config.dart';
import '../services/language_service.dart';
import '../utils/locale_mapper.dart';

class LanguageController extends GetxController {
  final SiteSettingsPropertiesRepository repo;
  LanguageController(this.repo);

  final box = GetStorage();

  final languages = <LanguageModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final selectedApiCode = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadPersistedLang();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    isLoading.value = true;
    error.value = null;

    try {
      final res = await repo.fetchSiteProperties();
      languages.assignAll(res.languages);

      if ((selectedApiCode.value ?? '').isEmpty && res.languages.isNotEmpty) {
        final defaultCode = (res.defaultLanguage?.code ?? '').trim();

        final fallback = defaultCode.isNotEmpty
            ? res.languages.firstWhere(
                (l) => l.code == defaultCode,
                orElse: () => res.languages.first,
              )
            : res.languages.firstWhere(
                (l) => l.code == 'en',
                orElse: () => res.languages.first,
              );

        await setLanguage(fallback.code, persist: true);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setLanguage(String apiCode, {bool persist = true}) async {
    selectedApiCode.value = apiCode;

    if (persist) {
      box.write(AppConfig.kLangCode, apiCode);
    }

    await LanguageService.load(apiCode);

    final locale = LocaleMapper.fromApiCode(apiCode);
    Get.updateLocale(locale);

    if (Get.isRegistered<CompareController>()) {
      await Get.find<CompareController>().refreshAll();
    }

    if (Get.isRegistered<CategoryController>()) {
      Get.find<CategoryController>().fetchCategories();
    }
  }

  void _loadPersistedLang() {
    final saved = box.read<String>(AppConfig.kLangCode);
    if (saved != null && saved.isNotEmpty) {
      selectedApiCode.value = saved;
      LanguageService.load(saved);
    }
  }
}
