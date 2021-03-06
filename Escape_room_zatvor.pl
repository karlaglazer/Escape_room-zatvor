%program
:-dynamic pozicija/1,
          lok/2,
          off/1,
          on/1,
          imam/1,
          prolaz/2.
:-retractall(pozicija(_)).
:-retractall(lok(_,_)).
:-retractall(imam(_)).
:-retractall(off(_)).
:-retractall(on(_)).
:-retractall(prolaz(_,_)).

:-op(30,fx,prostor).
:-op(30,fx,pregledaj).
:-op(30,fx,idi_u).
:-op(30,fx,uzmi).
:-op(30,fx,pusti).
:-op(30,fx,pojedi).
:-op(30,fx,upali).
:-op(30,xfx,nalazi).
:-op(30,fx,sifra).

radnje(upali X):-upali(X),!.
radnje(idi_u X):-idi_u(X),!.
radnje(uzmi X):-uzmi(X),!.
radnje(vidi):-vidi,!.
radnje(inv):-inv,!.
radnje(pusti X):-pusti(X),!.
radnje(pregledaj X):-pregledaj(X),!.
radnje(pojedi X):-pojedi(X),!.
radnje(sifra X):-sifra(X),!.
radnje(opis):-opis,!.
radnje(kraj).

start:-write('Dobrodosli u escape room-zatvor.'),nl,
       write('Za više detalja unesite naredbu opis.'),nl,
       write('Upisite "kraj" ako zelite ranije izaci iz igre.'),nl,repeat,read(X),radnje(X), nl,zavrsi(X).
zavrsi(kraj):-write('Igra je gotova.').
zavrsi(X):-pozicija(izlaz)->write('Cestitam! Uspjesno ste zavrsili igru.').
opis:- write('Cilj igre je izaci iz zatvora. Naredbe u programu su: idi_u, upali, uzmi, vidi, pusti, pregledaj, pojedi, sifra i inv.'),nl.


prostor(celija).
prostor(izlaz).
prostor(ostava).
prostor(kuhinja).
prostor(kupaonica).
prostor(oruzarnica).
prostor(hodnik).
prostor(predvorje).

lok(krevet,celija).
lok(polica,celija).
lok(svjetiljka,polica).
lok(biljeznica,polica).
lok(baterije,krevet).
lok(stol,kuhinja).
lok(pecivo,stol).
lok(juha,stol).
lok(ormaric,kuhinja).
lok(tanjur,ormaric).
lok(7, tanjur).
lok(sef,oruzarnica).
lok(novac,sef).
lok(kartica,sef).
lok(1,kartica).
lok(kutija,ostava).
lok(kljuc,kutija).
lok(ormar,kupaonica).
lok(ogledalo,kupaonica).
lok(0,ogledalo).
lok(odjeca,ormar).
lok(slika,hodnik).
lok(9032,slika).


prolaz(celija,hodnik).
prolaz(ostava,hodnik).
prolaz(kuhinja,hodnik).
prolaz(kupaonica,hodnik).
prolaz(hodnik,predvorje).

dobro(juha).
dobro(pecivo).

pozicija(celija).

off(svjetiljka).


vrata(X,Y):-prolaz(X,Y).
vrata(X,Y):-prolaz(Y,X).

nalazi(X,Y):-lok(X,Y).
nalazi(X,Y):-lok(Z,Y),nalazi(X,Z).

stvari(Prostor):-lok(Stvar,Prostor),tab(2),stvar(Stvar,o(Opis,_)),write(Opis),write(' '),write(Stvar),nl,fail.
stvari(_).

prolazi(Prostor):-vrata(X,Prostor),tab(2),write(X),nl,fail.
prolazi(_).

vidi:-(pozicija(Ovdje),Ovdje\='hodnik')->(write('Trenutno ste u '),write(Ovdje), nl,
      write('U prostoriji se nalazi: '),nl,stvari(Ovdje), nl,
      write('Postoje vrata za: '),nl,prolazi(Ovdje));(write('Trenutno ste u hodniku.'),write('U prostoriji se nalazi: '),nl,write('Postoje vrata za: '),nl,
      prolazi(hodnik),write('Na zidu se nalazi sifrator koji otkljucava vrata oruzarnice.'),nl).
      

