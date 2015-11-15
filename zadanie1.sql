-- �ukasz Wieczorek 206833
-- Konrad Turek 206830

-- Czyszczenie bazy danych -----------------------------------------------------

DROP TABLE KLIENT CASCADE CONSTRAINTS;
DROP TABLE PRODUKT CASCADE CONSTRAINTS;
DROP TABLE ZAMOWIENIE CASCADE CONSTRAINTS;
DROP TABLE LINIA_ZAMOWIENIA CASCADE CONSTRAINTS;
DROP TABLE ADRES CASCADE CONSTRAINTS;

DROP sequence ADRES_SEQ;
DROP sequence KLIENT_SEQ;
DROP sequence PRODUKT_SEQ;
DROP sequence ZAMOWIENIE_SEQ;
DROP sequence LINIA_ZAMOWIENIA_SEQ;

--Definicja tabel --------------------------------------------------------------

CREATE
  TABLE KLIENT
  (
    PK          NUMBER NOT NULL ENABLE,
    IMIE        VARCHAR2(20 BYTE),
    DRUGIE_IMIE VARCHAR2(20 BYTE),
    NAZWISKO    VARCHAR2(40 BYTE),
    CONSTRAINT KLIENT_PK PRIMARY KEY (PK) ENABLE
  );
CREATE
  TABLE PRODUKT
  (
    PK          NUMBER NOT NULL ,
    NAZWA       VARCHAR2(50) NOT NULL ,
    OPIS        VARCHAR2(500) ,
    CENA        NUMBER DEFAULT 0 NOT NULL ,
    ILOSC_SZTUK NUMBER DEFAULT 0 NOT NULL ,
    CONSTRAINT PRODUKT_PK PRIMARY KEY (PK) ENABLE
  );
CREATE
  TABLE ADRES
  (
    PK            NUMBER NOT NULL ,
    NR_MIESZKANIA VARCHAR2(10) ,
    ULICA         VARCHAR2(50) ,
    MIEJSCOWOSC   VARCHAR2(50) ,
    KOD_POCZTOWY  VARCHAR2(5) ,
    NR_DOMU       VARCHAR2(10) ,
    POCZTA        VARCHAR2(50) ,
    CONSTRAINT ADRES_PK PRIMARY KEY ( PK ) ENABLE
  );
CREATE
  TABLE ZAMOWIENIE
  (
    PK     NUMBER NOT NULL ,
    KLIENT NUMBER NOT NULL ,
    ADRES  NUMBER NOT NULL ,
    STATUS VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK( STATUS IN ('N','Z') ), 
    CONSTRAINT ZAMOWIENIE_PK PRIMARY KEY ( PK ) ENABLE,
    CONSTRAINT ZAMOWIENIE_KLIENT_FK FOREIGN KEY (KLIENT) REFERENCES KLIENT (PK)
    ENABLE,
    CONSTRAINT ZAMOWIENIE_ADRES_FK FOREIGN KEY (ADRES) REFERENCES ADRES (PK)
    ENABLE
  );
  
CREATE
  TABLE LINIA_ZAMOWIENIA
  (
    PK         NUMBER NOT NULL,
    PRODUKT    NUMBER NOT NULL,
    ILOSC      NUMBER NOT NULL,
    ZAMOWIENIE NUMBER NOT NULL,
    CENA NUMBER NOT NULL,
    CONSTRAINT LINIA_ZAMOWIENIA_PK PRIMARY KEY (PK) ENABLE,
    CONSTRAINT LINIA_ZAMOWIENIA_PRODUKT_FK FOREIGN KEY (PRODUKT) REFERENCES
    PRODUKT (PK) ENABLE,
    CONSTRAINT LINIA_ZAMOWIENIA_ZAMOWIENIE_FK FOREIGN KEY (ZAMOWIENIE)
    REFERENCES ZAMOWIENIE (PK) ENABLE
  );
  
-- Sekwencje
create sequence ADRES_SEQ start with 1 increment by 1;
create sequence KLIENT_SEQ start with 1 increment by 1;
create sequence PRODUKT_SEQ start with 1 increment by 1;
create sequence ZAMOWIENIE_SEQ start with 1 increment by 1;
create sequence LINIA_ZAMOWIENIA_SEQ start with 1 increment by 1;

-- Trigery do sekwencji (Liczy sie jako 1 ;) )

CREATE OR REPLACE TRIGGER ADRES_SEQ_TRIGGER
BEFORE INSERT ON ADRES
FOR EACH ROW
 WHEN (new.PK IS NULL) 
BEGIN
  SELECT ADRES_SEQ.NEXTVAL 
  INTO :new.PK
  FROM dual;
END ADRES_SEQ_TRIGGER;

