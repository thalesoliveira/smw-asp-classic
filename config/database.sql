
/*DATABASE SQLSERVER*/

use smw;

CREATE TABLE t_country (
	id_country int IDENTITY(1,1) NOT NULL,
	desc_name varchar(50) NOT NULL,
    desc_country varchar(50) NOT NULL,
	desc_initials int,
	dt_register datetime DEFAULT (getdate()) NOT NULL,
	CONSTRAINT PK_t_country PRIMARY KEY (id_country),
);

CREATE TABLE t_state (
	id_state int IDENTITY(1,1) NOT NULL,	
	desc_name varchar(50) NOT NULL,
    desc_state varchar(50) NOT NULL,
	desc_initials int,
	dt_register datetime DEFAULT (getdate()) NOT NULL,
	id_country int NOT NULL,
	CONSTRAINT PK_t_state PRIMARY KEY (id_state),
	CONSTRAINT FK_state_country FOREIGN KEY (id_country) REFERENCES t_country (id_country)
);

CREATE TABLE t_city (
	id_city int IDENTITY(1,1) NOT NULL,
	id_state int NOT NULL,
    desc_name varchar(50) NOT NULL,
	desc_city varchar(50) NOT NULL,
	desc_initials int,
	dt_register datetime DEFAULT (getdate()) NOT NULL,
	CONSTRAINT PK_t_city PRIMARY KEY (id_city),
	CONSTRAINT FK_city_state FOREIGN KEY (id_state) REFERENCES t_state (id_state)	
);

CREATE TABLE t_coach (
	id_coach int IDENTITY(1,1) NOT NULL,
	desc_name varchar(50) NOT NULL,
    desc_coach varchar(50) NOT NULL,
	id_nacionality int NOT NULL,
	dt_born varchar(50),
	dt_register datetime DEFAULT (getdate()) NOT NULL,
	CONSTRAINT PK_t_coach PRIMARY KEY (id_coach),
	CONSTRAINT FK_coach_nacionality FOREIGN KEY (id_nacionality) REFERENCES t_country (id_country)
);


CREATE TABLE t_team (
	id_team int IDENTITY(1,1) NOT NULL,	
	desc_name varchar(50) NOT NULL,
	desc_team varchar(255),
	desc_year_founded varchar(50)NULL,
	id_country int NOT NULL,
	id_state int NOT NULL,
	id_city int NOT NULL,
	id_coach int NOT NULL,    
	desc_site varchar(50),
    desc_contact varchar(50),
    desc_email varchar(50),
	CONSTRAINT PK_t_team PRIMARY KEY (id_team),
    CONSTRAINT FK_team_country FOREIGN KEY (id_country) REFERENCES t_country (id_country),
    CONSTRAINT FK_team_state FOREIGN KEY (id_state) REFERENCES t_state (id_state),
    CONSTRAINT FK_team_city FOREIGN KEY (id_city) REFERENCES t_city (id_city)    
);

CREATE TABLE t_user (
	id_user int IDENTITY(1,1) NOT NULL,
	desc_name varchar(50) NOT NULL,
    desc_address varchar(50),
    desc_email varchar(50),
    desc_login varchar(50),
    desc_password varchar(50),
    id_country int NOT NULL,
	id_state int NOT NULL,
	id_city int NOT NULL,    
    id_active int DEFAULT (1) NOT NULL,
    dt_register datetime DEFAULT (getdate()) NOT NULL,    
	CONSTRAINT PK_t_user PRIMARY KEY (id_user),    
);