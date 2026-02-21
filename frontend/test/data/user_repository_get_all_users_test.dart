import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/api/http_client.dart';
import 'package:frontend/data/pagination_model.dart';
import 'package:frontend/data/user_repository.dart';
import 'package:frontend/shared/result.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('UserRepository.getAllUsers', () {
    late MockApiClient apiClient;
    late UserRepository repository;

    setUp(() {
      apiClient = MockApiClient();
      repository = UserRepository(apiClient: apiClient);
    });

    test(
      'returns Ok(PaginatedUsers) when ApiClient returns valid json',
      () async {
        final json = {
          'data': [
            {'name': 'Luke SkyWalker', 'email': 'luke@skywalker.com'},
          ],
          'meta': {'total': 1, 'page': 1, 'lastPage': 1},
        };

        when(() => apiClient.get('users?page=1')).thenAnswer((_) async => json);

        final result = await repository.getAllUsers(page: 1);

        switch (result) {
          case Ok(value: final PaginatedUsers paginated):
            expect(paginated.data, hasLength(1));
            expect(paginated.data.first.name, 'Luke SkyWalker');
            expect(paginated.data.first.email, 'luke@skywalker.com');
            expect(paginated.meta.page, 1);
            expect(paginated.meta.lastPage, 1);
            expect(paginated.meta.total, 1);
          case Err(error: final error):
            fail('Expected Ok, got Err: $error');
        }

        verify(() => apiClient.get('users?page=1')).called(1);
        verifyNoMoreInteractions(apiClient);
      },
    );

    test(
      'returns Err(message) when ApiClient throws NetworkException',
      () async {
        when(() => apiClient.get('users?page=1')).thenThrow(
          NetworkException(
            'Sem conexão com a internet (SocketException)',
            0,
            [],
          ),
        );

        final result = await repository.getAllUsers(page: 1);

        switch (result) {
          case Ok():
            fail('Expected Err, got Ok');
          case Err(error: final error):
            expect(error, 'Sem conexão com a internet (SocketException)');
        }

        verify(() => apiClient.get('users?page=1')).called(1);
        verifyNoMoreInteractions(apiClient);
      },
    );
  });

  group('UserRepository.createUser', () {
    late MockApiClient apiClient;
    late UserRepository repository;

    setUp(() {
      apiClient = MockApiClient();
      repository = UserRepository(apiClient: apiClient);
    });

    test(
      'returns Err(listMessages joined by \"\\n\") when NetworkException has listMessages',
      () async {
        when(
          () => apiClient.post('users', any(that: isA<Map<String, dynamic>>())),
        ).thenThrow(
          NetworkException('Invalid input', 422, [
            'Email já existe',
            'Nome inválido',
          ]),
        );

        final result = await repository.createUser(
          name: 'Luke SkyWalker',
          email: 'luke@skywalker.com',
        );

        switch (result) {
          case Ok():
            fail('Expected Err, got Ok');
          case Err(error: final error):
            expect(error, 'Email já existe\nNome inválido');
        }

        verify(
          () => apiClient.post('users', {
            'name': 'Luke SkyWalker',
            'email': 'luke@skywalker.com',
          }),
        ).called(1);
        verifyNoMoreInteractions(apiClient);
      },
    );
  });
}
