import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchthenumber/services/review_service.dart';

class FakeInAppReview implements InAppReview {
  int requestCount = 0;
  bool available = true;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<void> requestReview() async => requestCount++;

  @override
  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(ReviewService, FakeInAppReview)> build() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final fake = FakeInAppReview();
    return (ReviewService(prefs, inAppReview: fake), fake);
  }

  test('requests review at each milestone', () async {
    final (service, fake) = await build();

    for (final milestone in ReviewService.milestones) {
      await service.maybeRequestReview(milestone);
    }

    expect(fake.requestCount, ReviewService.milestones.length);
  });

  test('does not request outside milestones', () async {
    final (service, fake) = await build();

    for (final games in [1, 2, 3, 4, 6, 10, 24, 26, 99, 101]) {
      await service.maybeRequestReview(games);
    }

    expect(fake.requestCount, 0);
  });

  test('requests only once per milestone', () async {
    final (service, fake) = await build();

    await service.maybeRequestReview(5);
    await service.maybeRequestReview(5);
    await service.maybeRequestReview(5);

    expect(fake.requestCount, 1);
  });

  test('silently skips when store review is unavailable', () async {
    final (service, fake) = await build();
    fake.available = false;

    await service.maybeRequestReview(5);

    expect(fake.requestCount, 0);
  });
}
