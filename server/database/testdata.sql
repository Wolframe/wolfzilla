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
INSERT INTO "Project" VALUES(10004,NULL,NULL,NULL,'CRM','Crm',NULL,'Customer relations management',3);
INSERT INTO "Project" VALUES(10005,NULL,NULL,NULL,'WOLFZILLA','Wolfzilla',NULL,'Bug reporting',3);
