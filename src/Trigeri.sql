/*1.
Kreirati triger koji prilikom unosa podataka u tabelu UCESTVUJE_NA proverava
o kojoj kotizaciji se radi i ukoliko je u pitanju povlascena, uslov je da ucesnik bude student,
a ukoliko je rec o redovnoj kotizaciji, onda ucesnik nije student, vec placa punu cenu.
Pozvani ucesnici su oslobodjeni kotizacije.
*/

IF OBJECT_ID('Konferencija.KotizUcesnik', 'TR') IS NOT NULL
DROP TRIGGER Konferencija.KotizUcesnik;
GO

create trigger KotizUcesnik
on Konferencija.ucestvuje_na
after insert
as
begin
	declare @ucesnik_id numeric(8)=(select ucesnik_id from inserted)
	declare @uloga varchar(25)=(select uloga_u from inserted)
	declare @student bit=(select student from inserted)
	declare @kot_id int=(select kotizacija_id from inserted)
	declare @kotizacija varchar(25)=(select vrsta from Konferencija.kotizacija k inner join Konferencija.ucestvuje_na u on k.kotizacija_id=u.kotizacija_id
										where ucesnik_id=@ucesnik_id and uloga_u=@uloga and u.kotizacija_id=@kot_id)

	if(@kotizacija='redovna')
		begin
		if(@student!=0)
			begin
				update ucestvuje_na set student=0 where ucesnik_id=@ucesnik_id
			end
		print 'Redovnu kotizaciju placaju redovni ucesnici i slusaoci, a ne studenti!'
		end
	else if(@kotizacija='povlascena')
		begin
		if(@student=0)
			begin
				update ucestvuje_na set student=1 where ucesnik_id=@ucesnik_id
			end
		print 'Studenti samo imaju pravo na povlascenu kotizaciju!'
		end
	else
		begin
		if(@uloga!='P')
			begin
				update ucestvuje_na set uloga_u='P' where ucesnik_id=@ucesnik_id
			end
		print 'Pozvani ucesnici ne placaju kotizaciju!'
		end
end

insert into Konferencija.ucestvuje_na(student, uloga_u, odgovor, datum, ucesnik_id, id_konf, kotizacija_id, uloga, zaposleni_id, id_konferencije)
values(0, 'S', 1, null, 7, 1, 21, 'organizator', 1, 1)

insert into Konferencija.ucestvuje_na(student, uloga_u, odgovor, datum, ucesnik_id, id_konf, kotizacija_id, uloga, zaposleni_id, id_konferencije)
values(1, 'R', null, CAST('20-OCT-2020'AS DATE), 8, 2, 3, 'organizator', 3, 2)



/*2.
Kreirati triger RegUcesnik koji obezbedjuje da ucesnika koji ucestvuje
na odredjenoj konferenciji registruje samo zaposleni koji radi na istoj toj konferenciji. U suprotnom
ispisati: 'Nije dozvoljeno. Greska!'
*/

IF OBJECT_ID('Konferencija.RegUcesnik', 'TR') IS NOT NULL
DROP TRIGGER Konferencija.RegUcesnik;
GO

CREATE TRIGGER Konferencija.RegUcesnik
ON Konferencija.ucestvuje_na
INSTEAD OF INSERT, UPDATE
AS
BEGIN

		
DECLARE @konf1 as numeric(8) = (SELECT id_konf from INSERTED);
DECLARE @konf2 as numeric(8) = (SELECT id_konferencije from INSERTED);


        IF NOT EXISTS(SELECT * FROM DELETED)
            begin
                if(@konf1 <> @konf2)
	            begin
		            RAISERROR('Nije dozvoljeno. Greska!', 16, 0);
		            rollback transaction;
                end
            end
        ELSE
            begin
                if(@konf1 <> @konf2)
			    begin
				    RAISERROR('Nije dozvoljeno. Greska!', 16, 0);
		            rollback transaction;
		        end
            end
    END
	GO

UPDATE Konferencija.ucestvuje_na 
SET id_konf= 2, id_konferencije =3 
WHERE uloga_u='S'

insert into Konferencija.ucestvuje_na(student, uloga_u, odgovor, datum, ucesnik_id, id_konf, kotizacija_id, uloga, zaposleni_id, id_konferencije)
values(0, 'R', null, CAST('16-JAN-2020'AS DATE), 5, 5, 1, 'organizator', 1, 1)

insert into Konferencija.ucestvuje_na(student, uloga_u, odgovor, datum, ucesnik_id, id_konf, kotizacija_id, uloga, zaposleni_id, id_konferencije)
values(0, 'R', null, CAST('16-JAN-2020'AS DATE), 9, 1, 1, 'organizator', 1, 1)