CREATE OR REPLACE TRIGGER KLIENT_SEQ_TRIGGER
BEFORE INSERT ON KLIENT
FOR EACH ROW
 WHEN (new.PK IS NULL) 
BEGIN
  SELECT KLIENT_SEQ.NEXTVAL 
  INTO :new.PK
  FROM dual;
END KLIENT_SEQ_TRIGGER;

CREATE OR REPLACE TRIGGER PRODUKT_SEQ_TRIGGER
BEFORE INSERT ON PRODUKT
FOR EACH ROW
 WHEN (new.PK IS NULL) 
BEGIN
  SELECT PRODUKT_SEQ.NEXTVAL 
  INTO :new.PK
  FROM dual;
END PRODUKT_SEQ_TRIGGER;

CREATE OR REPLACE TRIGGER ZAMOWIENIE_SEQ_TRIGGER
BEFORE INSERT ON ZAMOWIENIE
FOR EACH ROW
 WHEN (new.PK IS NULL) 
BEGIN
  SELECT ZAMOWIENIE_SEQ.NEXTVAL 
  INTO :new.PK
  FROM dual;
END ZAMOWIENIE_SEQ_TRIGGER;

CREATE OR REPLACE TRIGGER LINIA_ZAMOWIENIA_SEQ_TRIGGER
BEFORE INSERT ON LINIA_ZAMOWIENIA
FOR EACH ROW
 WHEN (new.PK IS NULL) 
BEGIN
  SELECT LINIA_ZAMOWIENIA_SEQ.NEXTVAL 
  INTO :new.PK
  FROM dual;
END LINIA_ZAMOWIENIA_SEQ_TRIGGER;
  
-- Przykadowe dane -------------------------------------------------------------
  
INSERT INTO "TEST"."ADRES" (NR_MIESZKANIA, ULICA, MIEJSCOWOSC, KOD_POCZTOWY, NR_DOMU, POCZTA) VALUES ('15', 'TESTOWA', 'TEST', '95040', '2', 'TEST');
INSERT INTO "TEST"."ADRES" (NR_MIESZKANIA, ULICA, MIEJSCOWOSC, KOD_POCZTOWY, NR_DOMU, POCZTA) VALUES ('45', 'TEST', 'TEST', '95234', '65', 'TESTOWA');
INSERT INTO "TEST"."ADRES" (NR_MIESZKANIA, ULICA, MIEJSCOWOSC, KOD_POCZTOWY, NR_DOMU, POCZTA) VALUES ('112', 'TEST', 'TEST', '92124', '23', 'TEST');
INSERT INTO "TEST"."ADRES" (NR_MIESZKANIA, ULICA, MIEJSCOWOSC, KOD_POCZTOWY, NR_DOMU, POCZTA) VALUES ('312', 'TEST', 'TEST', '95040', '112', 'TEST');

INSERT INTO "TEST"."KLIENT" (IMIE, DRUGIE_IMIE, NAZWISKO) VALUES ('John', 'Gi', 'Doe');
INSERT INTO "TEST"."KLIENT" (IMIE, NAZWISKO) VALUES ('Jacek', 'Placek');
INSERT INTO "TEST"."KLIENT" (IMIE, NAZWISKO) VALUES ('Krzysztof', 'Testowy');

INSERT INTO "TEST"."PRODUKT" (NAZWA, OPIS, CENA, ILOSC_SZTUK) VALUES ( 'Ciastko', 'Testowy opis ciastka', '1,2', '12');
INSERT INTO "TEST"."PRODUKT" (NAZWA, OPIS, CENA, ILOSC_SZTUK) VALUES ('Czekolada', 'Testowy opis czekolady', '5,95', '23');
INSERT INTO "TEST"."PRODUKT" (NAZWA, OPIS, CENA, ILOSC_SZTUK) VALUES ('Kasztan', 'Testowy kasztan', '12', '23');

INSERT INTO "TEST"."ZAMOWIENIE" (KLIENT, ADRES) VALUES ('1', '2');
INSERT INTO "TEST"."ZAMOWIENIE" (KLIENT, ADRES) VALUES ('1', '3');

INSERT INTO "TEST"."LINIA_ZAMOWIENIA" (PRODUKT, ILOSC, ZAMOWIENIE, CENA) VALUES ('1', '12', '1', '1');
INSERT INTO "TEST"."LINIA_ZAMOWIENIA" (PRODUKT, ILOSC, ZAMOWIENIE, CENA) VALUES ('2', '1', '1', '6,50');
INSERT INTO "TEST"."LINIA_ZAMOWIENIA" (PRODUKT, ILOSC, ZAMOWIENIE, CENA) VALUES ('3', '3', '1', '13');

