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
- `@nestjs/swagger` - Documentação OpenAPI (Swagger)
- `Log Decorator` - Sistema de log automático via padrão Decorator

## Documentação API (Swagger)

A documentação interativa da API (Swagger UI) está disponível em:
`http://localhost:3000/api`

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

## Exemplos de Requests e Responses

### POST /users

Request

```
curl -s -X POST http://localhost:3000/users \
  -H 'Content-Type: application/json' \
  -d '{"name":"Leia Organa","email":"organa@email.com"}'
```

Response 201

```
{
  "name": "Leia Organa",
  "email": "organa@email.com"
}
```

Response 400 (validação)

```
{
  "statusCode": 400,
  "message": [
    "Invalid email format",
    "Name should not be empty"
  ],
  "error": "Bad Request"
}
```

Response 409 (e-mail duplicado)

```
{
  "statusCode": 409,
  "message": "Email already exists",
  "error": "Conflict"
}
```

### GET /users

Request

```
curl -s "http://localhost:3000/users?page=1&limit=10"
```

Response 200

```
{
  "data": [
    { "name": "John Doe", "email": "john@example.com" }
  ],
  "meta": { "total": 1, "page": 1, "lastPage": 1 }
}
```

Response 500 (exemplo)

```
{
  "statusCode": 500,
  "message": "DB connection error",
  "error": "Internal Server Error"
}
```

> Observação: consulte o Swagger em `http://localhost:3000/api` para explorar e testar os endpoints interativamente.

## Banco de Dados

- **SQLite** para desenvolvimento
- **Prisma** como ORM
- Schema em `prisma/schema.prisma`
