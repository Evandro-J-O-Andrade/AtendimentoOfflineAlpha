function n8nWebhookHandler(req, res) {
    const eventId = req.headers['x-n8n-event-id'];
    const signature = req.headers['x-n8n-signature'];
    const payload = req.body;

    console.log(`[n8n-webhook] Evento recebido: ${eventId}`);

    res.status(200).json({ received: true, eventId });
}

module.exports = { n8nWebhookHandler };