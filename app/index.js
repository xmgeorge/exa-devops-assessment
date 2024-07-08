const os = require('os');
const http = require('http');

// Function to generate a random color
function getRandomColor() {
  const letters = '0123456789ABCDEF';
  let color = '#';
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}

function handleRequest(req, res) {
  const color = getRandomColor();
  const hostname = os.hostname();
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.write(`
    <html>
      <body style="background-color: ${color};">
        <h1 style="color: white;">Hi there! I'm being served from ${hostname}</h1>
      </body>
    </html>
  `);
  res.end();
}

http.createServer(handleRequest).listen(3000, () => {
  console.log('Server is listening on port 3000');
});
