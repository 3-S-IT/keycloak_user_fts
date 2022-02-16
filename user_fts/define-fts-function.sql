CREATE FUNCTION user_fts_fts()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
    begin
        if (TG_OP = 'DELETE') then
            return old;
        else
            new.fts := to_tsvector(coalesce(new.email, '') || ' ' || coalesce(new.first_name, '') || ' ' || coalesce(new.last_name, '')  || ' ' ||  coalesce(new.username, '') || ' ' ||  coalesce(new.memberid, '') || ' ' ||  coalesce(new.address, ''));
            return new;
        end if;
    end;
$function$;
