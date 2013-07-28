-- User
-- this should be linked (or be completly) in AAAA
CREATE TABLE User (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	login		TEXT		NOT NULL,
	pass		TEXT		NULL,
	firstName	TEXT		NULL,
	lastName	TEXT		NULL,
	email		TEXT		NULL,
	CONSTRAINT login_unique UNIQUE( login )
);
INSERT INTO User ( ID, login, pass, lastname, firstname, email )
	VALUES( 1, 'admin', 'admin', 'Root', 'The', 'contact@wolframe.net' );

-- Group
--
CREATE TABLE "Group" (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	CONSTRAINT group_name_unique UNIQUE( normalizedName )
);

-- GroupMember
--
CREATE TABLE GroupMember (
	groupID		INTEGER		REFERENCES "Group"( ID ),
	userID		INTEGER		REFERENCES User( ID ),
	CONSTRAINT group_user_pk PRIMARY KEY( groupID, userID )
);

-- Project
-- projects, organizable in tree of subprojects
CREATE TABLE Project (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	parentID	INTEGER		REFERENCES Project( ID ),
	lft		INTEGER		NULL,		-- TODO: later
	rgt		INTEGER		NULL,		-- TODO: later
	shortcut	TEXT		NOT NULL,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NULL,
	description	TEXT		NULL,
	ownerID		INTEGER		NOT NULL REFERENCES User( ID ),
--	CONSTRAINT order_check CHECK ( rgt > lft ),
	CONSTRAINt project_shortcut_unique UNIQUE( shortcut ),
--	CONSTRAINT project_name_unique UNIQUE( normalizedName, parentID ),
	CONSTRAINT project_name_unique UNIQUE( name )
);
-- make sure the autoincrement for projects starts with 10001
INSERT INTO Project( ID, parentID, name, normalizedName, shortcut, ownerID )
	VALUES ( 10000, 10000, '_ROOT_', '_ROOT_', 'ROOT', 1 );
DELETE FROM Project WHERE ID = 10000;

-- Component
-- components in a tree, so reporting can be drilled down
CREATE TABLE Component (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	parentID	INTEGER		REFERENCES Component( ID ),
	lft		INTEGER		NULL,		-- TODO: later
	rgt		INTEGER		NULL,		-- TODO: later
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	ownerID		INTEGER		REFERENCES User( ID ),
	projectID	INTEGER		REFERENCES Project( ID ),
--	CONSTRAINT order_check CHECK( rgt > lft ),
--	CONSTRAINT component_name_unique UNIQUE( normalizedName, parentID )
--	CONSTRAINT component_name_unique UNIQUE( name, parentID )
	CONSTRAINT component_name_unique UNIQUE( name )
);

-- IssueType
-- basically an enum of customizable bug type, default entries
-- may be 'bug', 'feature request', etc.
--
CREATE TABLE IssueType (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	CONSTRAINT issue_type_name_unique UNIQUE( normalizedName )
);
INSERT INTO IssueType( name, normalizedName, description )
	VALUES( 'Bug', 'BUG', 'a defect, not working as expected' );
INSERT INTO IssueType( name, normalizedName, description )
	VALUES( 'Improvement', 'IMPROVEMENT', 'improvement of something existing' );
INSERT INTO IssueType( name, normalizedName, description )
	VALUES( 'New feature', 'NEW FEATURE', 'something new, a new idea' );

-- IssueState
-- basically an enum of customizable bug states, default entries
-- may be 'OPEN', 'CLOSED' or
-- 'NEW', 'ASSIGNED', 'RESOLVED', 'CLOSED'
CREATE TABLE IssueState (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	CONSTRAINT issue_state_unique UNIQUE( normalizedName )
);
INSERT INTO IssueState( name, normalizedName, description )
	VALUES( 'Open', 'OPEN', 'Bug open' );
INSERT INTO IssueState( name, normalizedName, description )
	VALUES( 'Closed', 'CLOSED', 'Bug closed' );

-- IssuePriority
-- enum with priorities, for sorting/filtering only, otherwise they work
-- like tags
CREATE TABLE IssuePriority (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	CONSTRAINT issue_priority_unique UNIQUE( normalizedName )
);
INSERT INTO IssuePriority( name, normalizedName, description )
	VALUES( 'high', 'HIGH', 'high priority' );
