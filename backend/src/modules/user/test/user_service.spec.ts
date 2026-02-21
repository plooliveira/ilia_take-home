import { Test, TestingModule } from '@nestjs/testing';
import { UserService } from '../../user/user_service';
import { USER_REPOSITORY, UserRepository } from '../../user/data/repository/user_repository';
import { User } from '../../user/data/user_model';

describe('UserService (Unit)', () => {
  let service: UserService;
  let repository: jest.Mocked<UserRepository>;

  const mockUser: User = { name: 'Test User', email: 'test@test.com' };
  const createUserDto = { name: 'Test User', email: 'test@test.com' };

  beforeEach(async () => {
    const mockRepository = {
      create: jest.fn(),
      findAll: jest.fn(),
      count: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: USER_REPOSITORY,
          useValue: mockRepository,
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    repository = module.get(USER_REPOSITORY);
  });

  describe('create', () => {
    it('should return Ok when creation is successful', async () => {
      repository.create.mockResolvedValue(mockUser);

      const result = await service.create(createUserDto);

      expect(result.isSuccess).toBe(true);
      expect(result.value).toEqual(mockUser);
      expect(repository.create).toHaveBeenCalledWith(createUserDto);
    });

    it('should return Err when repository fails', async () => {
      const error = new Error('Database connection failed');
      repository.create.mockRejectedValue(error);

      const result = await service.create(createUserDto);

      expect(result.isError).toBe(true);
      expect(result.error).toBe(error);
    });
  });

  describe('findAll', () => {
    it('should return Ok with list of users', async () => {
      const users = [mockUser];
      repository.findAll.mockResolvedValue(users);
      repository.count.mockResolvedValue(1);

      const result = await service.findAll(1, 10);

      expect(result.isSuccess).toBe(true);
      expect(result.value).toEqual({
        data: users,
        meta: { total: 1, page: 1, lastPage: 1 }
      });
      expect(repository.findAll).toHaveBeenCalledWith(0, 10);
      expect(repository.count).toHaveBeenCalled();
    });

    it('should return Ok with empty list when no users exist', async () => {
      repository.findAll.mockResolvedValue([]);
      repository.count.mockResolvedValue(0);

      const result = await service.findAll(1, 10);

      expect(result.isSuccess).toBe(true);
      expect(result.value).toEqual({
        data: [],
        meta: { total: 0, page: 1, lastPage: 0 }
      });
      expect(repository.findAll).toHaveBeenCalledWith(0, 10);
      expect(repository.count).toHaveBeenCalled();
    });

    it('should return Err when fetch fails', async () => {
      const error = new Error('Read failure');
      repository.findAll.mockRejectedValue(error);

      const result = await service.findAll(1, 10);

      expect(result.isError).toBe(true);
      expect(result.error).toBe(error);
      expect(repository.findAll).toHaveBeenCalledWith(0, 10);
    });
  });
});
