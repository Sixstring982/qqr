CREATE TABLE IF NOT EXISTS "schema_migrations" (version varchar(128) primary key);
CREATE TABLE `user` (
  id VARCHAR(36)  NOT NULL PRIMARY KEY -- UUID v4
, email VARCHAR(320) UNIQUE
, password_hash BINARY(60)  -- BCrypt Hash
);
-- Dbmate schema migrations
INSERT INTO "schema_migrations" (version) VALUES
  ('20231006230638');
