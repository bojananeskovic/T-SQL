/*1.
Napisati proceduru KonfDatum koja ce na osnovu 
naziva konferencije vratiti datum njenog odrzavanja.
*/

IF OBJECT_ID('Konferencija.KonfDatum', 'P') IS NOT NULL
DROP PROCEDURE Konferencija.KonfDatum
GO

CREATE PROC Konferencija.KonfDatum
	@datum as DATE output,
	@nazivK as VARCHAR(25)
AS
BEGIN
	SET @datum = (SELECT datum FROM Konferencija.konferencija
					WHERE naz_konf = @nazivK);
END

DECLARE @datum as date;
EXEC Konferencija.KonfDatum  @datum OUTPUT,'WATFOI'
SELECT @datum;

DECLARE @datum1 as date;
EXEC Konferencija.KonfDatum  @datum1 OUTPUT,'SmileCode'
SELECT @datum1;

/*2.
Napisati proceduru koja za prosledjenu sifru konferencije (id_konf) 
ispisuje podatke o ucesnicima koji ucestvuju na njoj i to na sledeci nacin:
Na konferenciji <naziv konferencije> ucestvuju sledeci ucesnici: 
<redni broj> <ime i prezime ucesnika>
Ukupno ucesnika: <br.ucesnika>
Ako nema ucesnika koji ucestvuju na toj konferenciji, ispisati 'Nema ucesnika'.
*/


if OBJECT_ID('Konferencija.UcesnikKonf', 'P') is not null
	drop proc Konferencija.UcesnikKonf;
GO
create proc Konferencija.UcesnikKonf
	@id_konf AS INT
AS
BEGIN
		declare @ucesnik_id as int
		declare @ime as varchar(25)
		declare @prezime as varchar(25)
		declare @rbr as int
		declare @ukupnoUcesnika as numeric(5)
		declare @konf as varchar (25)

		set @konf = (select naz_konf from Konferencija.konferencija where id_konf=@id_konf);
		set @ukupnoUcesnika=(select count(u.ucesnik_id)
							from Konferencija.ucesnik u left join Konferencija.ucestvuje_na un on u.ucesnik_id=un.ucesnik_id
							where un.id_konf=@id_konf);
	IF @ukupnoUcesnika >0
		begin
				print 'Na konferenciji ' + @konf + ' ucestvuju sledeci ucesnici:'
				set @rbr=0;

			DECLARE ucesnici_cursor CURSOR FAST_FORWARD FOR
					SELECT u.ucesnik_id, ime, prezime
					FROM Konferencija.ucesnik u left join Konferencija.ucestvuje_na un on u.ucesnik_id=un.ucesnik_id
					where id_konf=@id_konf;

			OPEN ucesnici_cursor;
				set @rbr=1;
			FETCH NEXT FROM ucesnici_cursor INTO @ucesnik_id, @ime, @prezime
			WHILE @@FETCH_STATUS = 0 
				BEGIN
					print concat(@rbr, ' ' ,@ime, ' ', @prezime)
					FETCH NEXT FROM ucesnici_cursor INTO @ucesnik_id, @ime, @prezime
					set @rbr = @rbr+1;
				END;
			CLOSE ucesnici_cursor;
			DEALLOCATE ucesnici_cursor;

			print 'Ukupno ucesnika: ' + CAST(@ukupnoUcesnika AS VARCHAR(25))
		end
	else
		print ('Nema ucesnika!');
	
end
GO

execute Konferencija.UcesnikKonf 1
execute Konferencija.UcesnikKonf 11