import { Locator, Page } from '@playwright/test';
import BaseElements from './BaseElements';

export default class LoginElements extends BaseElements {
  constructor(readonly page: Page) {
    super(page);
  }

  getInputEmail(): Locator {
    return this.page.locator('input[name="email"]');
  }

  getInputPassword(): Locator {
    return this.page.locator('input[name="password"]');
  }

  getButtonLogin(): Locator {
    return this.page.locator('button[type="submit"]');
  }
}