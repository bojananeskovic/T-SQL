/*1.
Izlistati vrednost najvece donacije i naziv konferencije za koju je namenjena.
*/

select top 1 d.vrednost as 'Vrednost donacije', k.naz_konf as 'Naziv konferencije'
from Konferencija.donacija d
inner join Konferencija.konferencija k on d.id_konferencije=k.id_konf
where d.vrednost is not null
order by d.vrednost desc


/*2.
Izlistati podatke o konferencijama kao: 
Naziv, Datum, Maksimalan broj autora, Lokacija 
koji ce prikazivati respektivno: 
naziv konferencije, datum odrzavanja, maksimalan broj autora i 
lokaciju odrzavanja za sve konferencije 
za koje je maksimalan broj autora veci od 3.  
*/

select naz_konf 'Naziv', datum 'Datum', max_br_autora 'Maksimalan broj autora', naziv 'Lokacija'
from Konferencija.konferencija k
left join Konferencija.odrzava_se_u o on k.id_konf=o.id_konf
left join Konferencija.lokacija l on l.id_lokacije=o.id_lokacije
where max_br_autora>3

/*3.
Za sve zaposlene koji dolaze sa ETF Beograd izlistati njihovo ime, prezime, instituciju i broj konferencija na kojima rade.
Sortirati rastuce po imenu.
*/

select ime 'Ime', prezime 'Prezime', institucija 'Institucija', count(k.id_konf) 'Broj konferencija'
from Konferencija.zaposleni z
left join Konferencija.radi_na r on z.zaposleni_id=r.zaposleni_id
left join Konferencija.konferencija k on k.id_konf=r.id_konf
group by ime, prezime, institucija
having institucija='ETF Beograd'
order by ime


/*4.
Izlistati podatke o ucesnicima kao: 
1.  Ime i prezime - ime i prezime ucesnika,
2.	Broj telefona - broj telefona ucesnika ukoliko ga ima, a u suprotnom ispisati 'Nepoznato',
3.	Vrsta kotizacije - vrsta kotizacije ucesnika na konferenciji,
4.  Iznos kotizacije - iznos kotizacije za ucesnika
za sve ucesnike cije ime pocinje na slovo J.
*/

select concat(ime,' ',prezime) as 'Ime i prezime', ISNULL(telefon, 'Nepoznato') 'Broj telefona', vrsta 'Vrsta kotizacije', suma 'Iznos kotizacije'
from Konferencija.ucesnik u
left join Konferencija.ucestvuje_na un on u.ucesnik_id=un.ucesnik_id
left join Konferencija.kotizacija k on un.kotizacija_id=k.kotizacija_id
where ime like 'J%'


/*5.
Za sve konferencije koje se odrzavaju nakon 'OPEN IT' konferencije izlistati njihov naziv i visinu redovne kotizacije.
*/

select naz_konf 'Naziv konferencije', suma 'Iznos redovne kotizacije'
from Konferencija.konferencija kf
left join Konferencija.kotizacija kt on kt.id_konf=kf.id_konf
where datum>(select datum from Konferencija.konferencija where naz_konf='OPEN IT') and vrsta='redovna'