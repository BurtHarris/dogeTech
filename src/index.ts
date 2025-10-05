console.log('🐕 DogeTech development environment is running!');
console.log('Environment:', process.env.NODE_ENV || 'development');
console.log('Version:', process.version);

// Basic HTTP server example
import { createServer } from 'http';

const port = process.env.PORT || 3000;

const server = createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({
    message: '🚀 DogeTech API is running!',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  }));
});

server.listen(port, '0.0.0.0', () => {
  console.log(`🌟 Server running at http://localhost:${port}`);
});