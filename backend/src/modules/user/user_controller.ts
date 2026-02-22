// User Controller

import {
  Controller,
  Get,
  Post,
  Body,
  ConflictException,
  BadRequestException,
  InternalServerErrorException,
  Query,
} from '@nestjs/common';
import { Log } from '../../shared/decorators/log_decorator';
import { UserService } from './user_service';
import { CreateUserDto } from './data/user_dto';
import { PaginationDto } from '../../shared/data/pagination_dto';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) { }

  @Post()
  @Log('UserController')
  async create(@Body() createUserDto: CreateUserDto) {
    const result = await this.userService.create(createUserDto);

    if (result.isError) {
      const message = result.error?.message;
      if (message === 'Email already exists') {
        throw new ConflictException(message);
      }
      throw new BadRequestException(message || 'Failed to create user');
    }

    return result.value;
  }

  @Get()
  @Log('UserController')
  async findAll(@Query() paginationDto: PaginationDto) {
    const result = await this.userService.findAll(
      paginationDto.page!,
      paginationDto.limit!,
    );

    if (result.isError) {
      throw new InternalServerErrorException(
        result.error?.message || 'Failed to fetch users',
      );
    }

    return result.value;
  }
}
