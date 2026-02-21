// UserModel sem prisma

export class User {
  name!: string;
  email!: string;
}

export interface PaginatedUsers {
  data: User[];
  meta: {
    total: number;
    page: number;
    lastPage: number;
  };
}