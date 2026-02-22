// CreateUserDto
import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ type: String, example: 'Anakin Skywalker', description: 'The name of the user' })
  @IsNotEmpty({ message: 'Name should not be empty' })
  @IsString()
  @MinLength(3, { message: 'Name must be at least 3 characters long' })
  name!: string;

  @ApiProperty({ type: String, example: 'anakin@example.com', description: 'The email of the user' })
  @IsNotEmpty({ message: 'Email should not be empty' })
  @IsEmail({}, { message: 'Invalid email format' })
  email!: string;
}

