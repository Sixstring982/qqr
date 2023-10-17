-- migrate:up
CREATE TABLE `user` (
  id VARCHAR(36)  NOT NULL PRIMARY KEY -- UUID v4
, email VARCHAR(320) UNIQUE
, password_hash BINARY(60)  -- BCrypt Hash
);


-- migrate:down
DROP TABLE `user`;

