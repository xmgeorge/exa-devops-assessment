const express = require('express');
const app = express();
app.get('/health', (req, res) => {
 res.status(200).send('OK');
});
app.listen(3000, () => {
 console.log('App is listening on port 3000');
});