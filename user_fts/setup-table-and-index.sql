-- enable trigram extension which offers GIN index
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;

-- setup user_fts table
CREATE TABLE user_fts (
    id character varying(36) UNIQUE NOT NULL,
    email character varying(512),
    first_name character varying(512),
    last_name character varying(512),
    username character varying(512),
    memberid text,
    address text,
    fts tsvector
);

-- copy current users from user_entity table
INSERT INTO user_fts (id, email, first_name, last_name, username) SELECT id, email, first_name, last_name, username FROM user_entity;

-- create views for copying user attributes from user_attributes table
CREATE VIEW search_memberid AS
SELECT user_id, "value" FROM user_attribute WHERE "name" = 'memberid';

CREATE VIEW search_address AS
SELECT user_id, "value" FROM user_attribute WHERE "name" = 'address';

-- copy current user attributes from views
UPDATE user_fts SET memberid = search_memberid.value FROM search_memberid WHERE search_memberid.user_id = user_fts.id;
UPDATE user_fts SET address = search_address.value FROM search_address WHERE search_address.user_id = user_fts.id;

-- create index on fts column
CREATE INDEX fts_idx ON user_fts USING GIN (fts);

-- update fts column based on already existing data in user_fts table
UPDATE user_fts SET fts = to_tsvector(coalesce(email, '') || ' ' || coalesce(first_name, '') || ' ' || coalesce(last_name, '')  || ' ' ||  coalesce(username, '') || ' ' ||  coalesce(memberid, '') || ' ' ||  coalesce(address, ''));