INSERT INTO IssuePriority( name, normalizedName, description )
	VALUES( 'normal', 'NORMAL', 'normal priority' );
INSERT INTO IssuePriority( name, normalizedName, description )
	VALUES( 'low', 'LOW', 'low priority' );

-- IssueSeverity
-- enum with severity of bug, for sorting/filtering only, they work like tags
CREATE TABLE IssueSeverity (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	CONSTRAINT issue_priority_unique UNIQUE( normalizedName )
);
INSERT INTO IssueSeverity( name, normalizedName, description )
	VALUES( 'Blocker', 'BLOCKER', 'blocking a milestone' );
INSERT INTO IssueSeverity( name, normalizedName, description )
	VALUES( 'Critical', 'CRITICAL', 'a critical bug' );
INSERT INTO IssueSeverity( name, normalizedName, description )
	VALUES( 'Major', 'MAJOR', 'major issue' );
INSERT INTO IssueSeverity( name, normalizedName, description )
	VALUES( 'Minor', 'MINOR', 'minor issue' );

-- Issue
--
CREATE TABLE Issue (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	issueStateID	INTEGER		REFERENCES IssueState( ID ),
	reporterID	INTEGER		REFERENCES User( ID ),
	ownerID		INTEGER		REFERENCES User( ID ),
	assigneeID	INTEGER		REFERENCES User( ID ),
	creationDate	TIMESTAMP	NOT NULL,
	dueDate		TIMESTAMP,
	title		TEXT		NOT NULL,
	componentID	INTEGER		REFERENCES Component( ID )
);
-- IssueWatcher
-- users can register to watch an issue (this may trigger email
-- notification)
CREATE TABLE IssueWatcher (
	issueID		INTEGER		REFERENCES Issue( ID ),
	userID		INTEGER		REFERENCES User( ID )
);

-- IssueComment
--
CREATE TABLE IssueComment (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	issueID		INTEGER		REFERENCES Issue( ID ),
	creationDate	TIMESTAMP,
	description	TEXT,
	writerID	INTEGER		REFERENCES User( ID )
);

-- IssueAttachment
--
CREATE TABLE IssueAttachment (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	issueID		INTEGER		REFERENCES Issue( ID ),
	writerID	INTEGER		REFERENCES User( ID ),
	contentType	TEXT,
	content		TEXT
);

-- IssueLinkType
CREATE TABLE IssueLinkType (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	linker		TEXT		NULL,
	linkee		TEXT		NULL,
	CONSTRAINT issue_priority_unique UNIQUE( normalizedName )
);
INSERT INTO IssueLinkType( name, normalizedName, description, linker, linkee )
	VALUES( 'Block', 'BLOCK', 'Issue blocking or being blocked by other issue', 'blocks', 'is blocked by' );
INSERT INTO IssueLinkType( name, normalizedName, description, linker, linkee )
	VALUES( 'Duplicate', 'DUPLICATE', 'Issue is a duplicate of another issue', 'duplicates', 'is a duplicate of' );
INSERT INTO IssueLinkType( name, normalizedName, description, linker, linkee )
	VALUES( 'Relates', 'RELATES', 'Issue is related to another issue', 'relates to', 'relates to' );

-- IssueLink
CREATE TABLE IssueLink (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	type		INTEGER		REFERENCES IssueLinkType( ID ),
	linkerID	INTEGER		REFERENCES Issue( ID ),
	linkeeID	INTEGER		REFERENCES Issue( ID ),
	CONSTRAINT issue_link_not_same CHECK( linkerID <> linkeeID )
);

-- Milestone
--
CREATE TABLE Milestone (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	description	TEXT		NULL,
	dueDate		TIMESTAMP,
	projectID	INTEGER		REFERENCES Project( ID )
);

-- TODOS
-- roles
-- time measurement
-- FSM for state transitions
-- schemas for bug types and the operations between them
-- arbitrary attachable fields (e.g. use case ID)
-- arbitrary tagging for a tagcloud (for sure for issues)
-- translations for all data (e.g. description of bugs)
