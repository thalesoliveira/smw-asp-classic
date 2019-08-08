
/*DATABASE SQLSERVER*/

CREATE TABLE t_country (
    country_id int IDENTITY(1,1) NOT NULL,
	country varchar(50) NOT NULL,
    country_pt_br varchar(50) NOT NULL,     
	initials_alfa_2 varchar(5),	
    active int DEFAULT (1),
	CONSTRAINT PK_t_country PRIMARY KEY (country_id),
);

CREATE TABLE t_state (
	state_id int IDENTITY(1,1) NOT NULL,
	state varchar(50) NOT NULL,
    initials varchar(5) ,
	country_id int NOT NULL,
	CONSTRAINT PK_t_state PRIMARY KEY (state_id),
	CONSTRAINT FK_state_country FOREIGN KEY (country_id) REFERENCES t_country (country_id)
);

CREATE TABLE t_coach (
	coach_id int IDENTITY(1,1) NOT NULL,
	coach varchar(50) NOT NULL,
    description varchar(50) NOT NULL,
	nacionality_id int NOT NULL,
	born_dt varchar(50),	
	CONSTRAINT PK_t_coach PRIMARY KEY (coach_id),
	CONSTRAINT FK_coach_nacionality FOREIGN KEY (nacionality_id) REFERENCES t_country (country_id)
);


CREATE TABLE t_team (
	team_id int IDENTITY(1,1) NOT NULL,	
	team varchar(50) NOT NULL,
	description varchar(255),
	founded_year varchar(50)NULL,	
    country_id int NOT NULL,
    state_id int NOT NULL,	
    address_id int NOT NULL,	
    contact_id int NOT NULL,
    coach_id int NOT NULL,
	CONSTRAINT PK_t_team PRIMARY KEY (id),
    CONSTRAINT FK_team_country FOREIGN KEY (country_id) REFERENCES t_country (country_id),
    CONSTRAINT FK_team_state FOREIGN KEY (state_id) REFERENCES t_state (state_id),
    CONSTRAINT FK_team_address FOREIGN KEY (address_id) REFERENCES t_address (address_id),
    CONSTRAINT FK_team_contact FOREIGN KEY (contact_id) REFERENCES t_contact (contact_id),
    CONSTRAINT FK_team_coach FOREIGN KEY (coach_id) REFERENCES t_coach (coach_id)
);

CREATE TABLE t_user (
	id int IDENTITY(1,1) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	dt_register datetime NULL,
	type_user_id int NOT NULL,
	country_id int NOT NULL,
	state_id int NOT NULL,
	city varchar(50) NULL,
	mail varchar(50) NULL,
	password_key varchar(50) NULL,
    CONSTRAINT PK_t_user PRIMARY KEY (id),
);

ALTER TABLE t_user ADD CONSTRAINT FK_user_country FOREIGN KEY(country_id) REFERENCES t_country (country_id);
ALTER TABLE t_user ADD CONSTRAINT FK_user_state FOREIGN KEY(state_id) REFERENCES t_state (state_id);
ALTER TABLE t_user ADD CONSTRAINT FK_user_type FOREIGN KEY(type_user_id) REFERENCES t_type_user (id);
ALTER TABLE t_user ADD DEFAULT (getdate()) FOR dt_register;

CREATE TABLE t_type_user(
	id int IDENTITY(1,1) NOT NULL,
	type_description varchar(50) NOT NULL,
	active int NULL,
    CONSTRAINT PK_t_type_user PRIMARY KEY (id),
);

CREATE TABLE t_address (
	address_id int IDENTITY(1,1) NOT NULL,
    address varchar(50) NOT NULL,
	city_id varchar(50) NOT NULL,
    street varchar(50),
    postal_code varchar(50),
    state_id int,
    country_id int,
	CONSTRAINT PK_t_address PRIMARY KEY (address_id),
);

CREATE TABLE t_contact (
	contact_id int IDENTITY(1,1) NOT NULL,
    email varchar(50),
    site varchar(50),
	phone varchar(50) NOT NULL,
    ddi varchar(50),    
	CONSTRAINT PK_t_address PRIMARY KEY (contact_id),
);