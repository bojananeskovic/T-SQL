/*1.
Napisati funkciju LokacijaKonf koja za prosledjen 
id konferencije vraca 
naziv lokacije na kojoj se konferencija odrzava. 
Ako nema podatka o lokaciji vraca 'Nije poznato!'
*/

IF OBJECT_ID('Konferencija.LokacijaKonf', 'FN') IS NOT NULL
	DROP FUNCTION Konferencija.LokacijaKonf;
GO
CREATE FUNCTION Konferencija.LokacijaKonf 
(
	@konf as int
) 
RETURNS varchar(30) 
as
begin
  declare @nazivL as varchar(30); 
  set @nazivL = (SELECT naziv 
  from Konferencija.konferencija k left join Konferencija.odrzava_se_u o on k.id_konf=o.id_konf
									left join Konferencija.lokacija l on l.id_lokacije=o.id_lokacije
  where k.id_konf= @konf);
  if @nazivL is null 
	  begin
    set @nazivL = 'Nije poznato!';
      return (@nazivL);
      end
  else
	return (@nazivL);
return (@nazivL);
end;
go

select Konferencija.LokacijaKonf(1);
select Konferencija.LokacijaKonf(11);  
go;

/*2.
Napisati funkciju KotizKonf koja za prosledjen 
id konferencije vraca 
iznos povlascene kotizacije.
*/

IF OBJECT_ID('Konferencija.KotizKonf', 'FN') IS NOT NULL
	DROP FUNCTION Konferencija.KotizKonf;
GO
CREATE FUNCTION Konferencija.KotizKonf 
(
	@konfID as int
) 
RETURNS numeric(10, 2)
as
begin
  declare @iznos as numeric(10, 2); 
  set @iznos = (select suma from Konferencija.konferencija k inner join Konferencija.kotizacija kt on k.id_konf=kt.id_konf
				where kt.id_konf=@konfID and vrsta='povlascena');
return (@iznos);
end;
go

print 'Iznos povlascene kotizacije je: ' + cast(Konferencija.KotizKonf(1) as varchar);
print 'Iznos povlascene kotizacije je: ' + cast(Konferencija.KotizKonf(4) as varchar); 
go;
