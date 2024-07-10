CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE user_role AS ENUM (
    'AUTHOR',
    'MANAGER'
);

CREATE TABLE users (
    id uuid NOT NULL DEFAULT uuid_generate_v4() CONSTRAINT user_pk PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    "password" TEXT NOT NULL,
    "role" user_role NOT NULL
);

CREATE UNIQUE INDEX user_username_idx ON users(username);

CREATE TABLE sections (
    id uuid NOT NULL DEFAULT uuid_generate_v4() CONSTRAINT sections_pk PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE UNIQUE INDEX sections_idx ON sections(name);

CREATE TABLE articles (
    id uuid NOT NULL DEFAULT uuid_generate_v4() CONSTRAINT articles_pk PRIMARY KEY,
    author VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    reading_time INT NOT NULL,
    section_id uuid NOT NULL REFERENCES sections (id),
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL
);

CREATE TYPE page AS ENUM (
    'ABOUT', 
    'CTF_ORGANIZATION'
) ;

CREATE TABLE pinned_articles (
    id uuid NOT NULL DEFAULT uuid_generate_v4() CONSTRAINT pinned_articles_pk PRIMARY KEY,
    article_id uuid NOT NULL REFERENCES articles (id) , 
    page page NOT NULL
);

CREATE TABLE clients (
    id uuid NOT NULL DEFAULT uuid_generate_v4() CONSTRAINT clients_pk PRIMARY KEY,
    ip VARCHAR(15) NOT NULL,
    last_request_time TIMESTAMP NOT NULL DEFAULT NOW(),
    is_spam BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX clients_ip_idx ON clients (ip);

CREATE TABLE partnership_requests (
    id uuid NOT NULL DEFAULT uuid_generate_v4() CONSTRAINT requests_pk PRIMARY KEY,
    client_id uuid NOT NULL REFERENCES clients (id),
    full_name VARCHAR(255) NOT NULL,
    company VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    comment TEXT
);

CREATE TABLE feedback_contacts (
    id uuid NOT NULL DEFAULT uuid_generate_v4() CONSTRAINT feedback_requests_pk PRIMARY KEY,
    client_id uuid NOT NULL REFERENCES clients (id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL
);