DROP database if exists pluto_realty;
CREATE DATABASE pluto_realty;
USE pluto_realty;
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

CREATE TABLE address(
	address_id numeric(5,0),
	street varchar(25),
	city varchar(15),
	state varchar(2),
	zip_code numeric(5,0),
	unit_number numeric(5,0),
	primary key (address_id)
);

CREATE TABLE person_corporation(
	person_id  numeric(5,0),
	name varchar(80),
	address_id numeric(5,0),
	primary key (person_id),
	foreign key (address_id) references address(address_id) on delete cascade
);

CREATE TABLE Employe(
	employe_id numeric(5,0),
	hired_date numeric(8,0),
	primary key (employe_id),
	foreign key (employe_id) references person_corporation(person_id) on delete cascade
);

CREATE TABLE partner(
	employe_id numeric(5,0),
	primary key (employe_id),
	foreign key (employe_id) references Employe(employe_id) on delete cascade
);

CREATE TABLE owner(
	owner_id numeric(5,0),
	partner_id numeric(5,0),
	primary key (owner_id),
	foreign key (owner_id) references person_corporation(person_id) on delete cascade,
	foreign key (partner_id) references partner(employe_id) on delete set null
);

CREATE TABLE properties(
	property_number numeric(15,0),
	address_id numeric(5,0),
	property_type varchar(15),
	area numeric(12,2),
	monthly_rent numeric(12,2),
	management_fee numeric(12,2),
	ads numeric(1,0),
	primary key (property_number),
	foreign key (address_id) references address(address_id) on delete cascade
);



CREATE TABLE associate(
	employe_id numeric(5,0),
	property_number numeric(15,0),
	primary key (employe_id, property_number),
	foreign key (employe_id) references Employe(employe_id) on delete cascade,
	foreign key (property_number) references properties(property_number)
);

CREATE TABLE supervisor(
	supervisor_id numeric(5,0),
	subordinate_id numeric(5,0),
	primary key (supervisor_id, subordinate_id),
	foreign key (supervisor_id) references Employe(employe_id) on delete cascade,
	foreign key (subordinate_id) references Employe(employe_id) on delete cascade
);

CREATE TABLE email(
	person_id numeric(5,0),
	email_address varchar(30),
	primary key (person_id, email_address),
	foreign key (person_id) references person_corporation(person_id) on delete cascade
);

CREATE TABLE phone(
	person_id numeric(5,0),
	phone_number numeric(10,0),
	phone_type varchar(15),
	primary key (person_id, phone_number),
	foreign key (person_id) references person_corporation(person_id) on delete cascade
);



CREATE TABLE owns(
	owner_id numeric(5,0),
	property_number numeric(15,0),
	primary key (owner_id, property_number),
	foreign key (owner_id) references owner(owner_id) on delete cascade,
	foreign key (property_number) references properties(property_number) on delete cascade
);

CREATE TABLE clients(
	client_id numeric(5,0),
	max_rent numeric(12,2),
	primary key (client_id),
	foreign key (client_id) references person_corporation(person_id) on delete cascade
);

CREATE TABLE preference(
	client_id numeric(5,0),
	property_number numeric(15,0),
	primary key (client_id, property_number),
	foreign key (client_id) references clients(client_id) on delete cascade,
	foreign key (property_number) references properties(property_number) on delete cascade
);

CREATE TABLE viewing(
	employe_id numeric(5,0),
	client_id numeric(5,0),
	property_number numeric(15,0),
	primary key (employe_id, client_id, property_number),
	foreign key (employe_id) references associate(employe_id) on delete cascade,
	foreign key (client_id) references clients(client_id) on delete cascade,
	foreign key (property_number) references properties(property_number) on delete cascade
);

CREATE TABLE viewing_date(
	client_id numeric(5,0),
	property_number numeric(15,0),
	date_ numeric(8,0),
	time_ numeric(6,0),
	primary key (client_id, property_number),
	foreign key (client_id) references viewing(client_id) on delete cascade,
	foreign key (property_number) references properties(property_number) on delete cascade
);

CREATE TABLE lease(
	client_id numeric(5,0),
	property_number numeric(15,0),
	rent numeric(12,2),
	date_ numeric(8,0),
	deposit numeric(12,2),
	duration numeric(5,0),
	start_date numeric(8,0),
	end_date numeric(8,0),
	foreign key (client_id) references clients(client_id) on delete cascade,
	foreign key (property_number) references properties(property_number) on delete cascade
);
