import { Page } from '@playwright/test';
import LoginElements from '../elements/LoginElements';
import BasePage from './BasePage';

export default class LoginPage extends BasePage {
  readonly loginElements: LoginElements;

  constructor(readonly page: Page) {
    super(page);
    this.loginElements = new LoginElements(page);
  }

  async acessarLogin(url: string): Promise<void> {
    await this.page.goto(url);
  }

  async realizarLogin(email: string, pass: string): Promise<void> {
    await this.loginElements.getInputEmail().fill(email);
    await this.loginElements.getInputPassword().fill(pass);
    await this.loginElements.getButtonLogin().click();
    await this.page.waitForTimeout(2000); 
  }
}