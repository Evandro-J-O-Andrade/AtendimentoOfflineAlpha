const express = require('express');
const router = express.Router();
const { n8nWebhookHandler } = require('../webhooks/n8nWebhookHandler');

router.post('/webhook', n8nWebhookHandler);

router.get('/health', (req, res) => {
  res.json({ status: 'ok', integration: 'n8n' });
});

module.exports = router;