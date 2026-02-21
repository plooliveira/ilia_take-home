// UserService

import { Injectable, Inject } from '@nestjs/common';
import { CreateUserDto } from './data/user_dto';
import { PaginatedUsers, User } from './data/user_model';
import { USER_REPOSITORY, type UserRepository } from './data/repository/user_repository';
import { Result, Ok, Err } from '../../shared/models/result';


@Injectable()
export class UserService {
  constructor(
    @Inject(USER_REPOSITORY)
    private readonly userRepository: UserRepository
  ) { }

  async create(createUserDto: CreateUserDto): Promise<Result<User>> {
    try {
      const user = await this.userRepository.create(createUserDto);
      return new Ok(user);
    } catch (error: any) {
      return new Err(error);
    }
  }

  async findAll(page: number, limit: number): Promise<Result<PaginatedUsers>> {
    try {
      const skip = (page - 1) * limit;
      const [users, total] = await Promise.all([
        this.userRepository.findAll(skip, limit),
        this.userRepository.count(),
      ]);

      const lastPage = Math.ceil(total / limit);

      return new Ok({
        data: users,
        meta: {
          total,
          page,
          lastPage,
        },
      });
    } catch (error: any) {
      return new Err(error);
    }
  }
}