-- init.sql
-- This script initializes the PostgreSQL database with sample tables and data

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create posts table
CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample users
INSERT INTO users (name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com');

-- Insert sample posts
INSERT INTO posts (title, content, user_id) VALUES
('First Post', 'This is the first post using CleanStart PostgreSQL!', 1),
('Database Testing', 'Testing PostgreSQL with Docker is easy!', 2),
('Hello World', 'Welcome to PostgreSQL sample project.', 1);

