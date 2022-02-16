define psql_exec
	@touch ${PGPASSFILE}
	@chmod 600 ${PGPASSFILE}
	@echo "${POSTGRES_HOST}:${POSTGRES_PORT}:${POSTGRES_DBNAME}:${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}" > ${PGPASSFILE}
	@sed "s/__POSTGRES_USERNAME__/${POSTGRES_USERNAME}/g" ./$1.sql > ./$1.tmp.sql

	@psql \
		--dbname=${POSTGRES_DBNAME} \
		--file="./$1.tmp.sql" \
		--host=${POSTGRES_HOST} \
		--port=${POSTGRES_PORT} \
		--username=${POSTGRES_USERNAME}

	@rm ./$1.tmp.sql ${PGPASSFILE}
endef

dev-inf-down:
	docker-compose -f ./docker-compose.yml down

dev-inf-up:
	docker-compose -f ./docker-compose.yml up -d

setup:
	$(call psql_exec,user_fts/setup-table-and-index)
	$(call psql_exec,user_fts/define-user-entity-copy-function)
	$(call psql_exec,user_fts/define-user-attribute-copy-function)
	$(call psql_exec,user_fts/define-fts-function)
	$(call psql_exec,user_fts/set-user-entity-copy-trigger)
	$(call psql_exec,user_fts/set-user-attribute-copy-trigger)
	$(call psql_exec,user_fts/set-fts-trigger)

reset:
	$(call psql_exec,user_fts/drop-user-entity-copy-trigger)
	$(call psql_exec,user_fts/drop-user-attribute-copy-trigger)
	$(call psql_exec,user_fts/drop-fts-trigger)
	$(call psql_exec,user_fts/remove-user-entity-copy-function)
	$(call psql_exec,user_fts/remove-user-attribute-copy-function)
	$(call psql_exec,user_fts/remove-fts-function)
	$(call psql_exec,user_fts/wipeout-table-and-index)
