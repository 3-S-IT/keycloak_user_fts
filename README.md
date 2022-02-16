# PostgreSQL Full Text Search (FTS) and Keycloak

This repository contains the source code for a two part blog entry posted on [Medium](https://medium.com/@3-S-IT).

## Usage

```shell
$ source .env # Make sure POSTGRES_PASSWORD is set
$ make dev-inf-up # Starts docker containers
$ make setup # Modifys table layout of the Keycloak database
$ make reset # Reverts modifications made to the table layout
$ make dev-inf-down # Stops docker containers
```
