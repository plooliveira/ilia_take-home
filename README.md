# Ilia Take-home

Projeto take-home que permite cadastrar usuários e visualizá-los em uma lista. Aplicação multiplataforma desenvolvida com Flutter (frontend) e NestJS (backend).

## Sobre o Projeto

Aplicação de cadastro de usuários com:
- **Cadastro de usuários** com validação de email e nome
- **Listagem paginada** com loading states e tratamento de erros
- **Interface responsiva** que funciona em mobile, web e desktop
- **API REST** robusta com paginação e rate limiting

## Como Rodar

### Backend (NestJS)
Veja [backend/README.md](./backend/README.md) para instruções detalhadas:

```bash
cd backend
npm install
npx prisma migrate dev
npx prisma generate
npm run start:dev
```

### Frontend (Flutter)
Veja [frontend/README.md](./frontend/README.md) para instruções detalhadas:

```bash
cd frontend
flutter pub get
flutter run
```

## Plataformas Suportadas

- **Mobile** - Android e iOS via Flutter
- **Web** - Navegadores modernos via Flutter Web
- **Desktop** - Windows, macOS e Linux via Flutter Desktop

## Arquitetura

- **Frontend**: Flutter com arquitetura em camadas simples, gerenciamento de estado com `Ctrl` e Service Locator
- **Backend**: NestJS com módulos padrão, Prisma ORM e SQLite
- **Comunicação**: API REST com paginação e tratamento de erros

## Testes

Ambos os projetos possuem suítes de testes pragmáticos:
- **Frontend**: Testes unitários com `mocktail`
- **Backend**: Testes unitários e integração com mocks

## Estrutura do Projeto

```
ilia_take-home/
├── frontend/          # Aplicação Flutter
│   ├── lib/          # Código fonte
│   ├── test/         # Testes
│   └── README.md     # Instruções do frontend
├── backend/           # API NestJS
│   ├── src/          # Código fonte
│   ├── prisma/       # Schema do banco
│   └── README.md     # Instruções do backend
└── README.md         # Este arquivo
```