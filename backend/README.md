# Backend (NestJS)

API REST para gestão de usuários com NestJS, Prisma e SQLite.

## Rodando localmente

```bash
# Instalar dependências
npm install

# Configurar variável de ambiente
echo "DATABASE_URL=file:./dev.db" > .env

# Rodar migrações do Prisma
npx prisma migrate dev

# Gerar cliente Prisma
npx prisma generate

# Rodar em modo desenvolvimento
npm run start:dev
```

## Estrutura

- `src/app.module.ts` - Módulo raiz da aplicação
- `src/main.ts` - Entry point com configuração do servidor
- `src/modules/user/` - Módulo de usuários:
  - `data/` - Models, DTOs e repositórios
  - `user_controller.ts` - Endpoints REST
  - `user_service.ts` - Lógica de negócio
  - `user_module.ts` - Configuração do módulo
- `src/shared/` - Utilitários compartilhados
- `prisma/` - Schema e configurações do banco

## Arquitetura

Arquitetura em camadas (módulos padrão NestJS) com repository para adapter do Prisma.

## Dependências principais

- `@nestjs/core` - Framework principal
- `@prisma/client` - ORM para banco de dados
- `@prisma/adapter-better-sqlite3` - Driver SQLite
- `class-validator` - Validação de DTOs
- `@nestjs/throttler` - Rate limiting

## Testes

Testes unitários com mocks (não precisam de banco real):

```bash
# Rodar todos os testes
npm test

# Rodar em modo watch
npm run test:watch

# Gerar coverage
npm run test:cov
```

## API Endpoints

- `POST /users` - Criar usuário
- `GET /users` - Listar usuários (paginado)
- `GET /users?page=1&limit=10` - Listar com paginação

## Banco de Dados

- **SQLite** para desenvolvimento
- **Prisma** como ORM
- Schema em `prisma/schema.prisma`
