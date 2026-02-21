// implementação usando prisma client

import { Injectable } from "@nestjs/common";

import { CreateUserDto } from "../user_dto";
import { User } from "../user_model";
import { UserRepository } from "./user_repository";
import { prisma } from "../../../../prisma/prisma";
import { Prisma } from "../../../../generated/prisma/client";

@Injectable()
export class PrismaUserRepository implements UserRepository {
    async create(createUserDto: CreateUserDto): Promise<User> {
        try {
            const user = await prisma.user.create({
                data: {
                    name: createUserDto.name,
                    email: createUserDto.email,
                },
            });
            return user as User;
        } catch (error) {
            if (error instanceof Prisma.PrismaClientKnownRequestError) {
                if (error.code === 'P2002') {
                    throw new Error('Email already exists');
                }
            }
            throw new Error('Failed to create user in database');
        }
    }

    async findAll(skip?: number, take?: number): Promise<User[]> {
        try {
            const users = await prisma.user.findMany({
                skip: skip,
                take: take,
                orderBy: { createdAt: 'desc' }
            });
            return users as User[];
        } catch (error) {
            throw new Error('Failed to fetch users from database');
        }
    }

    async count(): Promise<number> {
        try {
            return prisma.user.count();
        } catch (error) {
            throw new Error('Failed to count users from database');
        }
    }
}



