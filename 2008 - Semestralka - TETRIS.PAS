program tetris;{v1.0}

uses crt;

const sirka=10;   {velkost hracej plochy}
      dlzka=20;
      stlpec=5;  {od ktoreho riadku a stlpca sa zobrazi hracia plocha}
      riadok=2;  {pouziva sa pri gotoxy}

type hracia_plocha = array[1..sirka,1..dlzka] of char;
     ponuka= array[1..10] of string[20];
     suradnice= array[1..4] of record
                 x: integer;
                 y: integer;
                end;

var plocha: hracia_plocha;
    sur,spodna_sur,prech_sur,otocena_sur: suradnice;
    dielik,pocet_spodnych_dielikov,level: byte;
    i,j,k,pocet,v,rozh,score,prvy_riadok,lhx,lhy,temp,poc_otoc: integer;
    koniec_hry,ulozeny_dielik,mozno_posunut,treba_upravit: boolean;
    save: file of hracia_plocha;
    p:ponuka;
    klavesa: char;

procedure menu(stlpec,riadok:integer; p:ponuka; pocet:integer; var vyber:integer);
 var z:char;

 procedure ramik;
  var i,j,d:integer;
  begin
   d:=length(P[1]);
   textbackground(blue); textcolor(lightgray);
   gotoxy(stlpec,riadok); write('Ú'); for i:=1 to d do write('Ä'); write('¿');
   for i:=1 to pocet do
    begin
     gotoxy(stlpec,riadok+i); write('³'); gotoxy(stlpec+d+1,riadok+i); write('³');
    end;
   gotoxy(stlpec,riadok+pocet+1); write('À'); for j:=1 to d do write('Ä'); write('Ù');
  end;

 procedure volba(cislo,pozadie,pismo:integer);
  begin
   textbackground(pozadie); textcolor(pismo);
   gotoxy(stlpec+1,riadok+cislo); write(P[cislo]);
  end;

 begin
  ramik;
  for i:=1 to pocet do volba(i,blue,lightgray);
  vyber:=1;
  repeat
   volba(vyber,red,yellow);
   z:=readkey;
   if z=#0 then
    begin
     z:=readkey;
     volba(vyber,blue,lightgray);
     case z of
      #72: if vyber>1 then vyber:=vyber-1 else vyber:=pocet;
      #80: if vyber<pocet then vyber:=vyber+1 else vyber:=1;
     end;
    end;
  until z in[#13,#27];
  if z=#27 then vyber:=0 else rozh:=vyber;
  textbackground(black); textcolor(lightgray);
 end;

procedure vypis_dielik;
 begin             {vypisanie noveho dielika na hraciu plochu}
  for i:=1 to 4 do {do nezobrazovanej casti najskor}
   plocha[sur[i].x+4,sur[i].y]:='*';  {"+4" kvoli centrovaniu}
 end;

procedure vymaz_dielik;{vymaze dielik z hr. plochy.Stale si pamata jeho suradnice.}
 begin
  for i:=1 to 4 do
   plocha[sur[i].x+4,sur[i].y]:=' ';
 end;

procedure refresh_matica;
 begin
  for i:=1 to sirka do {vypisanie hracej plochy bez prvych 4 riadkov}
   for j:=5 to dlzka do
    begin
     gotoxy(stlpec+i,riadok+j-4); write (plocha[i,j]);
    end;
 end;

procedure novy_dielik;
 const pocet_dielikov=7;
 begin
  randomize;
  dielik:=random (pocet_dielikov)+1;   {vybranie noveho dielika}
  case dielik of
   1:begin      {stvorec/kocka}
      sur[1].x:=1;sur[1].y:=1;
      sur[2].x:=2;sur[2].y:=1;
      sur[3].x:=1;sur[3].y:=2;
      sur[4].x:=2;sur[4].y:=2;
     end;
   2:begin      {"esko" otocene dolava}
      sur[1].x:=2;sur[1].y:=1;
      sur[2].x:=1;sur[2].y:=2;
      sur[3].x:=2;sur[3].y:=2;
      sur[4].x:=1;sur[4].y:=3;
     end;
   3:begin      {"esko" otocene doprava}
      sur[1].x:=1;sur[1].y:=1;
      sur[2].x:=1;sur[2].y:=2;
      sur[3].x:=2;sur[3].y:=2;
      sur[4].x:=2;sur[4].y:=3;
     end;
   4:begin      {palicka}
      sur[1].x:=1;sur[1].y:=1;
      sur[2].x:=1;sur[2].y:=2;
      sur[3].x:=1;sur[3].y:=3;
      sur[4].x:=1;sur[4].y:=4;
     end;
   5:begin      {"elko" dolava}
      sur[1].x:=2;sur[1].y:=1;
      sur[2].x:=2;sur[2].y:=2;
      sur[3].x:=1;sur[3].y:=3;
      sur[4].x:=2;sur[4].y:=3;
     end;
   6:begin      {"elko" doprava}
      sur[1].x:=1;sur[1].y:=1;
      sur[2].x:=1;sur[2].y:=2;
      sur[3].x:=1;sur[3].y:=3;
      sur[4].x:=2;sur[4].y:=3;
     end;
   7:begin   {"kopcek"}
      sur[1].x:=2;sur[1].y:=1;
      sur[2].x:=1;sur[2].y:=2;
      sur[3].x:=2;sur[3].y:=2;
      sur[4].x:=3;sur[4].y:=2;
     end;
  end;
  poc_otoc:=0;
  vypis_dielik;
  refresh_matica;
 end;

procedure ud_question;    {zistenie ci je ulozeny dielik}
 begin
  vymaz_dielik;
  ulozeny_dielik:=false;
  for i:=1 to 4 do begin
  if sur[i].y=dlzka then ulozeny_dielik:=true;
                   end;
  for i:=1 to 4 do begin
  if (ulozeny_dielik=false) and (plocha[sur[i].x+4,sur[i].y+1]='*') then ulozeny_dielik:=true;
                   end;
  vypis_dielik;
 end;

procedure posun_dole; {posunutie dieliku o 1 smerom dole}
 begin {bez dodatocnych kontrol-vychadzame z toho, ze nie je ulozeny dielik}
  for i:=1 to 4 do sur[i].y:=sur[i].y+1;
 end;

procedure posun_doprava;
 begin
  mozno_posunut:=true;
  for i:=1 to 4 do begin
  if sur[i].x+4=sirka then mozno_posunut:=false;
   end;
  for i:=1 to 4 do begin
  if (mozno_posunut=true) and (plocha[sur[i].x+4+1,sur[i].y]='*') then mozno_posunut:=false;
   end;
  if mozno_posunut=true then {posunutie doprava}
   for i:=1 to 4 do sur[i].x:=sur[i].x+1;
 end;

procedure posun_dolava;
 begin
  mozno_posunut:=true;
  for i:=1 to 4 do begin
  if sur[i].x+4=1 then mozno_posunut:=false;
   end;
  for i:=1 to 4 do begin
  if (mozno_posunut=true) and (plocha[sur[i].x+4-1,sur[i].y]='*') then mozno_posunut:=false;
   end;
  if mozno_posunut=true then {posunutie dolava}
   for i:=1 to 4 do sur[i].x:=sur[i].x-1;
 end;

procedure otoc; {v smere hodinovych ruciciek}
 procedure otocenie; {otacanie dilikov okrem kocky a palicky}
  begin
   lhx:=sur[1].x-3;     {urcenie laveho horneho rohu stvorcovej matice,}
   lhy:=sur[1].y-3;     {s ktorou pracujeme pri otacani}
   for i:=1 to 4 do if sur[i].x>lhx+3 then lhx:=sur[i].x-3;
   for i:=1 to 4 do if sur[i].y>lhy+3 then lhy:=sur[i].y-3;

   for i:=1 to 4 do prech_sur[i].x:=sur[i].x-lhx; {definovanie prechodnych}
   for i:=1 to 4 do prech_sur[i].y:=sur[i].y-lhy; {suradnic}

   {diagonalne otocit}
   for i:=1 to 4 do begin
    temp:=prech_sur[i].x;
    prech_sur[i].x:=prech_sur[i].y;
    prech_sur[i].y:=temp;
                    end;

   {otocit po zvislici}
   for i:=1 to 4 do begin
    prech_sur[i].x:=4-prech_sur[i].x
                    end;

   {definovat otocene suradnice}
   {osetrene pripadne posuvanie dieliku do strany}
   if poc_otoc mod 2<>0 then
     for i:=1 to 4 do begin
      otocena_sur[i].x:=prech_sur[i].x+lhx+1;
      otocena_sur[i].y:=prech_sur[i].y+lhy;
                      end
                        else
     for i:=1 to 4 do begin
      otocena_sur[i].x:=prech_sur[i].x+lhx;
      otocena_sur[i].y:=prech_sur[i].y+lhy;
                      end;

                                 {kontrola ci je mozne otocit dielik}
   vymaz_dielik;
   for i:=1 to 4 do if (otocena_sur[i].x+4>sirka) or (otocena_sur[i].x+4<1) then mozno_posunut:=false;
   for i:=1 to 4 do if (mozno_posunut=true) and (otocena_sur[i].y>dlzka) then mozno_posunut:=false;
   for i:=1 to 4 do if (mozno_posunut=true) and (plocha[otocena_sur[i].x+4,otocena_sur[i].y]='*') then mozno_posunut:=false;

   if mozno_posunut=true then begin {otocenie}
    for i:=1 to 4 do sur[i].x:=otocena_sur[i].x;
    for i:=1 to 4 do sur[i].y:=otocena_sur[i].y;
    inc(poc_otoc);
                              end;
   vypis_dielik;
  end;

 procedure otoc_pal;
  begin
   if sur[1].x=sur[2].x then begin {Urcenie laveho horneho rohu stvorcovej matice,}
    lhx:=sur[1].x-1;               {s ktorou pracujeme pri otacani.}
    lhy:=sur[1].y;                 {zvisla palicka}
                             end
                        else begin
    lhx:=sur[1].x;                 {vodorovna palicka}
    lhy:=sur[1].y-1;
                             end;

   for i:=1 to 4 do prech_sur[i].x:=sur[i].x-lhx; {definovanie prechodnych}
   for i:=1 to 4 do prech_sur[i].y:=sur[i].y-lhy; {suradnic}

   {diagonalne otocit}
   for i:=1 to 4 do begin
    temp:=prech_sur[i].x;
    prech_sur[i].x:=prech_sur[i].y;
    prech_sur[i].y:=temp;
                    end;

   for i:=1 to 4 do begin
      otocena_sur[i].x:=prech_sur[i].x+lhx;
      otocena_sur[i].y:=prech_sur[i].y+lhy;
                      end;

                                 {kontrola ci je mozne otocit dielik}
   vymaz_dielik;
   for i:=1 to 4 do if (otocena_sur[i].x+4>sirka) or (otocena_sur[i].x+4<1) then mozno_posunut:=false;
   for i:=1 to 4 do if otocena_sur[i].y>dlzka then mozno_posunut:=false;
   for i:=1 to 4 do if (mozno_posunut=true) and (plocha[otocena_sur[i].x+4,otocena_sur[i].y]='*') then mozno_posunut:=false;

   if mozno_posunut=true then begin {otocenie}
    for i:=1 to 4 do sur[i].x:=otocena_sur[i].x;
    for i:=1 to 4 do sur[i].y:=otocena_sur[i].y;
                              end;
   vypis_dielik;
  end;

 begin
  mozno_posunut:=true;
     {vybratie sposobu otacania v zavislosti od typu dielika}
  case dielik of
   1: begin mozno_posunut:=false; end; {kocka sa neotaca}
   4: otoc_pal; {palicka}
   else otocenie; {ostatne dieliky}
  end;
 end;

procedure automaticky_posun; {automaticke posuvanie kym nie je ulozeny dielik}
 begin                       {alebo kym nie je koniec hry}
  ulozeny_dielik:=false;
  koniec_hry:=false;

  while (not(ulozeny_dielik)) and (not(koniec_hry)) do begin
                   {pociatocne kontroly}
   ud_question; {ci je ulozeny dielik}

   if ulozeny_dielik=true then begin {kontrola ci je koniec hry}
    for i:=1 to 4 do if sur[i].y<5 then koniec_hry:=true; end;

   while (not(keypressed)) and (not(ulozeny_dielik)) and (not(koniec_hry)) do begin
    if level<22 then delay(410-level*10) {zvysovanie rychlosti v zavislosti od levelu}
                else delay(200);

    ud_question;

    vymaz_dielik;
    if not(ulozeny_dielik) then {posunutie dieliku, ak je kam}
     for i:=1 to 4 do sur[i].y:=sur[i].y+1;
    vypis_dielik;

    if ulozeny_dielik=true then begin  {kontrola ci je koniec hry}
     for i:=1 to 4 do if sur[i].y<5 then koniec_hry:=true; end;

    refresh_matica;
   end;

  if (not(ulozeny_dielik)) and (not(koniec_hry)) then begin
   klavesa:=readkey;         {posuvanie/otacanie dilika}
   vymaz_dielik;
   case klavesa of
    #72: otoc;
    #75: posun_dolava;
    #77: posun_doprava;
    #80: posun_dole;
   end;
   vypis_dielik;
   refresh_matica;
  end;
 end;

end;

procedure posun_vsetko_dole(r:integer);
 begin
  for i:=r downto 5 do
   for j:=1 to sirka do plocha[j,i]:=plocha[j,i-1];
 end;

procedure check_line;      {kontrola ci je zaplneny riadok}
 begin
  for i:=5 to dlzka do begin {skontroluj kazdy riadok okrem hornych styroch}
   mozno_posunut:=true;
   for j:=1 to sirka do begin  {kazdy znak v riadku}
    if (mozno_posunut=true) and (plocha[j,i]<>'*') then mozno_posunut:=false;
    if j=sirka then begin
                     if mozno_posunut=true then begin
                      posun_vsetko_dole(i);
                      inc(score);
                                                end;
                    end;
                        end;
                       end;
 end;




procedure help;
 begin
  gotoxy(2, 7);write('                   Tetris - help                     ');
  gotoxy(2, 8);write('===================================================  ');
  gotoxy(2, 9);write('Cielom hry je ukladat padajuce dieliky tak aby vy-   ');
  gotoxy(2,10);write('plnili cely riadok. Za kazdy riadok je jeden bod.    ');
  gotoxy(2,11);write('Po kazdych 10-tich bodoch sa zvysi level o 1 a       ');
  gotoxy(2,12);write('mierne sa zvysi rychlost. Od 22. levela je rychlost  ');
  gotoxy(2,13);write('konstantna.                                          ');
  gotoxy(2,14);write('                                                     ');
  gotoxy(2,15);write('Ovladanie: sipka vlavo - posunutie dolava            ');
  gotoxy(2,16);write('           sipka vpravo - posunutie doprava          ');
  gotoxy(2,17);write('           sipka dole - posunutie dole               ');
  gotoxy(2,18);write('           sipka hore - otocenie dielika             ');
  gotoxy(2,20);write('Pre pokracovanie stlacte Enter');
  readln;
 end;

procedure base_screen; {vyvola hlavne menu a obsahuje vn. pr. Nova hra}
 procedure nova_hra; {vnorena procedura je preto aby sa po konci hry zase}
  begin              {vratil program do menu}
   clrscr;
   score:=0;
   level:=1;
   gotoxy(stlpec+sirka+2,2); write('Score:',score:3);
   gotoxy(stlpec+sirka+2,4); write('Level:',level:3);

   for i:=1 to sirka do {cista hracia plocha}
    for j:=1 to dlzka do
     plocha[i,j]:=' ';

   refresh_matica;
                         {ramik na plochu}
   textcolor(yellow);
   gotoxy(stlpec,riadok); write('Ú'); for i:=1 to sirka do write('Ä'); write('¿');
    for i:=5 to dlzka do
     begin
      gotoxy(stlpec,riadok+i-4); write('³'); gotoxy(stlpec+sirka+1,riadok+i-4); write('³');
     end;
    gotoxy(stlpec,riadok+dlzka+1-4); write('À'); for j:=1 to sirka do write('Ä'); write('Ù');
   textcolor(lightgray);
   gotoxy(stlpec,riadok+dlzka+2-4); writeln ('Good luck :-)');


   koniec_hry:=false;
   while koniec_hry=false do begin   {cyklus samotnej hry}
    novy_dielik;
    automaticky_posun;
    check_line;
    gotoxy(stlpec+sirka+2,2); write('Score:',score:3);
    if score>=10 then level:=(score div 10)+1;
    gotoxy(stlpec+sirka+2,4); write('Level:',level:3);
   end;

   gotoxy(4,riadok+dlzka); write('G*A*M*E  O*V*E*R');
   gotoxy(4,riadok+dlzka+2); write('Your score is: ',score,'. Congratulation!');
   gotoxy(4,riadok+dlzka+4); write('Press enter to return to menu.');
   readln;
   base_screen;
  end;

 begin  {telo procedury base_screen}
  textbackground(black); textcolor(lightgray); clrscr;
  p[1]:=' New game   ';
  p[2]:=' Help       ';
  p[3]:=' Exit       ';
  pocet:=3;
  rozh:=0;
  repeat
   clrscr;
   textcolor(yellow);
   gotoxy(10,10);write('******  ******  ******  ****     ****    ***  ');
   gotoxy(10,11);write('******  *****   ******  ******   ****   ***** ');
   gotoxy(10,12);write('  **    ***       **    **  **    **    **    ');
   gotoxy(10,13);write('  **    *         **    ****      **     **   ');
   gotoxy(10,14);write('  **    ***       **    *  *      **      **  ');
   gotoxy(10,15);write('  **    *****     **    *  **    ****   ***** ');
   gotoxy(10,16);write('  **    ******    **    *  ***   ****    ***  ');
   textcolor(lightgray);
   menu(10,1,p,pocet,v);

  case rozh of
    1: nova_hra;
    2: help;
    3: halt;
  end;
  until (rozh=1) or (rozh=3);
 end;

begin {Hlavny begin programu}
 base_screen; {vyvolanie uvodnej obrazovky s menu}
end.  {Koniec programu}