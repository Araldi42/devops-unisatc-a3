import { Page, expect } from '@playwright/test';

export default abstract class BasePage {
  constructor(readonly page: Page) {
    this.page = page;
  }
}