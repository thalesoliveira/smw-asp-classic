
/*DATABASE SQLSERVER*/

CREATE TABLE t_country (
    country_id int IDENTITY(1,1) NOT NULL,
	country_name varchar(50) NOT NULL,
    country_pt_br varchar(50) NOT NULL,     
	country_initials_alfa_2 varchar(5),	
    country_active int DEFAULT (1),
	CONSTRAINT PK_t_country PRIMARY KEY (country_id),
);

CREATE TABLE t_state (
	state_id int IDENTITY(1,1) NOT NULL,
	state_name varchar(50) NOT NULL,
    state_initials varchar(5) ,
	country_id int NOT NULL,
	CONSTRAINT PK_t_state PRIMARY KEY (state_id),
	CONSTRAINT FK_state_country FOREIGN KEY (country_id) REFERENCES t_country (country_id)
);

CREATE TABLE t_type_user(
	type_user_id int IDENTITY(1,1) NOT NULL,
	type_user_description varchar(50) NOT NULL,
	type_user_active int NULL,
    CONSTRAINT PK_t_type_user PRIMARY KEY (type_user_id),
);
INSERT INTO t_type_user (type_user_description, type_user_active) VALUES ('ADMINISTRADOR', 1);

CREATE TABLE t_user (
	user_id int IDENTITY(1,1) NOT NULL,
	user_first_name varchar(50) NOT NULL,
	user_last_name varchar(50) NOT NULL,
	user_register_date datetime DEFAULT (getdate()),
	type_user_id int NOT NULL,
	country_id int NOT NULL,
	state_id int NOT NULL,
    contact_id int,
    address_id int,    
    user_login varchar(50) NULL,
	user_password varchar(50) NULL,    
    CONSTRAINT PK_t_user PRIMARY KEY (user_id),
    CONSTRAINT FK_user_country FOREIGN KEY(country_id) REFERENCES t_country (country_id),
    CONSTRAINT FK_user_state FOREIGN KEY(state_id) REFERENCES t_state (state_id)
);

INSERT INTO t_user (user_first_name, user_last_name,type_user_id,country_id,state_id,user_login,user_password) VALUES
('Admin', 'Root', 1 ,32, 26, 'teste@gmail.com', 'abcd1234');

CREATE TABLE t_address (
	address_id int IDENTITY(1,1) NOT NULL,
    address_name varchar(50) NOT NULL,
	address_city varchar(50) NOT NULL,
    address_street varchar(50),
    address_postal_code varchar(50),
    address_state_id int,
    country_id int,
	CONSTRAINT PK_t_address PRIMARY KEY (address_id),
);

CREATE TABLE t_contact (
	contact_id int IDENTITY(1,1) NOT NULL,
    contact_email varchar(50),
    contact_website varchar(50),
	CONSTRAINT PK_t_contact PRIMARY KEY (contact_id),
);

CREATE TABLE t_phone (
	phone_id int IDENTITY(1,1) NOT NULL,
    phone_number varchar(50),
    phone_ddi int,
    contact_id int,
    CONSTRAINT PK_t_phone PRIMARY KEY (phone_id),
);

CREATE TABLE t_coach (
	coach_id int IDENTITY(1,1) NOT NULL,
	coach_name varchar(50) NOT NULL,
    coach_description text,
	coach_nacionality_id int NOT NULL,
	coach_born_date varchar(50),	
	CONSTRAINT PK_t_coach PRIMARY KEY (coach_id),
	CONSTRAINT FK_coach_nacionality FOREIGN KEY (coach_nacionality_id) REFERENCES t_country (country_id)
);


CREATE TABLE t_team (
	team_id int IDENTITY(1,1) NOT NULL,
	team_name varchar(50) NOT NULL,
	team_description varchar(255),
	team_founded_year varchar(4)NULL,
    address_id int,
    contact_id int,
    coach_id int NOT NULL,
	CONSTRAINT PK_t_team PRIMARY KEY (team_id),
    CONSTRAINT FK_team_coach FOREIGN KEY (coach_id) REFERENCES t_coach (coach_id)
);


CREATE TABLE t_player (
	player_id int IDENTITY(1,1) NOT NULL,
	player_name varchar(50) NOT NULL,
    player_description varchar(50) NOT NULL,
	player_nacionality_id int NOT NULL,
	player_born_date varchar(50),
    player_age int,
    player_position varchar(50),    
    player_weight int,
    player_height int,
	CONSTRAINT PK_t_player PRIMARY KEY (player_id),
	CONSTRAINT FK_player_nacionality FOREIGN KEY (player_nacionality_id) REFERENCES t_country (country_id)
);

CREATE TABLE t_position_player (
	position_player_id  int IDENTITY(1,1) NOT NULL,
    position_player_name varchar (50) NOT NULL,
	CONSTRAINT PK_t_postition_player PRIMARY KEY (position_player_id)	
);

CREATE TABLE t_team_player (
	team_player_id  int IDENTITY(1,1) NOT NULL,
	team_id  int,
    player_id int,
    team_player_shirt int,
    team_player_match int,
    team_player_goal int
	CONSTRAINT PK_t_team_player PRIMARY KEY (team_player_id)	
);

