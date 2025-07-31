const express = require('express');
const cors = require('cors');
const app = express();

// Advanced CORS Configuration
const corsOptions = {
  origin: [
    'http://localhost:8082',  // Flutter web app
    'http://localhost:8081',  // Alternative Flutter port
    'http://localhost:3000',  // React dev server
    'https://yourdomain.com', // Production domain
  ],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: [
    'Content-Type', 
    'Authorization', 
    'X-Requested-With',
    'Origin',
    'Accept',
    'X-DEVICE-ID',
    'X-DEVICE-NAME',
    'X-DEVICE-OS',
    'X-DEVICE-OS-VERSION',
    'X-DEVICE-OS-VERSION-CODE'
  ],
  credentials: true, // Allow cookies and authorization headers
  optionsSuccessStatus: 200, // Some legacy browsers choke on 204
  maxAge: 86400 // Cache preflight response for 24 hours
};

// Enable CORS with advanced options
app.use(cors(corsOptions));

// Parse JSON bodies
app.use(express.json());

// Additional manual CORS headers for extra compatibility
app.use((req, res, next) => {
  // Log CORS request for debugging
  console.log(`CORS Request: ${req.method} ${req.url} from ${req.get('Origin')}`);
  
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.header('Access-Control-Allow-Origin', req.get('Origin') || '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.header('Access-Control-Allow-Headers', 
      'Origin, X-Requested-With, Content-Type, Accept, Authorization, X-DEVICE-ID, X-DEVICE-NAME, X-DEVICE-OS, X-DEVICE-OS-VERSION, X-DEVICE-OS-VERSION-CODE'
    );
    res.header('Access-Control-Allow-Credentials', 'true');
    res.header('Access-Control-Max-Age', '86400');
    return res.status(200).end();
  }
  
  next();
});

// Admin login endpoint
app.post('/api/admin/login', (req, res) => {
  const { email, password } = req.body;
  
  console.log('Login attempt:', { email, password });
  
  // Check credentials
  if (email === 'admin@mbankingcore.com' && password === 'admin123') {
    res.json({
      code: 200,
      message: 'Login successful',
      data: {
        admin: {
          id: 1,
          name: 'Administrator',
          email: 'admin@mbankingcore.com',
          role: 'super_admin',
          created_at: '2024-01-01T00:00:00Z',
          updated_at: '2024-01-01T00:00:00Z'
        },
        access_token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJtYmFua2luZ2NvcmUiLCJhdWQiOiJhZG1pbiIsImlhdCI6MTY0MDk5NTIwMCwiZXhwIjoxNjQwOTk4ODAwLCJzdWIiOiIxIiwidXNlcl9pZCI6MX0.sample_token',
        expires_in: 3600
      }
    });
  } else {
    res.status(401).json({
      code: 401,
      message: 'Invalid credentials',
      data: null
    });
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'Mock server is running',
    timestamp: new Date().toISOString()
  });
});

const PORT = 8083;
app.listen(PORT, () => {
  console.log(`Mock server running on http://localhost:${PORT}`);
  console.log('Available endpoints:');
  console.log('- POST /api/admin/login');
  console.log('- GET /api/health');
  console.log('');
  console.log('Test credentials:');
  console.log('Email: admin@mbankingcore.com');
  console.log('Password: admin123');
});
