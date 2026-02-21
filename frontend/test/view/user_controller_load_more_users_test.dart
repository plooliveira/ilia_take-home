import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/pagination_model.dart';
import 'package:frontend/data/user_model.dart';
import 'package:frontend/data/user_repository.dart';
import 'package:frontend/shared/result.dart';
import 'package:frontend/view/user/list/user_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('UserCtrl.loadMoreUsers', () {
    late MockUserRepository userRepository;
    late UserCtrl ctrl;

    setUp(() {
      userRepository = MockUserRepository();
      ctrl = UserCtrl(userRepository: userRepository);
    });

    tearDown(() {
      ctrl.dispose();
    });

    test('does not call repository when hasMorePages is false', () async {
      ctrl.users.update((state) {
        state.hasMorePages = false;
        state.currentPage = 2;
      });

      await ctrl.loadMoreUsers();

      verifyNever(() => userRepository.getAllUsers(page: any(named: 'page')));
    });

    test('does not call repository when isLoadingMore is true', () async {
      ctrl.users.update((state) {
        state.hasMorePages = true;
        state.isLoadingMore = true;
        state.currentPage = 2;
      });

      await ctrl.loadMoreUsers();

      verifyNever(() => userRepository.getAllUsers(page: any(named: 'page')));
    });

    test('appends users and updates pagination flags on success', () async {
      final existing = User(name: 'Existing', email: 'existing@email.com');
      final incoming = User(name: 'Incoming', email: 'incoming@email.com');

      ctrl.users.update((state) {
        state.users = [existing];
        state.currentPage = 2;
        state.hasMorePages = true;
        state.isLoadingMore = false;
        state.hasError = false;
        state.error = '';
      });

      when(() => userRepository.getAllUsers(page: 2)).thenAnswer(
        (_) async => Ok(
          PaginatedUsers(
            data: [incoming],
            meta: PaginationMeta(total: 2, page: 2, lastPage: 3),
          ),
        ),
      );

      await ctrl.loadMoreUsers();

      expect(ctrl.users.value.isLoadingMore, isFalse);
      expect(ctrl.users.value.hasError, isFalse);
      expect(ctrl.users.value.users, hasLength(2));
      expect(ctrl.users.value.users.last.email, 'incoming@email.com');
      expect(ctrl.users.value.currentPage, 3);
      expect(ctrl.users.value.hasMorePages, isTrue);

      verify(() => userRepository.getAllUsers(page: 2)).called(1);
      verifyNoMoreInteractions(userRepository);
    });

    test('sets error flags and resets isLoadingMore on error', () async {
      ctrl.users.update((state) {
        state.users = [];
        state.currentPage = 2;
        state.hasMorePages = true;
        state.isLoadingMore = false;
        state.hasError = false;
        state.error = '';
      });

      when(
        () => userRepository.getAllUsers(page: 2),
      ).thenAnswer((_) async => const Err('boom'));

      await ctrl.loadMoreUsers();

      expect(ctrl.users.value.isLoadingMore, isFalse);
      expect(ctrl.users.value.hasError, isTrue);
      expect(ctrl.users.value.error, 'boom');

      verify(() => userRepository.getAllUsers(page: 2)).called(1);
      verifyNoMoreInteractions(userRepository);
    });
  });
}
