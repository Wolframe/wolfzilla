-- test data

INSERT INTO User ( login, pass, lastname, firstname, email )
	VALUES( 'user1', 'xx', 'One', 'User', 'user1@wolframe.net' );
INSERT INTO User ( login, pass, lastname, firstname, email )
	VALUES( 'user2', 'xx', 'Two', 'User', 'user2@wolframe.net' );

INSERT INTO "Project" VALUES(10001,NULL,NULL,NULL,'test1','test1',NULL,'Project one',2);
INSERT INTO "Project" VALUES(10002,NULL,NULL,NULL,'test2','test2',NULL,'Project Two',3);
