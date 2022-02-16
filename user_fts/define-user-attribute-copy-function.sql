CREATE FUNCTION user_attribute_user_fts()
	RETURNS trigger
	LANGUAGE plpgsql
AS $function$
    DECLARE
		attr_name varchar(255);
		col_name varchar(62);
		attr_value varchar(255);
		user_id varchar(36);
	BEGIN
		IF (TG_OP = 'DELETE') THEN
			attr_name = old.name;
			attr_value = null;
			user_id = old.user_id;
		ELSE
			attr_name = new.name;
			attr_value = new.value;
			user_id = new.user_id;
		END IF;

		IF (attr_name = 'memberid') THEN
			col_name = 'memberid';
		END IF;
		IF (attr_name = 'address') THEN
			col_name = 'address';
		END IF;

		IF col_name IS NOT NULL THEN
			IF (TG_OP = 'DELETE') THEN
				EXECUTE 'UPDATE user_fts SET ' || quote_ident(col_name) || '=null WHERE id = $1' USING user_id;
			ELSE
				EXECUTE 'UPDATE user_fts SET ' || quote_ident(col_name) || '=$1 WHERE id = $2' USING attr_value, user_id;
			END IF;
		END IF;

	   return null;
    END;
$function$;
