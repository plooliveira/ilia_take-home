// Contrato user repository injetavel com export symbol

import { CreateUserDto } from "../user_dto";
import { User } from "../user_model";

 
export interface UserRepository {
  create(createUserDto: CreateUserDto): Promise<User>;
  findAll(skip?: number, take?: number): Promise<User[]>;
  count(): Promise<number>;
}

// Export with Symbol
export const USER_REPOSITORY = Symbol("USER_REPOSITORY");