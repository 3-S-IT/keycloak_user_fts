CREATE TRIGGER user_entity_user_fts_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON public.user_entity
    FOR EACH ROW
    EXECUTE PROCEDURE public.user_entity_user_fts();
