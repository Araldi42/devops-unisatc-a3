import { Locator, Page } from '@playwright/test';
import BaseElements from './BaseElements';

export default class AutorElements extends BaseElements {
  constructor(readonly page: Page) {
    super(page);
  }

  getMenuContentManager(): Locator {
    return this.page.getByRole('link', { name: 'Content Manager' });
  }

  getLinkAutor(): Locator {
    return this.page.getByRole('link', { name: 'Autor' });
  }

  getBotaoCriarNovo(): Locator {
    return this.page.getByRole('link', { name: 'Create new entry' }).first();
  }

  getInputNome(): Locator {
    return this.page.locator('input[name="name"]');
  }

  getInputEmail(): Locator {
    return this.page.locator('input[name="email"]');
  }

  getBotaoSalvar(): Locator {
    return this.page.getByRole('button', { name: 'Save' });
  }

  getToastSucesso(): Locator {
    return this.page.getByText('Saved');
  }
}