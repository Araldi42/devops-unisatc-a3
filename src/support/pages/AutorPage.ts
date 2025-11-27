import { Page, expect } from '@playwright/test';
import { faker } from '@faker-js/faker';
import AutorElements from '../elements/AutorElements';
import BasePage from './BasePage';

export default class AutorPage extends BasePage {
  readonly elements: AutorElements;

  constructor(readonly page: Page) {
    super(page);
    this.elements = new AutorElements(page);
  }

  async navegarParaCriacaoAutor(): Promise<void> {
    // Se já estiver no Content Manager, o menu lateral persiste, mas por segurança clicamos de novo
    await this.elements.getMenuContentManager().click();
    await this.elements.getLinkAutor().click();
    await this.elements.getBotaoCriarNovo().click();
  }

  async preencherAutor(): Promise<void> {
    await this.elements.getInputNome().fill(faker.person.fullName());
    await this.elements.getInputEmail().fill(faker.internet.email());
  }

  async salvarAutor(): Promise<void> {
    await this.elements.getBotaoSalvar().click();
  }

  async validarCriacao(): Promise<void> {
    await expect(this.elements.getToastSucesso()).toBeVisible();
  }
}