CREATE TRIGGER user_attribute_user_fts_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON public.user_attribute
    FOR EACH ROW
    EXECUTE PROCEDURE public.user_attribute_user_fts();