INSERT INTO "TEST"."LINIA_ZAMOWIENIA" (PRODUKT, ILOSC, ZAMOWIENIE, CENA) VALUES ('1', '3', '2', '1,2');
INSERT INTO "TEST"."LINIA_ZAMOWIENIA" (PRODUKT, ILOSC, ZAMOWIENIE, CENA) VALUES ('2', '6', '2', '5,95');

COMMIT;

-- Funkcje, procedury i ich wywoania -------------------------------------------

-- Funkcja 1: Wyszukanie ilo�ci zam�wie� danego u�ytkownika
CREATE OR REPLACE FUNCTION GET_KLIENT_ZAMOWIENIA_COUNT 
(
  KLIENT_ID IN NUMBER 
) RETURN NUMBER IS
   countZamowienie NUMBER;
BEGIN
  SELECT COUNT(*) INTO countZamowienie FROM ZAMOWIENIE WHERE KLIENT = KLIENT_ID;
  RETURN countZamowienie;
END GET_KLIENT_ZAMOWIENIA_COUNT;

-- Wywoanie funkcji 1
SELECT DISTINCT x.IMIE, x.DRUGIE_IMIE, x.NAZWISKO, GET_KLIENT_ZAMOWIENIA_COUNT(x.PK) FROM KLIENT x;

-- Funkcja 2: Sprawdzenie sumy zam�wienia

CREATE OR REPLACE FUNCTION GET_SUMA_ZAMOWIENIA 
(
  ZAMOWIENIE_ID IN NUMBER 
) RETURN NUMBER IS
   suma NUMBER;
BEGIN
  SELECT sum(CENA) INTO suma FROM LINIA_ZAMOWIENIA lz WHERE lz.ZAMOWIENIE = ZAMOWIENIE_ID;
  RETURN suma;
END GET_SUMA_ZAMOWIENIA;

-- Wywolanie Procedury 2:

SELECT DISTINCT x.PK, GET_SUMA_ZAMOWIENIA(x.PK) FROM ZAMOWIENIE x;

-- Procedura 1: Dodanie produktu do zam�wienia

create or replace PROCEDURE DODAJ_PRODUKT_DO_ZAMOWIENIA 
(
  PRODUKT_ID IN NUMBER 
, ZAMOWIENIE_ID IN NUMBER 
, ILOSC IN NUMBER 
) IS 
  CENA NUMBER;
  BLOKADA ZAMOWIENIE.STATUS%TYPE;
  LIN_ZAM_COUNT NUMBER;
BEGIN
  SELECT STATUS INTO BLOKADA FROM ZAMOWIENIE WHERE PK = ZAMOWIENIE_ID;
  SELECT COUNT(*) INTO LIN_ZAM_COUNT FROM LINIA_ZAMOWIENIA WHERE PRODUKT = PRODUKT_ID and ZAMOWIENIE = ZAMOWIENIE_ID;
  IF (BLOKADA = 'N') THEN
    IF(LIN_ZAM_COUNT = 0) THEN
      SELECT x.CENA INTO CENA FROM PRODUKT x WHERE x.PK = PRODUKT_ID;
      INSERT INTO "LINIA_ZAMOWIENIA" (PRODUKT, ILOSC, ZAMOWIENIE, CENA) VALUES (PRODUKT_ID, ILOSC, ZAMOWIENIE_ID, CENA);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Dany produkt znajduje sie juz w zamowieniu');
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Zam�wienie zostalo ju� zablokowane');
  END IF;
END DODAJ_PRODUKT_DO_ZAMOWIENIA;

-- Procedura 2: Usni�cie produktu z zam�wienia

CREATE OR REPLACE PROCEDURE USUN_PRODUKT_Z_ZAMOWIENIA 
(
  PRODUKT_ID IN NUMBER 
, ZAMOWIENIE_ID IN NUMBER 
) IS 
  BLOKADA VARCHAR2(1);
BEGIN
  SELECT STATUS INTO BLOKADA FROM ZAMOWIENIE WHERE PK = ZAMOWIENIE_ID;
  IF (BLOKADA = 'N') THEN
    DELETE FROM LINIA_ZAMOWIENIA WHERE ZAMOWIENIE = ZAMOWIENIE_ID and PRODUKT = PRODUKT_ID;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Zam�wienie zostao ju� zablokowane');
  END IF;
END USUN_PRODUKT_Z_ZAMOWIENIA;

-- Procedura 3: Zablokowanie zam�wienia

CREATE OR REPLACE PROCEDURE ZABLOKUJ_ZAMOWIENIE 
(
  ZAMOWIENIE_ID IN NUMBER 
) AS 
BEGIN
  UPDATE ZAMOWIENIE z SET STATUS = 'Z' WHERE z.PK = ZAMOWIENIE_ID;
END ZABLOKUJ_ZAMOWIENIE;

SELECT STATUS FROM ZAMOWIENIE;