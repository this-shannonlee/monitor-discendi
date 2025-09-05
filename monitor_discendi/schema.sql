DROP TABLE if EXISTS goal;

DROP TABLE if EXISTS objective;

DROP TABLE if EXISTS plan;

DROP TABLE if EXISTS assignment_progress;

DROP TABLE if EXISTS assignment_source;

DROP TABLE if EXISTS assignment;

DROP TABLE if EXISTS topic;

DROP TABLE if EXISTS assignment_topic;

CREATE TABLE goal (
    id INTEGER PRIMARY key autoincrement,
    title text UNIQUE NOT NULL,
    synopsis text,
    url_address text,
    focus_level INTEGER NOT NULL CHECK (
        focus_level > 0
        AND focus_level <= 10
    ) DEFAULT 2,
    created TIMESTAMP NOT NULL DEFAULT current_timestamp,
    due_date TIMESTAMP,
    notes text,
    is_complete BOOLEAN CHECK (is_complete IN (0, 1)) DEFAULT 0
);

CREATE TABLE objective (
    id INTEGER PRIMARY key autoincrement,
    goal_id INTEGER NOT NULL,
    title text NOT NULL UNIQUE,
    synopsis text,
    url_address text,
    created TIMESTAMP NOT NULL DEFAULT current_timestamp,
    is_complete BOOLEAN CHECK (is_complete IN (0, 1)),
    FOREIGN key (goal_id) REFERENCES goal (id)
);

CREATE TABLE plan (
    id INTEGER PRIMARY key autoincrement,
    objective_id INTEGER NOT NULL,
    title text NOT NULL,
    synopsis text,
    url_address text,
    notes text,
    is_complete BOOLEAN CHECK (is_complete IN (0, 1)),
    FOREIGN key (objective_id) REFERENCES objective (id)
);

CREATE TABLE assignment_source (
    id INTEGER PRIMARY key autoincrement,
    kind text NOT NULL UNIQUE
);

INSERT INTO
    assignment_source (id, kind)
VALUES
    (1, 'lesson'),
    (2, 'tutorial'),
    (3, 'article'),
    (4, 'video'),
    (5, 'lab'),
    (6, 'project'),
    (7, 'examination');

CREATE TABLE assignment_progress (
    id INTEGER PRIMARY key autoincrement,
    progress text NOT NULL UNIQUE
);

INSERT INTO
    assignment_progress (id, progress)
VALUES
    (1, 'not started'),
    (2, 'on track'),
    (3, 'behind'),
    (4, 'on hold'),
    (5, 'completed');

CREATE TABLE assignment (
    id INTEGER PRIMARY key autoincrement,
    plan_id INTEGER NOT NULL,
    title text NOT NULL,
    synopsis text,
    url_address text,
    source_id INTEGER NOT NULL,
    progress_id INTEGER NOT NULL,
    notes text,
    is_digested BOOLEAN CHECK (is_complete IN (0, 1)),
    is_complete BOOLEAN CHECK (is_complete IN (0, 1)),
    FOREIGN key (plan_id) REFERENCES plan (id),
    FOREIGN key (source_id) REFERENCES assignment_source (id),
    FOREIGN key (progress_id) REFERENCES assignment_progress (id)
);

CREATE TABLE topic (
    id INTEGER PRIMARY key autoincrement,
    title text NOT NULL UNIQUE
);

CREATE TABLE assignment_topic (
    id INTEGER PRIMARY key autoincrement,
    topic_id INTEGER NOT NULL,
    assignment_id INTEGER NOT NULL,
    FOREIGN key (topic_id) REFERENCES topic (id),
    FOREIGN key (assignment_id) REFERENCES assignment (id)
);
