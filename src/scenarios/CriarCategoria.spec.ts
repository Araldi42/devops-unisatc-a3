import { test } from '@playwright/test';
import { join } from 'path';
import { TheConfig } from 'sicolo';
import LoginPage from '../support/pages/LoginPage';
import CategoriaPage from '../support/pages/CategoriaPage';

test.describe('Gestão de Categorias', () => {
  const CONFIG = join(__dirname, '../support/fixtures/config.yml');
  const BASE_URL = TheConfig.fromFile(CONFIG).andPath('application.strapi_admin').retrieveData();
  
  let loginPage: LoginPage;
  let categoriaPage: CategoriaPage;

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page);
    categoriaPage = new CategoriaPage(page);

    await loginPage.acessarLogin(BASE_URL);
    await loginPage.realizarLogin('admin@satc.edu.br', 'welcomeToStrapi123');
  });

  test('Deve criar uma nova categoria com sucesso', async () => {
    await categoriaPage.navegarParaCriacaoCategoria();
    await categoriaPage.preencherCategoria();
    await categoriaPage.salvarCategoria();
    await categoriaPage.validarCriacao();
  });
});