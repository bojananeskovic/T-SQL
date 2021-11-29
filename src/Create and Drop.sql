drop schema Konferencija;

drop table Konferencija.ucesnik;
drop table Konferencija.konferencija;
drop table Konferencija.lokacija;
drop table Konferencija.odrzava_se_u;
drop table Konferencija.zaposleni;
drop table Konferencija.radi_na;
drop table Konferencija.donator;
drop table Konferencija.donacija;
drop table Konferencija.kotizacija;
drop table Konferencija.ucestvuje_na;

drop sequence Konferencija.ucesnik_seq
drop sequence Konferencija.konferencija_seq
drop sequence Konferencija.lokacija_seq

create schema Konferencija;

--tabela ucesnik
create table Konferencija.ucesnik
(
	ucesnik_id numeric(8) not null,
	ime varchar(25) not null,
	srednje_s varchar(2) not null,
	prezime varchar(25) not null,
	email varchar(25) not null,
	lozinka varchar(25) not null,
	institucija varchar(50),
	telefon varchar(20),
	adresa varchar(50) not null,
	constraint PK_ucesnik primary key(ucesnik_id) 
)

create sequence Konferencija.ucesnik_seq
start with 1
increment by 1

--tabela konferencija
create table Konferencija.konferencija
(
	id_konf numeric(8) not null,
	naz_konf varchar(25) not null,
	datum date not null,
	max_br_autora numeric(6) not null check(max_br_autora>0),
	rok_pred_abs date not null,
	prod_rok_abs date,
	rok_pred_rada date not null,
	prod_rok_rad date,
	rok_dor_rada date not null,
	constraint PK_konferencija primary key(id_konf)
)

create sequence Konferencija.konferencija_seq
start with 1
increment by 1

--tabela lokacija
create table Konferencija.lokacija
(
	id_lokacije numeric(8) not null,
	naziv varchar(50) not null,
	adresa varchar(50) not null,
	telefon varchar(20),
	email varchar(25),
	constraint PK_lokacija primary key(id_lokacije)
)

create sequence Konferencija.lokacija_seq
start with 1
increment by 1

--tabela odrzava_se_u
create table Konferencija.odrzava_se_u
(
	id_konf numeric(8) not null,
	id_lokacije numeric(8) not null,
	constraint PK_odrzava_se_u primary key(id_konf, id_lokacije),
	constraint FK_odrzava_se_u_konferencija foreign key(id_konf) references Konferencija.konferencija(id_konf),
	constraint FK_odrzava_se_u_lokacija foreign key(id_lokacije) references Konferencija.lokacija(id_lokacije)
)

--tabela zaposleni
create table Konferencija.zaposleni
(
	zaposleni_id numeric(8) not null,
	ime varchar(25) not null,
	srednje_s varchar(2) not null,
	prezime varchar(25) not null,
	email varchar(25) not null,
	lozinka varchar(25) not null,
	institucija varchar(50) not null,
	telefon varchar(20),
	adresa varchar(50) not null,
	constraint PK_zaposleni primary key(zaposleni_id) 
)

--tabela radi_na
create table Konferencija.radi_na
(
	zaposleni_id numeric(8) not null,
	id_konf numeric(8) not null,
	uloga varchar(25) not null,
	constraint PK_radi_na primary key(uloga, zaposleni_id, id_konf),
	constraint FK_radi_na_zaposleni foreign key(zaposleni_id) references Konferencija.zaposleni(zaposleni_id),
	constraint FK_radi_na_konferencija foreign key(id_konf) references Konferencija.konferencija(id_konf)
)

--tabela donator
create table Konferencija.donator
(
	donator_id numeric(8) not null,
	naziv varchar(25) not null,
	email varchar(25) not null,
	zaposleni_id numeric(8) not null,
	id_konf numeric(8) not null,
	uloga varchar(25) not null,
	constraint PK_donator primary key(donator_id),
	constraint FK_donator_radi_na foreign key (uloga, zaposleni_id, id_konf) references Konferencija.radi_na(uloga, zaposleni_id, id_konf)
)

--tabela donacija
create table Konferencija.donacija
(
	donacija_id numeric(8) not null,
	vrednost numeric(10, 2),
	datum date,
	donator_id numeric(8) not null,
	zaposleni_id numeric(8) not null,
	id_konf numeric(8) not null,
	uloga varchar(25) not null,
	id_konferencije numeric(8) not null,
	constraint PK_donacija primary key(donacija_id),
	constraint FK_donacija_donator foreign key(donator_id) references Konferencija.donator(donator_id), 
	constraint FK_donacija_radi_na foreign key (uloga, zaposleni_id, id_konf) references Konferencija.radi_na(uloga, zaposleni_id, id_konf),
	constraint FK_donacija_konferencija foreign key (id_konferencije) references Konferencija.konferencija(id_konf)
)

--tabela kotizacija
create table Konferencija.kotizacija
(
	kotizacija_id numeric(8) not null,
	br_mod numeric(8),
	poz_na_br varchar(25),
	suma numeric(10, 2) check(suma>0),
	valuta varchar(25),
	vrsta varchar(25) not null,
	id_konf numeric(8),
	constraint PK_kotizacija primary key (kotizacija_id),
	constraint FK_kotizacija_konferencija foreign key (id_konf) references Konferencija.konferencija(id_konf)
)

--tabela ucestvuje_na
create table Konferencija.ucestvuje_na
(
	student bit not null,
	uloga_u varchar(25) not null check(uloga_u in ('S', 'R', 'P')),
	odgovor bit,
	datum date,
	ucesnik_id numeric(8) not null,
	id_konf numeric(8) not null,
	kotizacija_id numeric(8) not null,
	uloga varchar(25) not null,
	zaposleni_id numeric(8) not null,
	id_konferencije numeric(8) not null,
	constraint PK_ucestvuje_na primary key (ucesnik_id, id_konf),
	constraint FK_ucestvuje_na_ucesnik foreign key (ucesnik_id) references Konferencija.ucesnik(ucesnik_id),
	constraint FK_ucestvuje_na_konferencija foreign key (id_konf) references Konferencija.konferencija(id_konf),
	constraint FK_ucestvuje_na_radi_na foreign key (uloga, zaposleni_id, id_konferencije) references Konferencija.radi_na(uloga, zaposleni_id, id_konf),
	constraint FK_ucestvuje_na_kotizacija foreign key (kotizacija_id) references Konferencija.kotizacija(kotizacija_id)
)