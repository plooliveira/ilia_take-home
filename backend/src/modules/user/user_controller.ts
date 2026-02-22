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
import { ApiTags, ApiOperation, ApiResponse, ApiBody, ApiQuery } from '@nestjs/swagger';
import { Log } from '../../shared/decorators/log_decorator';
import { UserService } from './user_service';
import { CreateUserDto } from './data/user_dto';
import { PaginationDto } from '../../shared/data/pagination_dto';

@ApiTags('users')
@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) { }

  @Post()
  @Log('UserController')
  @ApiOperation({ summary: 'Create a new user' })
  @ApiResponse({ status: 201, description: 'The user has been successfully created.' })
  @ApiResponse({ status: 400, description: 'Bad Request.' })
  @ApiResponse({ status: 409, description: 'Conflict - Email already exists.' })
  @ApiBody({ type: () => CreateUserDto })
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
  @ApiOperation({ summary: 'Get all users with pagination' })
  @ApiResponse({ status: 200, description: 'Return all users.' })
  @ApiResponse({ status: 500, description: 'Internal Server Error.' })
  @ApiQuery({ name: 'page', required: false, type: Number, description: 'Page number', example: 1 })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Number of items per page', example: 10 })
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
