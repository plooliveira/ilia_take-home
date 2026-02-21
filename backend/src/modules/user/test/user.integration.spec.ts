import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { UserModule } from '../../user/user_module';
import { USER_REPOSITORY } from '../../user/data/repository/user_repository';

jest.mock('../../user/data/repository/prisma_user_repository', () => ({
  PrismaUserRepository: class {},
}));

describe('UserModule Integration (Mocked Repository)', () => {
  let app: INestApplication;
  
  const mockRepository = {
    create: jest.fn(),
    findAll: jest.fn(),
    count: jest.fn(),
  };

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [UserModule],
    })
    .overrideProvider(USER_REPOSITORY) 
    .useValue(mockRepository)
    .compile();

    app = moduleFixture.createNestApplication();
    
    app.useGlobalPipes(new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }));

    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('POST /users (Validation & DTO)', () => {
    it('should return 400 if email is invalid', async () => {
      const response = await request(app.getHttpServer())
        .post('/users')
        .send({ name: 'John Doe', email: 'invalid-email' });

      expect(response.status).toBe(400);
      expect(response.body.message).toContain('Invalid email format');
    });

    it('should return 400 if name is missing', async () => {
      const response = await request(app.getHttpServer())
        .post('/users')
        .send({ email: 'john@test.com' });

      expect(response.status).toBe(400);
      expect(response.body.message).toContain('Name should not be empty');
    });
  });

  describe('POST /users (Flow with Mock)', () => {
    it('should return 409 if repository throws Email already exists', async () => {
      mockRepository.create.mockRejectedValue(new Error('Email already exists'));

      const response = await request(app.getHttpServer())
        .post('/users')
        .send({ name: 'John Doe', email: 'duplicate@test.com' });

      expect(response.status).toBe(409);
      expect(response.body.message).toBe('Email already exists');
    });

    it('should return 201 if everything is fine', async () => {
      const userData = { name: 'John Doe', email: 'ok@test.com' };
      mockRepository.create.mockResolvedValue(userData);

      const response = await request(app.getHttpServer())
        .post('/users')
        .send(userData);

      expect(response.status).toBe(201);
      expect(response.body).toEqual(userData);
    });
  });

  describe('GET /users', () => {
    it('should return 500 if database fails', async () => {
      mockRepository.findAll.mockRejectedValue(new Error('DB connection error'));
      mockRepository.count.mockRejectedValue(new Error('DB connection error'));

      const response = await request(app.getHttpServer()).get('/users?page=1&limit=10');

      expect(response.status).toBe(500);
    });

    it('should return 200 with paginated users', async () => {
      const users = [{ name: 'John Doe', email: 'john@test.com' }];
      mockRepository.findAll.mockResolvedValue(users);
      mockRepository.count.mockResolvedValue(1);

      const response = await request(app.getHttpServer()).get('/users?page=1&limit=10');

      expect(response.status).toBe(200);
      expect(response.body).toEqual({
        data: users,
        meta: { total: 1, page: 1, lastPage: 1 }
      });
      expect(mockRepository.findAll).toHaveBeenCalledWith(0, 10);
      expect(mockRepository.count).toHaveBeenCalled();
    });
  });
});
