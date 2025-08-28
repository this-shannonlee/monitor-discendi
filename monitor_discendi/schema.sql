DROP TABLE IF EXISTS goal;

DROP TABLE IF EXISTS objective;

DROP TABLE IF EXISTS plan;

DROP TABLE IF EXISTS assignment_progress;

DROP TABLE IF EXISTS assignment_source;

DROP TABLE IF EXISTS assignment;

DROP TABLE IF EXISTS topic;

DROP TABLE IF EXISTS assignment_topic;

CREATE TABLE goal (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT UNIQUE NOT NULL,
    synopsis TEXT,
    url_address TEXT,
    focus_level INTEGER NOT NULL CHECK (
        focus_level > 0
        AND focus_level <= 10
    ) DEFAULT 2,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP,
    notes TEXT,
    is_complete BOOLEAN CHECK (is_complete IN (0, 1)) DEFAULT 0
);

CREATE TABLE objective (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    goal_id INTEGER NOT NULL,
    title TEXT NOT NULL UNIQUE,
    synopsis TEXT,
    url_address TEXT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_complete BOOLEAN CHECK (is_complete IN (0, 1)),
    FOREIGN KEY (goal_id) REFERENCES goal (id)
);

CREATE TABLE plan (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    objective_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    synopsis TEXT,
    url_address TEXT,
    notes TEXT,
    is_complete BOOLEAN CHECK (is_complete IN (0, 1)),
    FOREIGN KEY (objective_id) REFERENCES objective (id)
);

CREATE TABLE assignment_source (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kind TEXT NOT NULL UNIQUE
);

INSERT INTO assignment_source (id, kind)
VALUES (1, 'lesson'),
    (2, 'tutorial'),
    (3, 'article'),
    (4, 'video'),
    (5, 'lab'),
    (6, 'project'),
    (7, 'examination');

CREATE TABLE assignment_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    progress TEXT NOT NULL UNIQUE
);

INSERT INTO assignment_progress (id, progress)
VALUES (1, 'not started'),
    (2, 'on track'),
    (3, 'behind'),
    (4, 'on hold'),
    (5, 'completed');

CREATE TABLE assignment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    plan_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    synopsis TEXT,
    url_address TEXT,
    source_id INTEGER NOT NULL DEFAULT 1,
    progress_id INTEGER NOT NULL DEFAULT 1,
    notes TEXT,
    is_complete BOOLEAN CHECK (is_complete IN (0, 1)),
    FOREIGN KEY (plan_id) REFERENCES plan (id),
    FOREIGN KEY (source_id) REFERENCES assignment_source (id),
    FOREIGN KEY (progress_id) REFERENCES assignment_progress (id)
);

CREATE TABLE topic (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL UNIQUE
);

CREATE TABLE assignment_topic (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    topic_id INTEGER NOT NULL,
    assignment_id INTEGER NOT NULL,
    FOREIGN KEY (topic_id) REFERENCES topic (id),
    FOREIGN KEY (assignment_id) REFERENCES assignment (id)
);

INSERT INTO goal (id, title, synopsis, url_address, focus_level)
VALUES (
        1,
        'AWS Certified Cloud Practitioner',
        'The AWS Certified Cloud Practitioner validates foundational, high-level understanding of AWS Cloud, services, and terminology.',
        'https://aws.amazon.com/certification/certified-cloud-practitioner/',
        1
    ),
    (
        2,
        'Microsoft Certified: Azure Administrator Associate',
        'Demonstrate key skills to configure, manage, secure, and administer key professional functions in Microsoft Azure.',
        'https://learn.microsoft.com/en-us/certifications/azure-administrator/',
        2
    ),
    (
        3,
        'Microsoft Certified: Azure Solutions Architect Expert',
        'Subject matter expertise in designing cloud and hybrid solutions that run on Azure',
        'https://learn.microsoft.com/en-us/credentials/certifications/azure-solutions-architect/',
        2
    );