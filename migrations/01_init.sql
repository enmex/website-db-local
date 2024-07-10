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
    thumbnail_url VARCHAR(255) NOT NULL,
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

INSERT INTO sections VALUES ('02a10360-5232-43ea-a287-931095f3c3df', 'Новости');
INSERT INTO sections VALUES ('40c07add-8337-4b3d-b297-a1da463cafb4', 'Исследования');
INSERT INTO sections VALUES ('c7d6cbbc-e203-40cc-9e10-02e43c011d46', 'Райтапы');

INSERT INTO articles (
    id, 
    author,
    reading_time,
    section_id,
    title,
    content
) VALUES (
    '781fbf61-b58d-4403-9e93-441f5a07c062',
    'Александр Худорожко',
    4,
    '02a10360-5232-43ea-a287-931095f3c3df',
    'Заголовок новостной статьи',
    'Lorem ipsum dolor sit amet, consectetur adip, sed do eum et accus iacul'
);

INSERT INTO articles (
    id, 
    author,
    reading_time,
    section_id,
    title,
    content
) VALUES (
    '84684d71-7af0-4a71-a033-16ed9c5d1424',
    'Михаил Привалов',
    5,
    '40c07add-8337-4b3d-b297-a1da463cafb4',
    'Заголовок исследовательской статьи',
    'Lorem ipsum dolor sit amet, consectetur adip, sed do eum et accus iacul'
);

INSERT INTO articles (
    id, 
    author,
    reading_time,
    section_id,
    title,
    content
) VALUES (
    'cf42091f-05cb-4531-8ae6-a68db1bc442d',
    'Никита Гусев',
    5,
    'c7d6cbbc-e203-40cc-9e10-02e43c011d46',
    'Райтап на RCE таск',
    'Lorem ipsum dolor sit amet, consectetur adip, sed do eum et accus iacul'
);

INSERT INTO pinned_articles (
    article_id, 
    page
) VALUES (
    'cf42091f-05cb-4531-8ae6-a68db1bc442d',
    'ABOUT'
);

INSERT INTO pinned_articles (
    article_id, 
    page
) VALUES (
    '84684d71-7af0-4a71-a033-16ed9c5d1424',
    'CTF_ORGANIZATION'
);