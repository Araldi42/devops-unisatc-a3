export default ({ env }) => ({
  auth: {
    secret: env('ADMIN_JWT_SECRET', 'deEi8rGl7WB43uXiaYPaOg=='),
  },
  apiToken: {
    salt: env('API_TOKEN_SALT', 'X2d0C6rgXwWgwEZCslZN0A=='),
  },
  transfer: {
    token: {
      salt: env('TRANSFER_TOKEN_SALT'),
    },
  },
  flags: {
    nps: env.bool('FLAG_NPS', true),
    promoteEE: env.bool('FLAG_PROMOTE_EE', true),
  },
});
