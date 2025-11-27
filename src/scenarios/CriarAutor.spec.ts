import { test } from '@playwright/test';
import { join } from 'path';
import { TheConfig } from 'sicolo';
import LoginPage from '../support/pages/LoginPage';
import AutorPage from '../support/pages/AutorPage';

test.describe('Gestão de Autores', () => {
  const CONFIG = join(__dirname, '../support/fixtures/config.yml');
  const BASE_URL = TheConfig.fromFile(CONFIG).andPath('application.strapi_admin').retrieveData();
  
  let loginPage: LoginPage;
  let autorPage: AutorPage;

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page);
    autorPage = new AutorPage(page);

    await loginPage.acessarLogin(BASE_URL);
    await loginPage.realizarLogin('admin@satc.edu.br', 'welcomeToStrapi123');
  });

  test('Deve criar um novo autor com sucesso', async () => {
    await autorPage.navegarParaCriacaoAutor();
    await autorPage.preencherAutor();
    await autorPage.salvarAutor();
    await autorPage.validarCriacao();
  });
});