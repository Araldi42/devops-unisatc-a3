import { Locator, Page } from '@playwright/test';
import BaseElements from './BaseElements';

export default class CategoriaElements extends BaseElements {
  constructor(readonly page: Page) {
    super(page);
  }

  getMenuContentManager(): Locator {
    return this.page.getByRole('link', { name: 'Content Manager' });
  }

  getLinkCategoria(): Locator {
    return this.page.getByRole('link', { name: 'Categoria' });
  }

  getBotaoCriarNovo(): Locator {
    return this.page.getByRole('link', { name: 'Create new entry' }).first();
  }

  getInputNome(): Locator {
    return this.page.locator('input[name="name"]');
  }

  getBotaoSalvar(): Locator {
    return this.page.getByRole('button', { name: 'Save' });
  }

  getToastSucesso(): Locator {
    return this.page.getByText('Saved');
  }
}