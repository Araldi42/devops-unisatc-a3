import { PlaywrightTestConfig } from '@playwright/test';

const config: PlaywrightTestConfig = {
  testDir: 'src/scenarios',
  timeout: 50000,
  retries: 0,
  webServer: {
    command: 'pnpm run develop',
    url: 'http://localhost:1337',
    timeout: 50000,
    reuseExistingServer: !process.env.CI,
  },
  use: {
    trace: 'on',
    locale: 'pt-BR',
    headless: false,
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true,
    screenshot: 'on',
    video: 'off'
  },
  reporter: [['html', { outputFolder: 'artifacts/report', open: 'never' }]]
};
export default config;