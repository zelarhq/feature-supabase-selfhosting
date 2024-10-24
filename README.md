# Supabase Self-Hosting Guide

## Overview
Supabase self-hosting allows you to run the complete Supabase platform on your own infrastructure. This gives you full control over your data, customization options, and the ability to meet specific compliance requirements.


### Requirements
- Docker Engine (20.10.0+)
- Docker Compose (v2.0.0+)
- Git

## Installation and Setup

### 1. Clone the Repository
```bash
git clone https://github.com/supabase/supabase
cd supabase/docker
```

### 2. Configure Environment Variables
Copy the example environment file:
```bash
cp .env.example .env
```


### 3. Essential Environment Variables
IMPORTANT: Before configuring your .env file, you need to generate several critical keys:

JWT Secret
Anon Key
Service Role Key

Please refer to the official documentation for generating these keys:
https://supabase.com/docs/guides/self-hosting/docker#generate-api-keys


```plaintext
# API Configuration
API_EXTERNAL_URL=https://your-domain.com
JWT_SECRET=your-super-secret-jwt-token

# Database Configuration
POSTGRES_PASSWORD=your-database-password
DB_SSL_ENABLED=false

# Auth Configuration
SITE_URL=https://your-domain.com
ADDITIONAL_REDIRECT_URLS=
JWT_EXPIRY=3600
DISABLE_SIGNUP=false

# Studio Configuration
STUDIO_DEFAULT_ORGANIZATION=Default Organization
STUDIO_DEFAULT_PROJECT=Default Project
```

Note: For complete configuration options and detailed setup instructions,
refer to: https://supabase.com/docs/guides/self-hosting

### 4. Initial Deployment
```bash
docker compose up -d
```

## Modifying Configuration

### Update Environment Variables
1. Stop the services:
```bash
docker compose down
```

2. Edit the `.env` file:
```bash
nano .env
```

3. Restart services:
```bash
docker compose up -d
```

### Configuration Files
- Database: `./volumes/db/postgresql.conf`
- GoTrue (Auth): `./volumes/auth/config.json`
- Kong (API Gateway): `./volumes/api/kong.yml`

## Restarting Services

### Restart All Services
```bash
docker compose down
docker compose up -d
```

### Restart Specific Service
```bash
```

Available services:
- `kong`: API Gateway
- `auth`: Authentication
- `rest`: PostgREST
- `db`: PostgreSQL
- `storage`: Storage
- `imgproxy`: Image Processing
- `meta`: Metadata
- `realtime`: Realtime subscriptions

## Troubleshooting

### Common Issues

1. **Services Won't Start**
   - Check Docker logs: `docker compose logs`
   - Verify port availability
   - Ensure sufficient system resources

2. **Database Connection Issues**
   - Verify PostgreSQL is running: `docker compose ps db`
   - Check database logs: `docker compose logs db`
   - Confirm correct password in .env

3. **Auth Service Problems**
   - Verify JWT_SECRET is set
   - Check auth logs: `docker compose logs auth`
   - Ensure SITE_URL is correctly configured

### Health Checks
```bash
# Check all services status
docker compose ps

# Check service logs
docker compose logs 
```

## Maintenance

### Backup Database
```bash
docker compose exec db pg_dump -U postgres > backup.sql
```

### Update Supabase
```bash
git pull origin master
docker compose pull
docker compose down
docker compose up -d
```

## Client-Side Integration

### Installation
```bash
# Using npm
npm install @supabase/supabase-js

# Using yarn
yarn add @supabase/supabase-js

# Using pnpm
pnpm add @supabase/supabase-js
```

### Configuration

#### Local Development
```javascript
const supabaseUrl = 'http://localhost:8000'  // Your local Supabase URL
const supabaseAnonKey = 'your-anon-key'      // From your .env file

import { createClient } from '@supabase/supabase-js'
const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

#### Production
```javascript
const supabaseUrl = 'https://your-domain.com'    
const supabaseAnonKey = 'your-anon-key'     

example
const supabaseUrl = 'https://localhost:8000'    
const supabaseAnonKey = 'your-anon-key'     


import { createClient } from '@supabase/supabase-js'
const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

### Usage Examples

#### Database Operations
```javascript
// Fetch data
const { data, error } = await supabase
  .from('your_table')
  .select('*')

// Insert data
const { data, error } = await supabase
  .from('your_table')
  .insert([{ column: 'value' }])
```