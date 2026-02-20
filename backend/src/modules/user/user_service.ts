// UserService

import { Injectable, Inject } from '@nestjs/common';
import { CreateUserDto } from './data/user_dto';
import { User } from './data/user_model';
import { USER_REPOSITORY, type UserRepository } from './data/repository/user_repository';
import { Result, Ok, Err } from '../../shared/models/result';

@Injectable()
export class UserService {
  constructor(
    @Inject(USER_REPOSITORY) 
    private readonly userRepository: UserRepository
  ) {}

  async create(createUserDto: CreateUserDto): Promise<Result<User>> {
    try {
      const user = await this.userRepository.create(createUserDto);
      return new Ok(user);
    } catch (error: any) {
      return new Err(error);
    }
  }

  async findAll(): Promise<Result<User[]>> {
    try {
      const users = await this.userRepository.findAll();
      return new Ok(users);
    } catch (error: any) {
      return new Err(error);
    }
  }
}