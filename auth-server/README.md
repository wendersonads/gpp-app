# Auth Server

## Schema do banco de dados

Este script cria as tabelas no banco de dados. Note que a tabela **user_auth**

```sql
CREATE TABLE public.oauth_access_token (
	token_id varchar(256) NULL,
	token bytea NULL,
	authentication_id varchar(256) NOT NULL,
	user_name varchar(256) NULL,
	client_id varchar(256) NULL,
	authentication bytea NULL,
	refresh_token varchar(256) NULL,
	CONSTRAINT oauth_access_token_pk PRIMARY KEY (authentication_id)
);

-- Drop table

-- DROP TABLE public.oauth_approvals

CREATE TABLE public.oauth_approvals (
	userid varchar(256) NULL,
	clientid varchar(256) NULL,
	"scope" varchar(256) NULL,
	status varchar(10) NULL,
	expiresat timestamp NULL,
	lastmodifiedat timestamp NULL
);

-- Drop table

-- DROP TABLE public.oauth_client_details

CREATE TABLE public.oauth_client_details (
	client_id varchar(256) NOT NULL,
	resource_ids varchar(256) NULL,
	client_secret varchar(256) NULL,
	"scope" varchar(256) NULL,
	authorized_grant_types varchar(256) NULL,
	web_server_redirect_uri varchar(256) NULL,
	authorities varchar(256) NULL,
	access_token_validity int4 NULL,
	refresh_token_validity int4 NULL,
	additional_information varchar(4096) NULL,
	autoapprove varchar(256) NULL,
	CONSTRAINT oauth_client_details_pkey PRIMARY KEY (client_id)
);

-- Drop table

-- DROP TABLE public.oauth_client_token

CREATE TABLE public.oauth_client_token (
	token_id varchar(256) NULL,
	token bytea NULL,
	authentication_id varchar(256) NULL,
	user_name varchar(256) NULL,
	client_id varchar(256) NULL
);

-- Drop table

-- DROP TABLE public.oauth_code

CREATE TABLE public.oauth_code (
	code varchar(256) NULL,
	authentication bytea NULL
);

-- Drop table

-- DROP TABLE public.oauth_refresh_token

CREATE TABLE public.oauth_refresh_token (
	token_id varchar(256) NULL,
	token bytea NULL,
	authentication bytea NULL
);

alter table oauth_access_token owner to auth;
alter table oauth_approvals owner to auth;
alter table oauth_client_details owner to auth;
alter table oauth_client_token owner to auth;
alter table oauth_code owner to auth;
alter table oauth_refresh_token owner to auth;
```

Modificação em massa do owner das tabelas:

```bash
for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" auth` ; do  psql -c "alter table \"$tbl\" owner to auth" auth ; done
```

## Criação dos usuários locais

```bash
insert into oauth_client_details (client_id, client_secret, "scope", authorized_grant_types, access_token_validity, refresh_token_validity) values ('teste', 'ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413', 'read,write', 'password,authorization_code,refresh_token', 15552000, 15552000);

ou

CREATE EXTENSION pgcrypto; -- como superuser
insert into user_auth (login, "password", roles, tenant, active) values ('teste', (SELECT ENCODE(DIGEST('123456','sha512'),'hex')), 'admin', 'teste', true);


```

## Requisição de token

```bash
curl -k -X POST https://teste:123456@auth.datahorizons.info/auth-server/oauth/token -d grant_type=password -d username=teste -d password=123456
```

```bash
curl -X POST http://teste:123456@localhost:8082/auth-server/oauth/token -d grant_type=password -d username=teste -d password=123456
```

## Checagem de token 

```bash
curl -H "Content-Type: application/x-www-form-urlencoded" -X POST http://teste:123456@localhost:8082/auth-server/oauth/check_token?token=fcd11984-fe54-4aff-9a17-4fb62dd541ac

```

## Refresh token

```bash
curl -X POST http://teste:123456@localhost:8082/auth-server/oauth/token -d grant_type=refresh_token -d refresh_token=ba379c76-451d-4691-8514-570cb1e25e83
```
## Invocação com token

```bash
curl -k -H "Content-Type: application/json" -H "Authorization: Bearer 50eff79b-cbcc-4f8a-933c-b5185a248268" --data '{"campo1":3,"campo2":123}' -X POST http://localhost:8080/recurso/context
```
 

## Criar usuário

```bash
curl -X POST http://teste_user:123456@localhost:8082/auth-server/manager -d '{"login":"teste_user1@M.Com","password":"123456","roles":["ROLE_VIEWER"],"tenant":"teste"}' -H "Content-Type: application/json"
```

## Modificar senha

### Com a senha anterior
```bash
 curl -X POST http://teste_user:123456@localhost:8082/auth-server/manager/change -d '{"login":"teste_user1@M.Com","actual":"123456","newPass":"teste"}' -H "Content-Type: application/json"
```

### Sem a senha anterior
```bash
curl -X POST http://teste_user:123456@localhost:8082/auth-server/manager/changeWitoutPass -d '{"login":"teste_user1@M.Com", "newPass":"teste"}' -H "Content-Type: application/json"
```
