# Ilia Take-home

Projeto take-home que permite cadastrar usuários e visualizá-los em uma lista. Aplicação multiplataforma desenvolvida com Flutter (frontend) e NestJS (backend).

## Sobre o Projeto

Aplicação de cadastro de usuários com:
- **Cadastro de usuários** com validação de email e nome
- **Listagem paginada** com loading states e tratamento de erros
- **Interface responsiva** que funciona em mobile, web e desktop

> [!NOTE]
> Foram deixados alguns comentários orientadores pelo código para facilitar a compreensão de certas decisões técnicas e fluxos da aplicação.

## Como Rodar

### Backend (NestJS)
Veja [backend/README.md](./backend/README.md) para instruções detalhadas:

```bash
cd backend
npm install
echo "DATABASE_URL=file:./dev.db" > .env
npx prisma migrate dev
npx prisma generate
npm run start:dev
```

**Documentação da API:**
Após rodar o backend, acesse a documentação interativa em:
[http://localhost:3000/api](http://localhost:3000/api)

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
- **Comunicação**: API REST robusta com paginação e rate limiting

## Tecnologia e Versões

- **Backend**: NestJS 11
- **Frontend**: Flutter 3.38 (Dart 3.10)
- **Banco de Dados**: SQLite com Prisma ORM

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