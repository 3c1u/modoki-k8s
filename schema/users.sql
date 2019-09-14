CREATE TABLE users (
    id INTEGER NOT NULL PRIMARY KEY,
    type ENUM("user", "group"),
    name VARCHAR(128) NOT NULL UNIQUE,
    password VARBINARY(128),
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
);

ALTER TABLE users ADD INDEX name_index(name);