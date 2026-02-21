# Teste #1: UserRepository.getAllUsers (Mocktail)

Este plano adiciona mocking pragmático com Mocktail e cria testes unitários mínimos para garantir que `UserRepository.getAllUsers` continue funcionando (sucesso e erro de rede).

## Escopo
- Adicionar `mocktail` em `dev_dependencies`.
- Criar um teste unitário para `UserRepository.getAllUsers` cobrindo:
  - resposta de sucesso (JSON válido -> `Ok(PaginatedUsers)`)
  - falha de rede (`NetworkException` -> `Err(message)`) 
- Ajustar/remover `test/widget_test.dart` (template de counter) caso esteja quebrando o suite de testes.

## Por que isso é o mínimo indispensável
- `UserRepository` é a borda entre UI/controllers e o backend.
- Mudanças no contrato do backend ou no parsing quebram o app aqui primeiro.
- O teste de erro garante que a mensagem relevante é propagada via `Result.Err`.

## Mudanças planejadas
### 1) Dependência de teste
- Atualizar `frontend/pubspec.yaml`:
  - adicionar `mocktail` em `dev_dependencies`.
- Rodar `flutter pub get`.

### 2) Novo arquivo de teste
- Criar `frontend/test/data/user_repository_get_all_users_test.dart`.
- Conteúdo (alto nível):
  - `class MockApiClient extends Mock implements ApiClient {}`
  - `setUp`: instanciar `UserRepository(apiClient: mock)`
  - Caso A (sucesso):
    - `when(() => apiClient.get('users?page=1')).thenAnswer((_) async => fixtureJson)`
    - Assert: `result is Ok<PaginatedUsers>`; validar `data.length`, `meta.total/page/lastPage`, e um usuário (name/email)
  - Caso B (NetworkException):
    - `thenThrow(NetworkException('...', 0, []))`
    - Assert: `result is Err<PaginatedUsers>`; validar `error`.

#### Fixture JSON (deve seguir o model)
- `PaginatedUsers.fromJson` espera:
  - `data`: lista de itens com `name` e `email` (conforme `User.fromJson`)
  - `meta`: `{ total, page, lastPage }` (camelCase)

### 3) Sanidade do suite de testes
- Verificar `frontend/test/widget_test.dart`:
  - Se estiver falhando (é template de counter), remover ou substituir por smoke test real do app.

## Como rodar/verificar
- Rodar apenas o teste novo:
  - `flutter test test/data/user_repository_get_all_users_test.dart`
- Rodar tudo:
  - `flutter test`

## Critérios de aceite
- Teste passa localmente.
- `getAllUsers` retorna `Ok` no cenário de sucesso e `Err` no cenário de `NetworkException`.
- Suite `flutter test` não falha por causa do template antigo.