pregledaj(Stvar):-Stvar\='kartica',Stvar\='ogledalo',Stvar\='slika',Stvar\='sef',Stvar\='biljeznica',Stvar\='tanjur',Stvar\='ormar',lok(_,Stvar),write(Stvar), write(' sadrzi: '),nl,stvari(Stvar).
pregledaj(sef):-(pozicija(X),nalazi(sef,X),imam(kljuc))->(write(sef), write(' sadrzi: '),nl,stvari(sef));write('Sef je zakljucan. Nadite kljuc.'),nl,fail.
pregledaj(biljeznica):-write('U biljeznici se nalaze boje: plava, crvena, zuta,crvena.'),nl.
pregledaj(tanjur):-write('Na tanjuru plavom bojom pise broj '),lok(Broj,tanjur),write(Broj),nl.
pregledaj(ormar):-(pozicija(X),nalazi(ormar,X),imam(kartica))->(write(ormar), write(' sadrzi: '),nl,stvari(ormar));write('Ormar se otvara s karticom. Nadite karticu.'),nl,fail.
pregledaj(slika):-write('Na slici pise '),lok(Broj,slika), write(Broj),nl.
pregledaj(ogledalo):-write('Na ogledalu crvenom bojom pise broj '),lok(Broj,ogledalo),write(Broj),nl.
pregledaj(kartica):-write('Na kartici pise zuti broj '),lok(Broj,kartica),write(Broj),nl.

moze(Prostor):-(pozicija(X),vrata(X,Prostor))->(retract(pozicija(_)),asserta(pozicija(Prostor)));write('Ne postoje vrata za '),write(Prostor),nl,fail.
idi_u(Prostor):-Prostor\='izlaz',Prostor\='hodnik',Prostor\='predvorje',moze(Prostor),vidi.
idi_u(izlaz):-(imam(odjeca),imam(novac))->moze(izlaz);write('Za izlazak vam trebaju novac i odjeca.'),nl,fail.
idi_u(hodnik):-(imam(svjetiljka),on(svjetiljka))->moze(hodnik),vidi;write('Morate upaliti svjetiljku, u hodniku je mrak.'),nl,fail.
idi_u(predvorje):-nl,write('Na zidu se nalazi sifrator koji otkljucava izlaz iz zatvora.'),nl,moze(predvorje),vidi.


mogu(Stvar):-(pozicija(X),nalazi(Stvar,X))->((stvar(Stvar,o(_,Y)),Y<5)->(retract(lok(Stvar,_)),asserta(imam(Stvar)),write('Uzeli ste '),write(Stvar),nl);
              write('Pretesko je, ne mozete to uzeti.'),nl);write(Stvar),write(' nije u ovoj prostoriji.'),nl,fail.
uzmi(Stvar):-mogu(Stvar).

pustanje(Stvar):-imam(Stvar)->(retract(imam(Stvar)),pozicija(X),asserta(lok(Stvar,X)),write('Ispustili ste '),write(Stvar),nl);write('Nemate '),write(Stvar),nl,fail.
pusti(Stvar):-pustanje(Stvar).

pojedi(Hrana):-dobro(Hrana)->retract(imam(Hrana)),write('Pojeli ste '),write(Hrana),nl;write('Ne mozete to pojesti.'),nl,fail.
upali(X):-(imam(X),imam(baterije))->(retract(off(X)),retract(imam(baterije)),asserta(on(X)),write('Upalili ste '),write(X),nl);write('Ne mozete upaliti svjetiljku,trebaju vam baterije.'),nl,fail.

inv:-write('Imate: '),nl,popis.
popis:-imam(X),write(X),nl,fail.
popis.

sifra(X):-(pozicija(hodnik),not(prolaz(hodnik,oruzarnica)),X='9032')->(assertz(prolaz(hodnik,oruzarnica)),
           write('Otkljucali ste ulaz u oruzarnicu.'));((pozicija(predvorje),not(prolaz(predvorje,izlaz)),X='7010')->(assertz(prolaz(predvorje,izlaz)),
           write('Otkljucali ste izlaz iz zatvora.'));write('Kriva sifra.'),nl,fail).

stvar(krevet,o(metalni,25)).
stvar(polica,o(drvena,12)).
stvar(svjetiljka,o(mala,0.1)).
stvar(baterije,o(pune,0.05)).
stvar(pecivo,o(svjeze,0.1)).
stvar(juha,o(povrtna,0.1)).
stvar(ruksak,o(zeleni,0.5)).
stvar(sef,o(metalni,16)).
stvar(biljeznica,o(stara,0.02)).
stvar(kutija,o(plasticna,0.4)).
stvar(kljuc,o(zlatni,0.3)).
stvar(tanjur,o(tockasti,0.09)).
stvar(ormaric,o(bijeli,30)).
stvar(stol,o(metalni,15)).
stvar(novac,o(vrijedni,4)).
stvar(odjeca,o(cista,1)).
stvar(kartica,o(bijela_sa_zutom_oznakom,0.02)).
stvar(slika,o(crno-bijela,2)).
pregledaj 0stvar(ogledalo,o(razbijeno,1)).
stvar(ormar,o(stari,20)).

