CREATE TABLE users (
           uid INT(20) NOT NULL,
    created_at INT(10) NOT NULL,
    PRIMARY KEY (uid)
);

CREATE TABLE vinfo (
    vid   VARCHAR(20)  NOT NULL,
    title VARCHAR(250) NOT NULL,
    PRIMARY KEY (vid)
);

CREATE TABLE usertags (
    uid INT(20)     NOT NULL,
    vid VARCHAR(20) NOT NULL,
    tag VARCHAR(64) NOT NULL,
    md5 VARCHAR(32) NOT NULL,
    PRIMARY KEY (md5)
);

