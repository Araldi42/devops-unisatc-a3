export default ({ env }) => ({
  host: env('HOST', '127.0.0.1'),
  port: env.int('PORT', 1337),
  app: {
    keys: env.array('APP_KEYS') || [
      'ImJMpHjnCdJw4ii7jZzCXQ==',
      'Jg239VoMach6Fh2LAH6ydA==',
      'LAdmPTwE8oqyVjAV4pCkBQ==',
      'f1gPGngKmE5xhyDktSpCVw==',
    ],
  },
});