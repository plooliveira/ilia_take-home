# Frontend (Flutter)

Este é o app Flutter do take-home, com navegação responsiva e consumo de API paginada.

## Rodando localmente

```bash
# Instalar dependências
flutter pub get

# Rodar em modo desenvolvimento
flutter run

# Rodar os testes
flutter test
```

## Estrutura

- `lib/data/` - Models, repositórios e cliente HTTP
- `lib/view/` - Telas e controllers (estado com `Ctrl`)
- `lib/shared/` - Utilitários (`Result`, `Validators`)
- `test/` - Testes unitários com `mocktail`

## Arquitetura

Arquitetura em camadas simples:
- **View Layer** - Widgets e controllers (`UserCtrl`, `UserFormCtrl`)
- **Data Layer** - Repositórios e cliente HTTP (`UserRepository`, `ApiClient`)
- **Shared Layer** - Utilitários compartilhados (`Result`, `Validators`)


## Testes

Testes pragmáticos focados em:
- `UserRepository` (camada de dados)
- `UserCtrl` (estado da UI)

```bash
flutter test
```

## Dependências principais

- `go_router` - Navegação declarativa
- `http` - Cliente HTTP
- `mocktail` - Mocks para testes
- `ctrl` - Gerenciamento de estado reativo com Service Locator integrado
- `shimmer` - Efeito de loading skeleton

## Responsividade

A UI se adapta entre mobile e desktop usando layouts condicionais em `UsersView`.
