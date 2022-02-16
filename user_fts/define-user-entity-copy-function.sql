CREATE FUNCTION user_entity_user_fts()
	RETURNS trigger
	LANGUAGE plpgsql
AS $function$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            DELETE FROM user_fts WHERE id = old.id;
        ELSE
	       	INSERT INTO user_fts (id, email, first_name, last_name, username) VALUES (
	       		new.id, new.email, new.first_name, new.last_name, new.username
	       	) ON CONFLICT (id) DO UPDATE SET
				email = new.email,
				first_name = new.first_name,
				last_name = new.last_name,
				username = new.username;
	    END IF;
        
	    return null;
    END;
$function$;
