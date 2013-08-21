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
	normalizedName	TEXT		NULL,		-- TODO: later
	description	TEXT		NULL,
	ownerID		INTEGER		NOT NULL REFERENCES User( ID ),
--	CONSTRAINT order_check CHECK ( rgt > lft ),
	CONSTRAINT project_shortcut_unique UNIQUE( shortcut ),
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
	normalizedName	TEXT		NULL,		-- TODO: later
	description	TEXT		NULL,
	projectID	INTEGER		REFERENCES Project( ID ),
	leadID		INTEGER		REFERENCES User( ID ),
	defaultAssigneeID INTEGER	REFERENCES User( ID ),
--	CONSTRAINT order_check CHECK( rgt > lft ),
--	CONSTRAINT component_name_unique UNIQUE( normalizedName, parentID )
--	CONSTRAINT component_name_unique UNIQUE( name, parentID )
	CONSTRAINT component_name_unique UNIQUE( name )
);
-- make sure the autoincrement for components starts with 11001
INSERT INTO Component( ID, name, normalizedName )
	VALUES ( 11000, '_ROOT_', '_ROOT_' );
DELETE FROM Component WHERE ID = 11000;

-- IssueType
-- basically an enum of customizable bug type, default entries
-- may be 'bug', 'feature request', etc.
--
CREATE TABLE IssueType (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	icon		TEXT		NULL,
	CONSTRAINT issue_type_name_unique UNIQUE( normalizedName )
);
INSERT INTO IssueType( name, normalizedName, description, icon )
	VALUES( 'Bug', 'BUG', 'a defect, not working as expected', ':/images/type_bug.png' );
INSERT INTO IssueType( name, normalizedName, description, icon )
	VALUES( 'Improvement', 'IMPROVEMENT', 'improvement of something existing', ':/images/type_improvement.png' );
INSERT INTO IssueType( name, normalizedName, description, icon )
	VALUES( 'New feature', 'NEW FEATURE', 'something new, a new idea', ':/images/type_new_feature.png' );

-- IssueState
-- basically an enum of customizable bug states, default entries
-- may be 'OPEN', 'CLOSED' or
-- 'NEW', 'ASSIGNED', 'RESOLVED', 'CLOSED'
CREATE TABLE IssueState (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	icon		TEXT		NULL,
	CONSTRAINT issue_state_unique UNIQUE( normalizedName )
);
INSERT INTO IssueState( name, normalizedName, description )
	VALUES( 'Open', 'OPEN', 'Bug open' );
INSERT INTO IssueState( name, normalizedName, description )
	VALUES( 'Assigned', 'ASSIGNED', 'Bug assigned and being fixed' );
INSERT INTO IssueState( name, normalizedName, description )
	VALUES( 'Resolved', 'RESOLVED', 'Bug resolved' );
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
	icon		TEXT		NULL,
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
	icon		TEXT		NULL,
	CONSTRAINT issue_priority_unique UNIQUE( normalizedName )
);
INSERT INTO IssueSeverity( name, normalizedName, description, icon )
	VALUES( 'Blocker', 'BLOCKER', 'blocking a milestone', ':/images/severity_blocker.png' );
INSERT INTO IssueSeverity( name, normalizedName, description, icon )
	VALUES( 'Critical', 'CRITICAL', 'a critical bug', ':/images/severity_critical.png' );
INSERT INTO IssueSeverity( name, normalizedName, description, icon )
	VALUES( 'Major', 'MAJOR', 'major issue', ':/images/severity_major.png' );
INSERT INTO IssueSeverity( name, normalizedName, description, icon )
	VALUES( 'Minor', 'MINOR', 'minor issue', ':/images/severity_minor.png' );

-- IssueResolution
-- enum with resolutions of a bug, e.g. FIXED, DUPLICATE, NOT_REPRODUCABLE, WONT_FIX
CREATE TABLE IssueResolution (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	icon		TEXT		NULL,
	CONSTRAINT issue_resolution_unique UNIQUE( normalizedName )
);
INSERT INTO IssueResolution( name, normalizedName, description )
	VALUES( 'Fixed', 'FIXED', 'Bug fixed' );
INSERT INTO IssueResolution( name, normalizedName, description )
	VALUES( 'Duplicate', 'DUPLICATE', 'Bug is a duplicate of another one' );
INSERT INTO IssueResolution( name, normalizedName, description )
	VALUES( 'Not Reproducable', 'NOT REPRODUCABLE', 'Bug cant be reproduced' );
INSERT INTO IssueResolution( name, normalizedName, description )
	VALUES( 'Wont Fix', 'WONT FIX', 'Bug will not be fixed' );

-- IssueReference
-- an issue has an reference (PROJECT-XXX), numbers are usually incremented
-- and never reused, they may appear in extern SCM logs or documentation
CREATE TABLE IssueReference (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	projectID	INTEGER		REFERENCES Project( ID ),
	reference	INTEGER		NOT NULL,
	CONSTRAINT project_reference_unique UNIQUE( projectID, reference )
);

-- Issue
--
CREATE TABLE Issue (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	referenceID	INTEGER		NOT NULL REFERENCES IssueReference( ID ),
	title		TEXT		NOT NULL,
	description	TEXT		NOT NULL,
	componentID	INTEGER		REFERENCES Component( ID ),
	stateID		INTEGER		REFERENCES IssueState( ID ),
	resolutionID	INTEGER		REFERENCES IssueResolution( ID ),
	typeID		INTEGER		REFERENCES IssueType( ID ),
	severityID	INTEGER		REFERENCES IssueSeverity( ID ),
	priorityID	INTEGER		REFERENCES IssuePriority( ID ),
	reporterID	INTEGER		REFERENCES User( ID ),
	ownerID		INTEGER		REFERENCES User( ID ),
	assigneeID	INTEGER		REFERENCES User( ID ),
	creationDate	TIMESTAMP	NOT NULL,
	lastModDate	TIMESTAMP	NOT NULL,
	resolvedDate	TIMESTAMP,
	dueDate		TIMESTAMP,
	CONSTRAINT issue_referenceID_unique UNIQUE( referenceID )
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
	description	TEXT,
	writerID	INTEGER		REFERENCES User( ID ),
	creationDate	TIMESTAMP	NOT NULL,
	lastModDate	TIMESTAMP	NOT NULL
);

-- IssueAttachment
--
CREATE TABLE IssueAttachment (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	issueID		INTEGER		REFERENCES Issue( ID ),
	contentType	TEXT,
	content		TEXT,
	description	TEXT,
	writerID	INTEGER		REFERENCES User( ID ),
	creationDate	TIMESTAMP	NOT NULL,
	lastModDate	TIMESTAMP	NOT NULL
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
	linkerID	INTEGER		REFERENCES IssueReference( ID ),
	linkeeID	INTEGER		REFERENCES IssueReference( ID ),
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
-- treeish components, projects...
