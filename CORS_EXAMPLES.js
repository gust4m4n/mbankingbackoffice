// ===================================
// CORS Configuration Examples
// ===================================

// 1. EXPRESS.JS / NODE.JS
// ===================================

const express = require('express');
const cors = require('cors');
const app = express();

// Option 1: Simple CORS (Allow all origins)
app.use(cors());

// Option 2: Advanced CORS Configuration
const corsOptions = {
  origin: [
    'http://localhost:8082',  // Flutter web app
    'http://localhost:3000',  // React dev server
    'https://yourdomain.com', // Production domain
  ],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: [
    'Content-Type', 
    'Authorization', 
    'X-Requested-With',
    'X-DEVICE-ID',
    'X-DEVICE-NAME',
    'X-DEVICE-OS',
    'X-DEVICE-OS-VERSION',
    'X-DEVICE-OS-VERSION-CODE'
  ],
  credentials: true, // Allow cookies
  optionsSuccessStatus: 200
};

app.use(cors(corsOptions));

// Option 3: Manual CORS Headers
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 
    'Origin, X-Requested-With, Content-Type, Accept, Authorization, X-DEVICE-ID, X-DEVICE-NAME, X-DEVICE-OS, X-DEVICE-OS-VERSION, X-DEVICE-OS-VERSION-CODE'
  );
  res.header('Access-Control-Allow-Credentials', 'true');
  
  if (req.method === 'OPTIONS') {
    res.sendStatus(200);
  } else {
    next();
  }
});

// ===================================
// 2. LARAVEL / PHP
// ===================================

/*
// config/cors.php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [
        'http://localhost:8082',
        'https://yourdomain.com'
    ],
    'allowed_origins_patterns' => [],
    'allowed_headers' => [
        'Content-Type',
        'X-Requested-With',
        'Authorization',
        'X-DEVICE-ID',
        'X-DEVICE-NAME',
        'X-DEVICE-OS',
        'X-DEVICE-OS-VERSION',
        'X-DEVICE-OS-VERSION-CODE'
    ],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];

// Or manual middleware (app/Http/Middleware/Cors.php)
public function handle($request, Closure $next)
{
    return $next($request)
        ->header('Access-Control-Allow-Origin', '*')
        ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, X-DEVICE-ID, X-DEVICE-NAME, X-DEVICE-OS, X-DEVICE-OS-VERSION, X-DEVICE-OS-VERSION-CODE');
}
*/

// ===================================
// 3. SPRING BOOT / JAVA
// ===================================

/*
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:8082", "https://yourdomain.com")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}

// Or using @CrossOrigin annotation
@CrossOrigin(origins = {"http://localhost:8082"})
@RestController
@RequestMapping("/api")
public class AdminController {
    
    @PostMapping("/admin/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        // login logic
    }
}
*/

// ===================================
// 4. ASP.NET CORE / C#
// ===================================

/*
// Startup.cs or Program.cs
public void ConfigureServices(IServiceCollection services)
{
    services.AddCors(options =>
    {
        options.AddPolicy("AllowSpecificOrigin",
            builder =>
            {
                builder.WithOrigins("http://localhost:8082", "https://yourdomain.com")
                       .AllowAnyHeader()
                       .AllowAnyMethod()
                       .AllowCredentials();
            });
    });
}

public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.UseCors("AllowSpecificOrigin");
    app.UseRouting();
    app.UseEndpoints(endpoints =>
    {
        endpoints.MapControllers();
    });
}
*/

// ===================================
// 5. PYTHON FLASK
// ===================================

/*
from flask import Flask
from flask_cors import CORS

app = Flask(__name__)

# Simple CORS
CORS(app)

# Advanced CORS
CORS(app, resources={
    r"/api/*": {
        "origins": ["http://localhost:8082", "https://yourdomain.com"],
        "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        "allow_headers": ["Content-Type", "Authorization", "X-DEVICE-ID"]
    }
})

@app.route('/api/admin/login', methods=['POST'])
def admin_login():
    # login logic
    pass
*/

// ===================================
// 6. PYTHON DJANGO
// ===================================

/*
# settings.py
INSTALLED_APPS = [
    'corsheaders',
    # other apps
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    # other middleware
]

CORS_ALLOWED_ORIGINS = [
    "http://localhost:8082",
    "https://yourdomain.com",
]

CORS_ALLOW_HEADERS = [
    'accept',
    'accept-encoding',
    'authorization',
    'content-type',
    'dnt',
    'origin',
    'user-agent',
    'x-csrftoken',
    'x-requested-with',
    'x-device-id',
    'x-device-name',
    'x-device-os',
    'x-device-os-version',
    'x-device-os-version-code',
]

CORS_ALLOW_CREDENTIALS = True
*/

// ===================================
// 7. GO / GOLANG
// ===================================

/*
package main

import (
    "github.com/gin-gonic/gin"
    "github.com/gin-contrib/cors"
)

func main() {
    r := gin.Default()
    
    // Simple CORS
    r.Use(cors.Default())
    
    // Advanced CORS
    config := cors.Config{
        AllowOrigins:     []string{"http://localhost:8082", "https://yourdomain.com"},
        AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowHeaders:     []string{"Origin", "Content-Type", "Authorization", "X-DEVICE-ID"},
        AllowCredentials: true,
    }
    r.Use(cors.New(config))
    
    r.POST("/api/admin/login", func(c *gin.Context) {
        // login logic
    })
    
    r.Run(":8080")
}
*/

module.exports = app;
