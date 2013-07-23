-- User
--
CREATE TABLE User (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	login		TEXT		NOT NULL,
	pass		TEXT		NOT NULL,
	firstName	TEXT		NULL,
	lastName	TEXT		NULL,
	email		TEXT		NULL,
	CONSTRAINT login_unique UNIQUE( login )
);

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
	lft		INTEGER		NOT NULL,
	rgt		INTEGER		NOT NULL,
	name		TEXT		NOT NULL,
	description	TEXT		NULL,
	normalizedName	TEXT		NOT NULL,
	tag		TEXT		NOT NULL,
	ownerID		INTEGER		REFERENCES User( ID ),
	CONSTRAINT order_check CHECK ( rgt > lft ),
	CONSTRAINT project_name_unique UNIQUE( normalizedName, parentID )
);

-- Component
-- components in a tree, so reporting can be drilled down
CREATE TABLE Component (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	parentID	INTEGER		REFERENCES Component( ID ),
	lft		INTEGER		NOT NULL,
	rgt		INTEGER		NOT NULL,
	name		TEXT		NOT NULL,
	normalizedName	TEXT		NOT NULL,
	description	TEXT		NULL,
	ownerID		INTEGER		REFERENCES User( ID ),
	projectID	INTEGER		REFERENCES Project( ID ),
	CONSTRAINT order_check CHECK( rgt > lft ),
	CONSTRAINT component_name_unique UNIQUE( normalizedName, parentID )
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

-- IssueState
-- basically an enum of customizable bug states, default entries
-- may be 'OPEN', 'FIXED', 'CLOSED'
CREATE TABLE IssueState (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	state		TEXT		NOT NULL,
	normalizedState	TEXT		NOT NULL,
	description	TEXT		NULL,
	CONSTRAINT issue_state_unique UNIQUE( normalizedState )
);

-- IssuePriority
-- enum with priorities, for sorting/filtering only, otherwise they work
-- like tags
CREATE TABLE IssuePriority (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	priority	TEXT		NOT NULL,
	normalizedPriority TEXT		NOT NULL,
	description	TEXT		NULL,
	CONSTRAINT issue_priority_unique UNIQUE( normalizedPriority )
);

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

-- IssueHistory
--
CREATE TABLE IssueHistory (
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

-- Milestone
--
CREATE TABLE Milestone (
	ID		INTEGER		PRIMARY KEY AUTOINCREMENT,
	name		TEXT		NOT NULL,
	description	TEXT		NULL,
	dueDate		TIMESTAMP,
	projectID	INTEGER		REFERENCES Project( ID )
);

-- time measurement
-- FSM for state transitions
-- arbitrary attachable fields (e.g. use case ID)
-- arbitrary tagging for a tagcloud (for sure for issues)
