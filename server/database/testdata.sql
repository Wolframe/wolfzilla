-- test data

INSERT INTO User ( login, pass, lastname, firstname, email )
	VALUES( 'abaumann', 'xx', 'Baumann', 'Andreas', 'abaumann@yahoo.com' );
INSERT INTO User ( login, pass, lastname, firstname, email )
	VALUES( 'mbarbos', 'xx', 'Barbos', 'Mihai', 'mihai.barbos@gmail.com' );
INSERT INTO User ( login, pass, lastname, firstname, email )
	VALUES( 'pfrey', 'xx', 'Frey', 'Patrick', 'patrickpfrey@gmail.com' );

INSERT INTO "Project" VALUES(10001,NULL,NULL,NULL,'WOLFRAME','Wolframe',NULL,'Wolframe core',3);
INSERT INTO "Project" VALUES(10002,NULL,NULL,NULL,'WOLFCLIENT','Wolfclient',NULL,'Wolframe client',3);
INSERT INTO "Project" VALUES(10003,NULL,NULL,NULL,'CONFIGURATOR','Configurator',NULL,'Configurator',3);
INSERT INTO "Project" VALUES(10004,NULL,NULL,NULL,'CRM','Crm',NULL,'Customer relations management',4);
INSERT INTO "Project" VALUES(10005,NULL,NULL,NULL,'WOLFZILLA','Wolfzilla',NULL,'Bug reporting',2);
INSERT INTO "Project" VALUES(10006,NULL,NULL,NULL,'WERP','Werp',NULL,'Simple ERP implementation using Wolframe',3);

INSERT INTO "Component" VALUES(11001,NULL,NULL,NULL,'Sqlite database module',NULL,'Sqlite database module',10001,3,3);
INSERT INTO "Component" VALUES(11002,NULL,NULL,NULL,'Postgresql database module',NULL,'Postgresql database module',10001,3,3);
INSERT INTO "Component" VALUES(11003,NULL,NULL,NULL,'simpleform DDL',NULL,'simpleform data definition language',10001,4,4);
INSERT INTO "Component" VALUES(11004,NULL,NULL,NULL,'TDL',NULL,'transaction definition language',10001,4,4);
INSERT INTO "Component" VALUES(11005,NULL,NULL,NULL,'database authentication module',NULL,'authenticate against a database containing user credentials',10001,3,3);
INSERT INTO "Component" VALUES(11006,NULL,NULL,NULL,'PAM authentication module',NULL,'authenticate against Unix system account (via PAM)',10001,3,3);
INSERT INTO "Component" VALUES(11007,NULL,NULL,NULL,'SASL authentication module',NULL,'authenticate against Cyrus SASL',10001,3,3);
