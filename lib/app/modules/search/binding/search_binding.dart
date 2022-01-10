import 'package:get/get.dart';
import 'package:social_media_application/app/modules/search/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(
          () => SearchController(),
    );
  }
}