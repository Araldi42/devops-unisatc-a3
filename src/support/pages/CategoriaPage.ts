import { Page, expect } from '@playwright/test';
import { faker } from '@faker-js/faker';
import CategoriaElements from '../elements/CategoriaElements';
import BasePage from './BasePage';

export default class CategoriaPage extends BasePage {
  readonly elements: CategoriaElements;

  constructor(readonly page: Page) {
    super(page);
    this.elements = new CategoriaElements(page);
  }

  async navegarParaCriacaoCategoria(): Promise<void> {
    await this.elements.getMenuContentManager().click();
    await this.elements.getLinkCategoria().click();
    await this.elements.getBotaoCriarNovo().click();
  }

  async preencherCategoria(): Promise<void> {
    const nomeCategoria = faker.commerce.department();
    await this.elements.getInputNome().fill(nomeCategoria);
  }

  async salvarCategoria(): Promise<void> {
    await this.elements.getBotaoSalvar().click();
  }

  async validarCriacao(): Promise<void> {
    await expect(this.elements.getToastSucesso()).toBeVisible();
  }
}