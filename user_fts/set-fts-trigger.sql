CREATE TRIGGER user_fts_fts_trigger
    BEFORE INSERT OR UPDATE OR DELETE
    ON user_fts
    FOR EACH ROW
    EXECUTE PROCEDURE user_fts_fts();
