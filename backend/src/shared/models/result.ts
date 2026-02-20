// Result interface and Ok and Error classes implementation

import { error } from "console";

export interface Result<T> {
  isSuccess: boolean;
  isError: boolean;
  value?: T;
  error?: Error;
}

export class Ok<T> implements Result<T> {
  isSuccess = true;
  isError = false;
  constructor(public value: T) {}
}

export class Err implements Result<never> {
  isSuccess = false;
  isError = true;
  constructor(public error: Error) {}
}