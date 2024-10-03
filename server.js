const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Middleware to set security headers
app.use((req, res, next) => {
  res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
  res.setHeader('Cross-Origin-Embedder-Policy', 'require-corp');
  next();
});

// Serve static files from the root directory
app.use(express.static(path.join(__dirname)));

// Handle routes
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/upload', (req, res) => {
  res.sendFile(path.join(__dirname, 'upload', 'index.html'));
});

app.get('/video', (req, res) => {
  res.sendFile(path.join(__dirname, 'video', 'index.html'));
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});