
CREATE TABLE compagnia (
    nome VARCHAR(20) PRIMARY KEY,
    telefono INT,
    email VARCHAR(50),
    sitoweb VARCHAR(50),
    social VARCHAR(20),
    CHECK (nome <> '' AND nome IS NOT NULL),
    UNIQUE (nome)
);

CREATE TABLE giorno(
    nome VARCHAR(20) PRIMARY KEY NOT NULL CHECK (nome IN ('Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'))
);

CREATE TABLE biglietto_intero (
    prezzo NUMERIC(10,2),
    id_intero SERIAL PRIMARY KEY
);

CREATE TABLE biglietto_ridotto (
    prezzo NUMERIC(10,2),
    id_ridotto SERIAL PRIMARY KEY
);

CREATE TABLE corsa (
    id_corsa SERIAL PRIMARY KEY,
    porto_partenza VARCHAR(20) NOT NULL CHECK (porto_partenza <> ''),
    porto_arrivo VARCHAR(20) NOT NULL CHECK (porto_arrivo <> ''),
    orario_partenza TIME NOT NULL,
    orario_arrivo TIME NOT NULL,
    scalo BOOLEAN,
    nome_compagnia VARCHAR(20) NOT NULL CHECK (nome_compagnia <> ''),
    annullata BOOLEAN,
    ritardo INTERVAL,
    CHECK (orario_partenza < orario_arrivo),
    prezzo_intero NUMERIC(10,2),
    prezzo_ridotto NUMERIC(10,2),
    id_intero SERIAL,
    id_ridotto SERIAL,
    FOREIGN KEY (id_intero) REFERENCES biglietto_intero(id_intero),
    FOREIGN KEY (id_ridotto) REFERENCES biglietto_ridotto(id_ridotto),
    FOREIGN KEY (nome_compagnia) REFERENCES compagnia(nome)
);

CREATE TABLE effettua_giorno(
    id_corsa SERIAL,
    nome VARCHAR(20),
    PRIMARY KEY (id_corsa,nome),
    FOREIGN KEY (id_corsa) REFERENCES corsa(id_corsa),
    FOREIGN KEY (nome) REFERENCES giorno(nome)
);


CREATE TABLE periodo (
    data_inizio DATE,
    data_fine DATE,
    CHECK (data_inizio < data_fine),
    id_periodo SERIAL PRIMARY KEY
);

CREATE TABLE opera (
    id_periodo SERIAL,
    id_corsa SERIAL,
    PRIMARY KEY (id_periodo, id_corsa),
    FOREIGN KEY (id_corsa) REFERENCES corsa(id_corsa),
    FOREIGN KEY (id_periodo) REFERENCES periodo(id_periodo)
);




CREATE TABLE prenotazione (
    data DATE NOT NULL,
    id_prenotazione SERIAL PRIMARY KEY
);

CREATE TABLE assegna_ridotto (
    id_prenotazione SERIAL,
    id_ridotto SERIAL,
    PRIMARY KEY (id_prenotazione, id_ridotto),
    FOREIGN KEY (id_prenotazione) REFERENCES prenotazione(id_prenotazione),
    FOREIGN KEY (id_ridotto) REFERENCES biglietto_ridotto(id_ridotto)
);

CREATE TABLE assegna_intero (
    id_prenotazione SERIAL,
    id_intero SERIAL,
    PRIMARY KEY (id_prenotazione, id_intero),
    FOREIGN KEY (id_prenotazione) REFERENCES prenotazione(id_prenotazione),
    FOREIGN KEY (id_intero) REFERENCES biglietto_intero(id_intero)
);


CREATE TABLE aliscafo (    
    id_aliscafo SERIAL PRIMARY KEY,
    anno_produzione INT,
    modello VARCHAR(20),
    velocità_massima INT,
    capacità_persone INT NOT NULL
);

CREATE TABLE traghetto (
    id_traghetto SERIAL PRIMARY KEY,
    anno_produzione INT,
    modello VARCHAR(20),
    velocità_massima INT,
    capacità_persone INT NOT NULL,
    capacità_automezzi INT NOT NULL
);

CREATE TABLE motonave (
    id_motonave SERIAL PRIMARY KEY,
    anno_produzione INT,
    modello VARCHAR(20),
    velocità_massima INT,
    capacità_persone INT NOT NULL
);

CREATE TABLE automezzo (
    anno_produzione INT,
    targa CHAR(7) PRIMARY KEY,
    marca VARCHAR(20),
    tipo VARCHAR(20)
);

CREATE TABLE aggiunge_automezzo(
    sovraprezzo BOOLEAN,
    prezzo NUMERIC(10,2),
    id_prenotazione SERIAL,
    targa CHAR(7),
    PRIMARY KEY (id_prenotazione,targa),
    FOREIGN KEY (id_prenotazione) REFERENCES prenotazione(id_prenotazione),
    FOREIGN KEY (targa) REFERENCES automezzo(targa)
);

CREATE TABLE passeggero (
    nome VARCHAR(20),
    cognome VARCHAR(20),
    età INT,
    codice_fiscale CHAR(16) PRIMARY KEY
);

CREATE TABLE tabellone_corse (
    id_tabellone INT DEFAULT 10,
    id_corsa SERIAL,
    PRIMARY KEY (id_tabellone, id_corsa),
    FOREIGN KEY (id_corsa) REFERENCES corsa(id_corsa)
);

CREATE TABLE bagaglio (
    numero INT,
    peso FLOAT,
    id_bagaglio SERIAL PRIMARY KEY
);

CREATE TABLE effettua (
    sovraprezzo BOOLEAN,
    prezzo NUMERIC(10,2),
    id_prenotazione SERIAL,
    codice_fiscale CHAR(16),
    PRIMARY KEY (id_prenotazione,codice_fiscale),
    FOREIGN KEY (id_prenotazione) REFERENCES prenotazione(id_prenotazione),
    FOREIGN KEY (codice_fiscale) REFERENCES passeggero(codice_fiscale)
);

CREATE TABLE aggiunge_bagaglio (
    sovraprezzo BOOLEAN,
    prezzo NUMERIC(10,2),
    id_prenotazione SERIAL,
    id_bagaglio SERIAL,
    PRIMARY KEY (id_prenotazione,id_bagaglio),
    FOREIGN KEY (id_prenotazione) REFERENCES prenotazione(id_prenotazione),
    FOREIGN KEY (id_bagaglio) REFERENCES bagaglio(id_bagaglio)
);

CREATE TABLE possiede_motonave (
    nome VARCHAR(20) NOT NULL CHECK (nome <> ''),
    id_motonave SERIAL,
    PRIMARY KEY (nome, id_motonave),
    FOREIGN KEY (nome) REFERENCES compagnia(nome),
    FOREIGN KEY (id_motonave) REFERENCES motonave(id_motonave)
);

CREATE TABLE possiede_aliscafo (
    nome VARCHAR(20) NOT NULL CHECK (nome <> ''),
    id_aliscafo SERIAL,
    PRIMARY KEY (nome, id_aliscafo),
    FOREIGN KEY (nome) REFERENCES compagnia(nome),
    FOREIGN KEY (id_aliscafo) REFERENCES aliscafo(id_aliscafo)
);

CREATE TABLE possiede_traghetto (
    nome VARCHAR(20) NOT NULL CHECK (nome <> ''),
    id_traghetto SERIAL,
    PRIMARY KEY (nome, id_traghetto),
    FOREIGN KEY (nome) REFERENCES compagnia(nome),
    FOREIGN KEY (id_traghetto) REFERENCES traghetto(id_traghetto)
);

CREATE TABLE trasporta_motonave (
    id_motonave SERIAL,
    codice_fiscale CHAR(16),
    PRIMARY KEY (id_motonave, codice_fiscale),
    FOREIGN KEY (id_motonave) REFERENCES motonave(id_motonave),
    FOREIGN KEY (codice_fiscale) REFERENCES passeggero(codice_fiscale)
);

CREATE TABLE trasporta_aliscafo (
    id_aliscafo SERIAL,
    codice_fiscale CHAR(16),
    PRIMARY KEY (id_aliscafo, codice_fiscale),
    FOREIGN KEY (id_aliscafo) REFERENCES aliscafo(id_aliscafo),
    FOREIGN KEY (codice_fiscale) REFERENCES passeggero(codice_fiscale)
);

CREATE TABLE trasporta_traghetto (
    id_traghetto SERIAL,
    codice_fiscale CHAR(16),
    PRIMARY KEY (id_traghetto, codice_fiscale),
    FOREIGN KEY (id_traghetto) REFERENCES traghetto(id_traghetto),
    FOREIGN KEY (codice_fiscale) REFERENCES passeggero(codice_fiscale)
);

CREATE TABLE trasporta_traghetto_automezzo (
    id_traghetto SERIAL,
    targa CHAR(7),
    PRIMARY KEY (id_traghetto, targa),
    FOREIGN KEY (id_traghetto) REFERENCES traghetto(id_traghetto),
    FOREIGN KEY (targa) REFERENCES automezzo(targa)
);

CREATE TABLE effettua_motonave (
    id_motonave SERIAL,
    id_corsa SERIAL,
    PRIMARY KEY (id_motonave, id_corsa),
    FOREIGN KEY (id_motonave) REFERENCES motonave(id_motonave),
    FOREIGN KEY (id_corsa) REFERENCES corsa(id_corsa)
);
CREATE TABLE effettua_aliscafo (
    id_aliscafo SERIAL,
    id_corsa SERIAL,
    PRIMARY KEY (id_aliscafo, id_corsa),
    FOREIGN KEY (id_aliscafo) REFERENCES aliscafo(id_aliscafo),
    FOREIGN KEY (id_corsa) REFERENCES corsa(id_corsa)
);
CREATE TABLE effettua_traghetto (
    id_traghetto SERIAL,
    id_corsa SERIAL,
    PRIMARY KEY (id_traghetto, id_corsa),
    FOREIGN KEY (id_traghetto) REFERENCES traghetto(id_traghetto),
    FOREIGN KEY (id_corsa) REFERENCES corsa(id_corsa)
);



									
									-- TRIGGER




-- 1

CREATE OR REPLACE FUNCTION aggiungi_al_tabellone()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO tabellone_corse (id_corsa)
    VALUES (NEW.id_corsa);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_aggiungi_al_tabellone
AFTER INSERT
ON corsa
FOR EACH ROW
EXECUTE FUNCTION aggiungi_al_tabellone();

-- 2
CREATE OR REPLACE FUNCTION diminuisci_posti_disponibili()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica il tipo di natante coinvolto nella prenotazione
    IF EXISTS (
        SELECT 1
        FROM trasporta_motonave tm
        WHERE tm.codice_fiscale = NEW.codice_fiscale
    ) THEN
        -- Natante di tipo motonave
        UPDATE motonave
        SET capacità_persone = capacità_persone - 1
        WHERE id_motonave = (
            SELECT tm.id_motonave
            FROM trasporta_motonave tm
            WHERE tm.codice_fiscale = NEW.codice_fiscale
            LIMIT 1
        );

    ELSIF EXISTS (
        SELECT 1
        FROM trasporta_aliscafo ta
        WHERE ta.codice_fiscale = NEW.codice_fiscale
    ) THEN
        -- Natante di tipo aliscafo
        UPDATE aliscafo
        SET capacità_persone = capacità_persone - 1
        WHERE id_aliscafo = (
            SELECT ta.id_aliscafo
            FROM trasporta_aliscafo ta
            WHERE ta.codice_fiscale = NEW.codice_fiscale
            LIMIT 1
        );

    ELSIF EXISTS (
        SELECT 1
        FROM trasporta_traghetto tt
        WHERE tt.codice_fiscale = NEW.codice_fiscale
    ) THEN
        -- Natante di tipo traghetto
        UPDATE traghetto
        SET capacità_persone = capacità_persone - 1,
            capacità_automezzi = capacità_automezzi - 1
        WHERE id_traghetto = (
            SELECT tt.id_traghetto
            FROM trasporta_traghetto tt
            WHERE tt.codice_fiscale = NEW.codice_fiscale
            LIMIT 1
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER diminuisci_posti_trigger
AFTER INSERT ON effettua
FOR EACH ROW EXECUTE FUNCTION diminuisci_posti_disponibili();

-- 3
-- Trigger per aumentare i posti disponibili dopo la cancellazione da trasporta_aliscafo
CREATE OR REPLACE FUNCTION aumenta_posti_aliscafo()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE aliscafo
    SET capacità_persone = capacità_persone + 1
    WHERE id_aliscafo = (
        SELECT id_aliscafo
        FROM trasporta_aliscafo
        WHERE codice_fiscale = OLD.codice_fiscale
        LIMIT 1
    );

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER aumenta_posti_aliscafo_trigger
AFTER DELETE ON trasporta_aliscafo
FOR EACH ROW EXECUTE FUNCTION aumenta_posti_aliscafo();

-- 4
-- Trigger per aumentare i posti disponibili dopo la cancellazione da trasporta_traghetto
CREATE OR REPLACE FUNCTION aumenta_posti_traghetto()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE traghetto
    SET capacità_persone = capacità_persone + 1,
    capacità_automezzi = capacità_automezzi + 1
    WHERE id_traghetto = (
        SELECT id_traghetto
        FROM trasporta_traghetto
        WHERE codice_fiscale = OLD.codice_fiscale
        LIMIT 1
    );

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER aumenta_posti_traghetto_trigger
AFTER DELETE ON trasporta_traghetto
FOR EACH ROW EXECUTE FUNCTION aumenta_posti_traghetto();

-- 5
-- Trigger per aumentare i posti disponibili dopo la cancellazione da trasporta_motonave
CREATE OR REPLACE FUNCTION aumenta_posti_motonave()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE motonave
    SET capacità_persone = capacità_persone + 1
    WHERE id_motonave = (
        SELECT id_motonave
        FROM trasporta_motonave
        WHERE codice_fiscale = OLD.codice_fiscale
        LIMIT 1
    );

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER aumenta_posti_motonave_trigger
AFTER DELETE ON trasporta_motonave
FOR EACH ROW EXECUTE FUNCTION aumenta_posti_motonave();



									-- FUNZIONI
									

-- 1
CREATE OR REPLACE FUNCTION consulta_tabellone_corse(
    IN p_porto_partenza VARCHAR(20),
    IN p_porto_arrivo VARCHAR(20),
    IN p_data_consulta DATE,
    IN p_orario_consulta TIME,
    IN p_giorno VARCHAR(20),
    IN p_tipo_natante VARCHAR(20) DEFAULT NULL,
    IN p_prezzo_min NUMERIC(10,2) DEFAULT NULL,
    IN p_prezzo_max NUMERIC(10,2) DEFAULT NULL
)
RETURNS TABLE (
    id_natante INTEGER,
    id_corsa INTEGER,
    porto_partenza VARCHAR(20),
    porto_arrivo VARCHAR(20),
    orario_partenza TIME,
    orario_arrivo TIME,
    annullata BOOLEAN,
    ritardo INTERVAL,
    prezzo NUMERIC(10,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        CASE 
            WHEN p_tipo_natante = 'Motonave' THEN em.id_motonave
            WHEN p_tipo_natante = 'Aliscafo' THEN ea.id_aliscafo
            WHEN p_tipo_natante = 'Traghetto' THEN et.id_traghetto
            ELSE COALESCE(em.id_motonave, ea.id_aliscafo, et.id_traghetto)
        END AS id_natante,
        c.id_corsa, c.porto_partenza, c.porto_arrivo, 
        c.orario_partenza, c.orario_arrivo,
        c.annullata, c.ritardo,
        c.prezzo_intero AS prezzo
    FROM corsa c
    LEFT JOIN effettua_motonave em ON c.id_corsa = em.id_corsa
    LEFT JOIN effettua_aliscafo ea ON c.id_corsa = ea.id_corsa
    LEFT JOIN effettua_traghetto et ON c.id_corsa = et.id_corsa
    LEFT JOIN opera o ON c.id_corsa = o.id_corsa
    LEFT JOIN effettua_giorno eg ON c.id_corsa = eg.id_corsa
    LEFT JOIN periodo p ON o.id_periodo = p.id_periodo
    WHERE c.porto_partenza = p_porto_partenza
      AND c.porto_arrivo = p_porto_arrivo
      AND (EXTRACT(EPOCH FROM (c.orario_partenza - p_orario_consulta)) / 60) <= 1440 -- Differenza in minuti entro 24 ore
      AND p_giorno IN (SELECT nome FROM effettua_giorno WHERE eg.id_corsa = c.id_corsa)
      AND (p_prezzo_min IS NULL OR c.prezzo_intero >= p_prezzo_min)
      AND (p_prezzo_max IS NULL OR c.prezzo_intero <= p_prezzo_max);

END;
$$ LANGUAGE plpgsql;




-- 2
CREATE OR REPLACE FUNCTION calcola_prezzo_biglietto(
    IN p_id_corsa INTEGER,
    IN p_codice_fiscale CHAR(16),
    IN p_peso_bagaglio FLOAT,
    IN p_numero INT,
    IN p_data DATE,
    IN p_sovraprezzo_automezzo BOOLEAN,
    IN p_anno_produzione_automezzo INT,
    IN p_targa_automezzo CHAR(7),
    IN p_marca_automezzo VARCHAR(20),
    IN p_tipo_automezzo VARCHAR(20)
)
RETURNS TABLE (
    prezzo_totale NUMERIC(10, 2),
    id_prenotazione_out INTEGER
)
AS $$
DECLARE
    v_eta INTEGER;
    v_prezzo_base NUMERIC(10, 2);
    v_sovraprezzo_bagaglio NUMERIC(10, 2);
    v_sovraprezzo_periodo NUMERIC(10, 2);
    v_sovraprezzo_automezzo NUMERIC(10, 2) := 0.00;
    v_posti_disponibili INTEGER;
    v_capacita_automezzi INTEGER;
    v_prezzo_totale NUMERIC(10, 2);
    v_id_intero INT;
    v_id_ridotto INT;
    v_sovraprezzo BOOLEAN;
    v_id_prenotazione_var INT;
    v_id_natante INT;
    v_targa_automezzo CHAR(7); 
BEGIN
    -- Ottenere l'età del passeggero dalla tabella passeggero
    SELECT età INTO v_eta
    FROM passeggero
    WHERE codice_fiscale = p_codice_fiscale;

    -- Ottenere il prezzo base dalla corsa
    SELECT
        CASE
            WHEN v_eta < 10 OR v_eta > 60 THEN prezzo_ridotto
            ELSE prezzo_intero
        END
    INTO v_prezzo_base
    FROM corsa
    WHERE id_corsa = p_id_corsa;

    -- Calcolare il sovraprezzo del bagaglio
    IF p_peso_bagaglio > 10.00 THEN
        v_sovraprezzo_bagaglio := 5.00; -- Sovraprezzo di 5 per bagagli sopra i 10 kg
        v_sovraprezzo := TRUE;
    ELSE
        v_sovraprezzo_bagaglio := 0.00;
    END IF;

    IF p_numero > 1 THEN
        v_sovraprezzo_bagaglio := p_numero * 5.00; -- Sovraprezzo di 5 per ogni bagaglio in più 
        v_sovraprezzo := TRUE;
    END IF;

    -- Calcolare il sovraprezzo per il periodo (es. estate)
    IF EXTRACT(MONTH FROM p_data) IN (6, 7, 8) THEN
        v_sovraprezzo_periodo := 10.00; -- Sovraprezzo di 10 nei mesi estivi
        v_sovraprezzo := TRUE;
    ELSE
        v_sovraprezzo_periodo := 0.00;
    END IF;

    -- Ottenere i posti disponibili e la capacità automezzi dalla tabella della corsa
    IF EXISTS (
        SELECT 1
        FROM effettua_motonave
        WHERE id_corsa = p_id_corsa
    ) THEN
        -- Caso motonave
        SELECT capacità_persone INTO v_posti_disponibili
        FROM motonave
        WHERE id_motonave = (
            SELECT id_motonave
            FROM effettua_motonave
            WHERE id_corsa = p_id_corsa
            LIMIT 1
        );
    ELSIF EXISTS (
        SELECT 1
        FROM effettua_aliscafo
        WHERE id_corsa = p_id_corsa
    ) THEN
        -- Caso aliscafo
        SELECT capacità_persone INTO v_posti_disponibili
        FROM aliscafo
        WHERE id_aliscafo = (
            SELECT id_aliscafo
            FROM effettua_aliscafo
            WHERE id_corsa = p_id_corsa
            LIMIT 1
        );
    ELSIF EXISTS (
        SELECT 1
        FROM effettua_traghetto
        WHERE id_corsa = p_id_corsa
    ) THEN
        -- Caso traghetto
        SELECT capacità_persone, capacità_automezzi INTO v_posti_disponibili, v_capacita_automezzi
        FROM traghetto
        WHERE id_traghetto = (
            SELECT id_traghetto
            FROM effettua_traghetto
            WHERE id_corsa = p_id_corsa
            LIMIT 1
 
        );
END IF;

        -- Verificare se ci sono posti disponibili
        IF v_posti_disponibili > 0 THEN
            -- Sovraprezzo per l'automezzo se specificato
            IF p_sovraprezzo_automezzo THEN
                -- Verificare se ci sono posti disponibili per l'automezzo
                IF v_capacita_automezzi > 0 THEN
                    v_sovraprezzo_automezzo := 10.00;
                ELSE
                    -- Posti per automezzi esauriti, impedisce la prenotazione
                    RAISE EXCEPTION 'Posti automezzi esauriti per questa corsa';
                END IF;
            END IF;

            -- Sommare tutti i componenti per ottenere il prezzo finale
            v_prezzo_totale := v_prezzo_base + v_sovraprezzo_bagaglio + v_sovraprezzo_periodo + v_sovraprezzo_automezzo;

            -- Trova gli ID di biglietto_intero e biglietto_ridotto
            SELECT id_intero, id_ridotto
            INTO v_id_intero, v_id_ridotto
            FROM corsa
            WHERE id_corsa = p_id_corsa;

            IF v_eta < 10 OR v_eta > 60 THEN
                -- Aggiorna il prezzo in biglietto_ridotto
                UPDATE biglietto_ridotto
                SET prezzo = v_prezzo_totale
                WHERE id_ridotto = v_id_ridotto;
            ELSE
                -- Aggiorna il prezzo in biglietto_intero
                UPDATE biglietto_intero
                SET prezzo = v_prezzo_totale
                WHERE id_intero = v_id_intero;
            END IF;

            -- Crea la prenotazione
            INSERT INTO prenotazione (data) VALUES (p_data);

            -- Ottenere l'ultimo id_prenotazione inserito
            SELECT MAX(id_prenotazione) INTO v_id_prenotazione_var FROM prenotazione;

            -- Inserisce i dati relativi al bagaglio
            INSERT INTO bagaglio (numero,peso)
            VALUES(p_numero,p_peso_bagaglio);

            INSERT INTO aggiunge_bagaglio(sovraprezzo,prezzo,id_prenotazione)
            VALUES(v_sovraprezzo,v_sovraprezzo_bagaglio,v_id_prenotazione_var);
IF EXISTS (
        SELECT 1
        FROM effettua_traghetto
        WHERE id_corsa = p_id_corsa
    )  AND p_sovraprezzo_automezzo THEN
            -- Inserisci dati relativi all'automezzo nella tabella automezzo
            INSERT INTO automezzo (anno_produzione, targa, marca, tipo)
            VALUES (p_anno_produzione_automezzo, p_targa_automezzo, p_marca_automezzo, p_tipo_automezzo);

            -- Assegna la targa dell'automezzo
            v_targa_automezzo := p_targa_automezzo;

            -- Aggiungi record nella tabella aggiunge_automezzo
            INSERT INTO aggiunge_automezzo (sovraprezzo, prezzo, id_prenotazione, targa)
            VALUES (TRUE, v_sovraprezzo_automezzo, v_id_prenotazione_var, v_targa_automezzo);

           
END IF;
            -- Assegna l'ID del natante corretto in base al tipo di natante associato alla corsa
            IF EXISTS (
                SELECT 1
                FROM effettua_motonave
                WHERE id_corsa = p_id_corsa
            ) THEN
                SELECT id_motonave INTO v_id_natante
                FROM effettua_motonave
                WHERE id_corsa = p_id_corsa
                LIMIT 1;
                -- Inserisci nella tabella trasporta_motonave
                INSERT INTO trasporta_motonave (codice_fiscale, id_motonave)
                VALUES (p_codice_fiscale, v_id_natante);


             ELSIF EXISTS (
                SELECT 1
                FROM effettua_traghetto
                WHERE id_corsa = p_id_corsa
            ) THEN
                SELECT id_traghetto INTO v_id_natante
                FROM effettua_traghetto
                WHERE id_corsa = p_id_corsa
                LIMIT 1;
                -- Inserisci nella tabella trasporta_traghetto
                INSERT INTO trasporta_traghetto (codice_fiscale, id_traghetto)
                VALUES (p_codice_fiscale, v_id_natante);
         

            ELSIF EXISTS (
                SELECT 1
                FROM effettua_aliscafo
                WHERE id_corsa = p_id_corsa
            ) THEN
                SELECT id_aliscafo INTO v_id_natante
                FROM effettua_aliscafo
                WHERE id_corsa = p_id_corsa
                LIMIT 1;
                -- Inserisci nella tabella trasporta_aliscafo
                INSERT INTO trasporta_aliscafo (codice_fiscale, id_aliscafo)
                VALUES (p_codice_fiscale, v_id_natante);
   END IF;
           

            IF  p_sovraprezzo_automezzo THEN
                INSERT INTO trasporta_traghetto_automezzo(id_traghetto,targa)
                VALUES(v_id_natante,v_targa_automezzo);
            END IF;

            -- Chiamare la procedura effettua con l'id_prenotazione appena creato
            INSERT INTO effettua (id_prenotazione, codice_fiscale, sovraprezzo, prezzo)
            VALUES (v_id_prenotazione_var, p_codice_fiscale, v_sovraprezzo, v_prezzo_totale);

            -- Restituisci il prezzo totale e l'id_prenotazione
            RETURN QUERY SELECT v_prezzo_totale, v_id_prenotazione_var;

        ELSE
            -- Posti esauriti, impedisce la prenotazione
            RAISE EXCEPTION 'Posti esauriti per questa corsa';
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;


									--  PROCEDURE


-- 1 
CREATE OR REPLACE PROCEDURE annulla_prenotazione(IN p_id_prenotazione INT)
AS $$
DECLARE
    v_id_natante INT;
BEGIN
    -- Trova l'associazione con il motonave
    SELECT id_motonave INTO v_id_natante
    FROM trasporta_motonave
    WHERE codice_fiscale = (
        SELECT codice_fiscale
        FROM effettua
        WHERE id_prenotazione = p_id_prenotazione
        LIMIT 1
    )
    LIMIT 1;

    IF v_id_natante IS NOT NULL THEN
        -- Rimuovi l'associazione con il motonave
        DELETE FROM trasporta_motonave
        WHERE codice_fiscale = (
            SELECT codice_fiscale
            FROM effettua
            WHERE id_prenotazione = p_id_prenotazione
            LIMIT 1
        );
    ELSE
        -- Trova l'associazione con l'aliscafo
        SELECT id_aliscafo INTO v_id_natante
        FROM trasporta_aliscafo
        WHERE codice_fiscale = (
            SELECT codice_fiscale
            FROM effettua
            WHERE id_prenotazione = p_id_prenotazione
            LIMIT 1
        )
        LIMIT 1;

        IF v_id_natante IS NOT NULL THEN
            -- Rimuovi l'associazione con l'aliscafo
            DELETE FROM trasporta_aliscafo
            WHERE codice_fiscale = (
                SELECT codice_fiscale
                FROM effettua
                WHERE id_prenotazione = p_id_prenotazione
                LIMIT 1
            );
        ELSE
            -- Rimuovi l'associazione con il traghetto
            DELETE FROM trasporta_traghetto
            WHERE codice_fiscale = (
                SELECT codice_fiscale
                FROM effettua
                WHERE id_prenotazione = p_id_prenotazione
                LIMIT 1
            );
        END IF;
    END IF;

    -- Rimuovi l'associazione in assegna_ridotto
    DELETE FROM assegna_ridotto
    WHERE id_prenotazione = p_id_prenotazione;

    -- Rimuovi l'associazione in assegna_intero
    DELETE FROM assegna_intero
    WHERE id_prenotazione = p_id_prenotazione;

    -- Rimuovi l'associazione in aggiunge_bagaglio
    DELETE FROM aggiunge_bagaglio
    WHERE id_prenotazione = p_id_prenotazione;

    -- Rimuovi l'associazione in aggiunge_automezzo
    DELETE FROM aggiunge_automezzo
    WHERE id_prenotazione = p_id_prenotazione;

    -- Rimuovi l'associazione dalla tabella effettua
    DELETE FROM effettua
    WHERE id_prenotazione = p_id_prenotazione;

    -- Rimuovi la prenotazione
    DELETE FROM prenotazione
    WHERE id_prenotazione = p_id_prenotazione;
END;
$$ LANGUAGE plpgsql;


-- 2
CREATE OR REPLACE PROCEDURE inserisci_natante(
    IN p_nome_compagnia VARCHAR(20),
    IN p_anno_produzione INT,
    IN p_modello VARCHAR(20),
    IN p_velocità_massima INT,
    IN p_capacità_persone INT,
    IN p_capacità_automezzi INT DEFAULT NULL,
    IN p_tipo_natante VARCHAR(20) DEFAULT NULL
)
AS $$
BEGIN
    -- Inserisci il natante nella tabella corrispondente
    IF p_tipo_natante = 'Motonave' THEN
        INSERT INTO motonave (anno_produzione, modello, velocità_massima, capacità_persone)
        VALUES (p_anno_produzione, p_modello, p_velocità_massima, p_capacità_persone);
        
        INSERT INTO possiede_motonave (nome, id_motonave)
        VALUES (p_nome_compagnia, currval('motonave_id_motonave_seq'));
    ELSIF p_tipo_natante = 'Traghetto' THEN
        INSERT INTO traghetto (anno_produzione, modello, velocità_massima, capacità_persone, capacità_automezzi)
        VALUES (p_anno_produzione, p_modello, p_velocità_massima, p_capacità_persone, p_capacità_automezzi);
        
        INSERT INTO possiede_traghetto (nome, id_traghetto)
        VALUES (p_nome_compagnia, currval('traghetto_id_traghetto_seq'));
    ELSIF p_tipo_natante = 'Aliscafo' THEN
        INSERT INTO aliscafo (anno_produzione, modello, velocità_massima, capacità_persone)
        VALUES (p_anno_produzione, p_modello, p_velocità_massima, p_capacità_persone);
        
        INSERT INTO possiede_aliscafo (nome, id_aliscafo)
        VALUES (p_nome_compagnia, currval('aliscafo_id_aliscafo_seq'));
    ELSE
        -- Gestisci altri tipi di natanti se necessario
        RAISE EXCEPTION 'Tipo di natante non supportato: %', p_tipo_natante;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- 3
CREATE OR REPLACE PROCEDURE inserisci_corsa(
    p_nuovo_porto_partenza VARCHAR(20),
    p_nuovo_porto_arrivo VARCHAR(20),
    p_nuovo_orario_partenza TIME,
    p_nuovo_orario_arrivo TIME,
    p_nuovo_tipo_natante VARCHAR(20),
    p_nuovo_giorno VARCHAR[],
    p_nuovo_prezzo_intero NUMERIC(10, 2),
    p_nome_compagnia VARCHAR(20),
    p_scali BOOLEAN,
    p_porti_scali VARCHAR[],
    p_orari_partenza_scali TIME[],
    p_orari_arrivo_scali TIME[],
    p_prezzi_scali NUMERIC[],
    p_data_inizio_periodo DATE,
    p_data_fine_periodo DATE
)
AS $$
DECLARE
    v_id_natante INT;
    v_id_corsa INT;
    v_id_periodo INT;
    v_numero_scali INT;
    v_prezzo_ridotto NUMERIC(10, 2);
    v_id_intero INT;
    v_id_ridotto INT;
    v_nome_giorno VARCHAR(20);
    v_numero_giorni INT;
BEGIN
    -- Trova l'ID del natante nella tabella corrispondente (limitato a 1)
IF p_nuovo_tipo_natante = 'motonave' THEN
    SELECT id_motonave INTO v_id_natante
    FROM possiede_motonave
    WHERE nome = p_nome_compagnia
        AND NOT EXISTS (
            SELECT 1
            FROM effettua_motonave em
            JOIN corsa c ON em.id_corsa = c.id_corsa
            WHERE em.id_motonave = possiede_motonave.id_motonave
              AND ((c.orario_partenza >= p_nuovo_orario_partenza AND c.orario_partenza <= p_nuovo_orario_arrivo) OR
                   (c.orario_arrivo >= p_nuovo_orario_partenza AND c.orario_arrivo <= p_nuovo_orario_arrivo))
        )
    LIMIT 1;
ELSIF p_nuovo_tipo_natante = 'aliscafo' THEN
    SELECT id_aliscafo INTO v_id_natante
    FROM possiede_aliscafo
    WHERE nome = p_nome_compagnia
        AND NOT EXISTS (
            SELECT 1
            FROM effettua_aliscafo ea
            JOIN corsa c ON ea.id_corsa = c.id_corsa
            WHERE ea.id_aliscafo = possiede_aliscafo.id_aliscafo
              AND ((c.orario_partenza >= p_nuovo_orario_partenza AND c.orario_partenza <= p_nuovo_orario_arrivo) OR
                   (c.orario_arrivo >= p_nuovo_orario_partenza AND c.orario_arrivo <= p_nuovo_orario_arrivo))
        )
    LIMIT 1;
ELSIF p_nuovo_tipo_natante = 'traghetto' THEN
    SELECT id_traghetto INTO v_id_natante
    FROM possiede_traghetto
    WHERE nome = p_nome_compagnia
        AND NOT EXISTS (
            SELECT 1
            FROM effettua_traghetto et
            JOIN corsa c ON et.id_corsa = c.id_corsa
            WHERE et.id_traghetto = possiede_traghetto.id_traghetto
              AND ((c.orario_partenza >= p_nuovo_orario_partenza AND c.orario_partenza <= p_nuovo_orario_arrivo) OR
                   (c.orario_arrivo >= p_nuovo_orario_partenza AND c.orario_arrivo <= p_nuovo_orario_arrivo))
        )
    LIMIT 1;
END IF;

    -- Inserisci il periodo se specificato
    IF p_data_inizio_periodo IS NOT NULL AND p_data_fine_periodo IS NOT NULL THEN
        INSERT INTO periodo (data_inizio, data_fine)
        VALUES (p_data_inizio_periodo, p_data_fine_periodo)
        RETURNING id_periodo INTO v_id_periodo;
    END IF;

    -- Calcola il prezzo ridotto come la metà del prezzo intero
    v_prezzo_ridotto := p_nuovo_prezzo_intero / 2;

    -- Inserisci i biglietti intero e ridotto
    INSERT INTO biglietto_intero (prezzo) VALUES (p_nuovo_prezzo_intero) RETURNING id_intero INTO v_id_intero;
    INSERT INTO biglietto_ridotto (prezzo) VALUES (v_prezzo_ridotto) RETURNING id_ridotto INTO v_id_ridotto;

    -- Inserisci la tratta principale senza scali
    INSERT INTO corsa (porto_partenza, porto_arrivo, orario_partenza, orario_arrivo, nome_compagnia, prezzo_intero, prezzo_ridotto, scalo, id_intero, id_ridotto)
    VALUES (p_nuovo_porto_partenza, p_nuovo_porto_arrivo, p_nuovo_orario_partenza, p_nuovo_orario_arrivo, p_nome_compagnia, p_nuovo_prezzo_intero, v_prezzo_ridotto, p_scali, v_id_intero, v_id_ridotto)
    RETURNING id_corsa INTO v_id_corsa;


    v_numero_giorni := array_length(p_nuovo_giorno, 1);
FOR j IN 1..v_numero_giorni LOOP
        -- Verifica se la riga esiste già
        IF NOT EXISTS (SELECT 1 FROM effettua_giorno WHERE id_corsa = v_id_corsa AND nome = p_nuovo_giorno[j]) THEN
        -- Inserisci il giorno solo se non esiste già
        INSERT INTO effettua_giorno (id_corsa, nome)
        VALUES (v_id_corsa, p_nuovo_giorno[j]) RETURNING nome INTO v_nome_giorno;
        END IF;
        END LOOP;

    -- Associa il natante alla tratta principale
    IF p_nuovo_tipo_natante = 'motonave' THEN
        INSERT INTO effettua_motonave (id_corsa, id_motonave)
        VALUES (v_id_corsa, v_id_natante);
    ELSIF p_nuovo_tipo_natante = 'aliscafo' THEN
        INSERT INTO effettua_aliscafo (id_corsa, id_aliscafo)
        VALUES (v_id_corsa, v_id_natante);
    ELSIF p_nuovo_tipo_natante = 'traghetto' THEN
        INSERT INTO effettua_traghetto (id_corsa, id_traghetto)
        VALUES (v_id_corsa, v_id_natante);
    END IF;

    -- Associa la corsa al periodo
    IF v_id_periodo IS NOT NULL THEN
        INSERT INTO opera (id_corsa, id_periodo)
        VALUES (v_id_corsa, v_id_periodo);
    END IF;

  -- ...
-- Inserisci gli scali se specificato
IF p_scali AND array_length(p_porti_scali, 1) IS NOT NULL THEN
    v_numero_scali := array_length(p_porti_scali, 1);



    FOR i IN 1..v_numero_scali LOOP
        -- Inserisci i biglietti intero e ridotto per lo scalo
        INSERT INTO biglietto_intero (prezzo) VALUES (p_prezzi_scali[i]) RETURNING id_intero INTO v_id_intero;
        INSERT INTO biglietto_ridotto (prezzo) VALUES (p_prezzi_scali[i] / 2) RETURNING id_ridotto INTO v_id_ridotto;

        -- Inserisci la tratta dello scalo
        IF i = 1 THEN
            INSERT INTO corsa (porto_partenza, porto_arrivo, orario_partenza, orario_arrivo, nome_compagnia, prezzo_intero, prezzo_ridotto, scalo, id_intero, id_ridotto)
            VALUES (p_nuovo_porto_partenza, p_porti_scali[i], p_nuovo_orario_partenza, p_orari_partenza_scali[i], p_nome_compagnia, p_prezzi_scali[i], p_prezzi_scali[i] / 2, p_scali, v_id_intero, v_id_ridotto)
            RETURNING id_corsa INTO v_id_corsa;
       

        FOR j IN 1..v_numero_giorni LOOP
        -- Verifica se la riga esiste già
        IF NOT EXISTS (SELECT 1 FROM effettua_giorno WHERE id_corsa = v_id_corsa AND nome = p_nuovo_giorno[j]) THEN
        -- Inserisci il giorno solo se non esiste già
        INSERT INTO effettua_giorno (id_corsa, nome)
        VALUES (v_id_corsa, p_nuovo_giorno[j]) RETURNING nome INTO v_nome_giorno;
        END IF;
        END LOOP;

        ELSE

            INSERT INTO corsa (porto_partenza, porto_arrivo, orario_partenza, orario_arrivo, nome_compagnia, prezzo_intero, prezzo_ridotto, scalo, id_intero, id_ridotto)
            VALUES (p_porti_scali[i-1], p_porti_scali[i], p_orari_partenza_scali[i-1], p_orari_arrivo_scali[i-1], p_nome_compagnia, p_prezzi_scali[i], p_prezzi_scali[i] / 2, p_scali, v_id_intero, v_id_ridotto)
            RETURNING id_corsa INTO v_id_corsa;

FOR j IN 1..v_numero_giorni LOOP
    -- Verifica se la riga esiste già
    IF NOT EXISTS (SELECT 1 FROM effettua_giorno WHERE id_corsa = v_id_corsa AND nome = p_nuovo_giorno[j]) THEN
        -- Inserisci il giorno solo se non esiste già
        INSERT INTO effettua_giorno (id_corsa, nome)
        VALUES (v_id_corsa, p_nuovo_giorno[j]) RETURNING nome INTO v_nome_giorno;
    END IF;
END LOOP;

        END IF;




        --Periodo alla corsa
        IF v_id_periodo IS NOT NULL THEN
        INSERT INTO opera (id_corsa, id_periodo)
        VALUES (v_id_corsa, v_id_periodo);
        END IF;

        -- Associa il natante allo scalo
        IF p_nuovo_tipo_natante = 'motonave' THEN
            INSERT INTO effettua_motonave (id_corsa, id_motonave)
            VALUES (v_id_corsa, v_id_natante);
        ELSIF p_nuovo_tipo_natante = 'aliscafo' THEN
            INSERT INTO effettua_aliscafo (id_corsa, id_aliscafo)
            VALUES (v_id_corsa, v_id_natante);
        ELSIF p_nuovo_tipo_natante = 'traghetto' THEN
            INSERT INTO effettua_traghetto (id_corsa, id_traghetto)
            VALUES (v_id_corsa, v_id_natante);
        END IF;
    END LOOP;

    -- Inserisci l'ultima tratta tra l'ultimo scalo e il porto finale
    INSERT INTO biglietto_intero (prezzo) VALUES (p_prezzi_scali[v_numero_scali + 1]) RETURNING id_intero INTO v_id_intero;
    INSERT INTO biglietto_ridotto (prezzo) VALUES (p_prezzi_scali[v_numero_scali + 1] / 2) RETURNING id_ridotto INTO v_id_ridotto;

    INSERT INTO corsa (porto_partenza, porto_arrivo, orario_partenza, orario_arrivo, nome_compagnia, prezzo_intero, prezzo_ridotto, scalo, id_intero, id_ridotto)
    VALUES (p_porti_scali[v_numero_scali], p_nuovo_porto_arrivo, p_orari_partenza_scali[v_numero_scali], p_orari_arrivo_scali[v_numero_scali], p_nome_compagnia, p_prezzi_scali[v_numero_scali + 1], p_prezzi_scali[v_numero_scali + 1] / 2, p_scali, v_id_intero, v_id_ridotto)
    RETURNING id_corsa INTO v_id_corsa;

    -- Associa il natante all'ultimo scalo
    IF p_nuovo_tipo_natante = 'motonave' THEN
        INSERT INTO effettua_motonave (id_corsa, id_motonave)
        VALUES (v_id_corsa, v_id_natante);
    ELSIF p_nuovo_tipo_natante = 'aliscafo' THEN
        INSERT INTO effettua_aliscafo (id_corsa, id_aliscafo)
        VALUES (v_id_corsa, v_id_natante);
    ELSIF p_nuovo_tipo_natante = 'traghetto' THEN
        INSERT INTO effettua_traghetto (id_corsa, id_traghetto)
        VALUES (v_id_corsa, v_id_natante);
    END IF;

    --Periodo alla corsa (ultima)
        IF v_id_periodo IS NOT NULL THEN
        INSERT INTO opera (id_corsa, id_periodo)
        VALUES (v_id_corsa, v_id_periodo);
        END IF;

   FOR j IN 1..v_numero_giorni LOOP
    -- Verifica se la riga esiste già
    IF NOT EXISTS (SELECT 1 FROM effettua_giorno WHERE id_corsa = v_id_corsa AND nome = p_nuovo_giorno[j]) THEN
        -- Inserisci il giorno solo se non esiste già
        INSERT INTO effettua_giorno (id_corsa, nome)
        VALUES (v_id_corsa, p_nuovo_giorno[j]) RETURNING nome INTO v_nome_giorno;
    END IF;
END LOOP;
       

END IF;
END;
$$ LANGUAGE plpgsql;





-- 4
CREATE OR REPLACE PROCEDURE aggiorna_informazioni_corsa(
    p_id_corsa INT,
    p_annullata BOOLEAN,
    p_ritardo INTERVAL
)
AS $$
BEGIN
    -- Aggiorna le informazioni sulla corsa
    UPDATE corsa
    SET annullata = p_annullata, ritardo = p_ritardo
    WHERE id_corsa = p_id_corsa;
END;
$$ LANGUAGE plpgsql;

INSERT INTO compagnia (nome, telefono, email, sitoweb, social)
VALUES
  ('MarinaNaviga', 123456789, 'info@marinanaviga.com', 'www.marinanaviga.com', '@marinanaviga'),
  ('OndaBlu', 987654321, 'info@ondablu.com', 'www.ondablu.com', '@ondablu'),
  ('VelieriMare', 111223344, 'info@velierimare.com', 'www.velierimare.com', '@velierimare'),
  ('TrasportoMarino', 555666777, 'info@trasportomarino.com', 'www.trasportomarino.com', '@trasportomarino'),
  ('NavigaVeloce', 888999000, 'info@navigaveloce.com', 'www.navigaveloce.com', '@navigaveloce'),
  ('GolfoBlu', 333444555, 'info@golfoblu.com', 'www.golfoblu.com', '@golfoblu'),
  ('MarLigure', 666777888, 'info@marligure.com', 'www.marligure.com', '@marligure'),
  ('NavigaMondo', 999000111, 'info@navigamondo.com', 'www.navigamondo.com', '@navigamondo'),
  ('CompagniaMarittima', 222333444, 'info@compagniamarittima.com', 'www.compagniamarittima.com', '@compagniamarittima'),
  ('MareProfondo', 444555666, 'info@mareprofondo.com', 'www.mareprofondo.com', '@mareprofondo');


-- Chiamate alla procedura per la compagnia 'MarinaNaviga'
CALL inserisci_natante('MarinaNaviga', 2000, 'Modello1', 30, 100, NULL, 'Motonave');
CALL inserisci_natante('MarinaNaviga', 2005, 'Modello2', 35, 120, 60, 'Traghetto');
CALL inserisci_natante('MarinaNaviga', 2010, 'Modello3', 40, 80, NULL, 'Aliscafo');
CALL inserisci_natante('MarinaNaviga', 2015, 'Modello4', 25, 150, NULL, 'Motonave');
CALL inserisci_natante('MarinaNaviga', 2020, 'Modello5', 45, 90, 50, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'OndaBlu'
CALL inserisci_natante('OndaBlu', 2001, 'Modello1', 40, 110, NULL, 'Motonave');
CALL inserisci_natante('OndaBlu', 2006, 'Modello2', 38, 100, 50, 'Traghetto');
CALL inserisci_natante('OndaBlu', 2011, 'Modello3', 42, 90, NULL, 'Aliscafo');
CALL inserisci_natante('OndaBlu', 2016, 'Modello2', 28, 130, NULL, 'Motonave');
CALL inserisci_natante('OndaBlu', 2021, 'Modello3', 48, 80, 60, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'VelieriMare'
CALL inserisci_natante('VelieriMare', 2002, 'Modello2', 35, 120, NULL, 'Motonave');
CALL inserisci_natante('VelieriMare', 2007, 'Modello2', 30, 110, 45, 'Traghetto');
CALL inserisci_natante('VelieriMare', 2012, 'Modello1', 40, 100, NULL, 'Aliscafo');
CALL inserisci_natante('VelieriMare', 2017, 'Modello3', 25, 140, NULL, 'Motonave');
CALL inserisci_natante('VelieriMare', 2022, 'Modello4', 42, 95, 50, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'TrasportoMarino'
CALL inserisci_natante('TrasportoMarino', 2003, 'Modello4', 38, 130, NULL, 'Motonave');
CALL inserisci_natante('TrasportoMarino', 2008, 'Modello4', 32, 120, 55, 'Traghetto');
CALL inserisci_natante('TrasportoMarino', 2013, 'Modello3', 45, 85, NULL, 'Aliscafo');
CALL inserisci_natante('TrasportoMarino', 2018, 'Modello1', 27, 160, NULL, 'Motonave');
CALL inserisci_natante('TrasportoMarino', 2023, 'Modello2', 50, 75, 55, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'NavigaVeloce'
CALL inserisci_natante('NavigaVeloce', 2004, 'Modello1', 36, 110, NULL, 'Motonave');
CALL inserisci_natante('NavigaVeloce', 2009, 'Modello2', 33, 100, 45, 'Traghetto');
CALL inserisci_natante('NavigaVeloce', 2014, 'Modello3', 38, 95, NULL, 'Aliscafo');
CALL inserisci_natante('NavigaVeloce', 2019, 'Modello2', 26, 120, NULL, 'Motonave');
CALL inserisci_natante('NavigaVeloce', 2024, 'Modello2', 44, 85, 50, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'GolfoBlu'
CALL inserisci_natante('GolfoBlu', 2005, 'Modello2', 39, 115, NULL, 'Motonave');
CALL inserisci_natante('GolfoBlu', 2010, 'Modello2', 34, 105, 40, 'Traghetto');
CALL inserisci_natante('GolfoBlu', 2015, 'Modello2', 39, 100, NULL, 'Aliscafo');
CALL inserisci_natante('GolfoBlu', 2020, 'Modello2', 29, 135, NULL, 'Motonave');
CALL inserisci_natante('GolfoBlu', 2025, 'Modello3', 46, 88, 55, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'MarLigure'
CALL inserisci_natante('MarLigure', 2006, 'Modello1', 37, 125, NULL, 'Motonave');
CALL inserisci_natante('MarLigure', 2011, 'Modello3', 31, 115, 50, 'Traghetto');
CALL inserisci_natante('MarLigure', 2016, 'Modello3', 44, 92, NULL, 'Aliscafo');
CALL inserisci_natante('MarLigure', 2021, 'Modello4', 28, 155, NULL, 'Motonave');
CALL inserisci_natante('MarLigure', 2026, 'Modello3', 48, 82, 60, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'NavigaMondo'
CALL inserisci_natante('NavigaMondo', 2007, 'Modello3', 35, 120, NULL, 'Motonave');
CALL inserisci_natante('NavigaMondo', 2012, 'Modello3', 30, 110, 50, 'Traghetto');
CALL inserisci_natante('NavigaMondo', 2017, 'Modello2', 42, 100, NULL, 'Aliscafo');
CALL inserisci_natante('NavigaMondo', 2022, 'Modello3', 25, 140, NULL, 'Motonave');
CALL inserisci_natante('NavigaMondo', 2027, 'Modello4', 42, 98, 50, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'CompagniaMarittima'
CALL inserisci_natante('CompagniaMarittima', 2008, 'Modello4', 38, 130, NULL, 'Motonave');
CALL inserisci_natante('CompagniaMarittima', 2013, 'Modello5', 32, 120, 50, 'Traghetto');
CALL inserisci_natante('CompagniaMarittima', 2018, 'Modello3', 45, 85, NULL, 'Aliscafo');
CALL inserisci_natante('CompagniaMarittima', 2023, 'Modello1', 27, 160, NULL, 'Motonave');
CALL inserisci_natante('CompagniaMarittima', 2028, 'Modello3', 50, 75, 55, 'Traghetto');

-- Chiamate alla procedura per la compagnia 'MareProfondo'
CALL inserisci_natante('MareProfondo', 2009, 'Modello4', 36, 110, NULL, 'Motonave');
CALL inserisci_natante('MareProfondo', 2014, 'Modello2', 33, 100, 50, 'Traghetto');
CALL inserisci_natante('MareProfondo', 2019, 'Modello2', 38, 95, NULL, 'Aliscafo');
CALL inserisci_natante('MareProfondo', 2024, 'Modello1', 26, 120, NULL, 'Motonave');
CALL inserisci_natante('MareProfondo', 2029, 'Modello2', 44, 85, 50, 'Traghetto');


-- Inserimento dei giorni nella tabella 'giorno'
INSERT INTO giorno (nome) VALUES 
    ('Lunedì'),
    ('Martedì'),
    ('Mercoledì'),
    ('Giovedì'),
    ('Venerdì'),
    ('Sabato'),
    ('Domenica');


CALL inserisci_corsa(
    'Napoli', 
    'Capri', 
    '12:00'::TIME, 
    '14:00'::TIME, 
    'traghetto', 
    ARRAY['Martedì', 'Mercoledì', 'Venerdì','Sabato','Domenica'], 
    50.00, 
    'OndaBlu', 
    TRUE, 
    ARRAY['Procida', 'Ischia'], 
    ARRAY['13:00'::TIME, '13:30'::TIME], 
    ARRAY['13:30'::TIME, '14:00'::TIME], 
    ARRAY[20.00, 20.00,10.00], 
    '2024-05-01'::DATE, 
    '2024-09-10'::DATE
);

CALL inserisci_corsa(
    'Genova',
    'Portofino',
    '10:30'::TIME,
    '12:30'::TIME,
    'traghetto',
    ARRAY['Lunedì', 'Giovedì', 'Sabato'],
    45.00,
    'MarinaNaviga',
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL,
    '2024-04-15'::DATE,
    '2024-09-30'::DATE
);

CALL inserisci_corsa(
    'Cagliari',
    'Villasimius',
    '11:15'::TIME,
    '13:15'::TIME,
    'motonave',
    ARRAY['Lunedì', 'Mercoledì', 'Venerdì', 'Domenica'],
    35.00,
    'VelieriMare',
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL,
    '2024-06-05'::DATE,
    '2024-09-15'::DATE
);


CALL inserisci_corsa(
    'Palermo',
    'Ustica',
    '09:30'::TIME,
    '11:30'::TIME,
    'aliscafo',
    ARRAY['Martedì', 'Mercoledì', 'Venerdì', 'Domenica'],
    40.00,
    'TrasportoMarino',
    TRUE,
    ARRAY['Cinisi', 'Terrasini'],
    ARRAY['10:00'::TIME, '10:30'::TIME],
    ARRAY['10:30'::TIME, '11:00'::TIME],
    ARRAY[10.00, 20.00, 10.00],
    '2024-05-10'::DATE,
    '2024-08-25'::DATE
);

CALL inserisci_corsa(
    'Civitavecchia',
    'Porto Santo Stefano',
    '11:00'::TIME,
    '13:00'::TIME,
    'traghetto',
    ARRAY['Lunedì', 'Mercoledì', 'Venerdì'],
    35.00,
    'NavigaVeloce',
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL,
    '2024-06-15'::DATE,
    '2024-09-20'::DATE
);


CALL inserisci_corsa(
    'Olbia',
    'La Maddalena',
    '14:00'::TIME,
    '16:00'::TIME,
    'motonave',
    ARRAY['Martedì', 'Giovedì', 'Sabato', 'Domenica'],
    40.00,
    'GolfoBlu',
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL,
    '2024-07-01'::DATE,
    '2024-09-30'::DATE
);


CALL inserisci_corsa(
    'Nice',
    'Portofino',
    '15:30'::TIME,
    '17:30'::TIME,
    'aliscafo',
    ARRAY['Mercoledì', 'Giovedì', 'Venerdì', 'Sabato'],
    55.00,
    'MarLigure',
    TRUE,
    ARRAY['Monaco', 'Sanremo'],
    ARRAY['16:00'::TIME, '16:30'::TIME],
    ARRAY['16:30'::TIME, '17:00'::TIME],
    ARRAY[20.00, 15.00, 15.00],
    '2024-07-15'::DATE,
    '2024-09-25'::DATE
);


CALL inserisci_corsa(
    'Venice',
    'Split',
    '10:45'::TIME,
    '13:45'::TIME,
    'traghetto',
    ARRAY['Lunedì', 'Giovedì', 'Sabato'],
    60.00,
    'NavigaMondo',
    TRUE,
    ARRAY['Rovinj', 'Pula'],
    ARRAY['11:30'::TIME, '12:00'::TIME],
    ARRAY['12:00'::TIME, '12:30'::TIME],
    ARRAY[30.00, 20.00, 10.00],
    '2024-08-01'::DATE,
    '2024-09-30'::DATE
);


CALL inserisci_corsa(
    'Bari',
    'Corfu',
    '12:00'::TIME,
    '16:00'::TIME,
    'motonave',
    ARRAY['Martedì', 'Giovedì', 'Sabato', 'Domenica'],
    70.00,
    'CompagniaMarittima',
    TRUE,
    ARRAY['Patras', 'Igoumenitsa'],
    ARRAY['13:30'::TIME, '14:00'::TIME],
    ARRAY['14:00'::TIME, '14:30'::TIME],
    ARRAY[30.00, 30.00, 10.00],
    '2024-08-15'::DATE,
    '2024-09-30'::DATE
);


CALL inserisci_corsa(
    'Athens',
    'Santorini',
    '09:30'::TIME,
    '14:30'::TIME,
    'aliscafo',
    ARRAY['Lunedì', 'Mercoledì', 'Venerdì', 'Domenica'],
    85.00,
    'MareProfondo',
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL,
    '2024-09-01'::DATE,
    '2024-09-30'::DATE
);


INSERT INTO passeggero (nome, cognome, età, codice_fiscale)
VALUES 
    ('Luca', 'Bianchi', 25, 'BNCLCU95M10H123X'),
    ('Anna', 'Verdi', 28, 'VRDANN88M45H789Y'),
    ('Giuseppe', 'Gialli', 35, 'GLPGSP75M22H456W'),
    ('Elena', 'Neri', 40, 'NREELN60M08H234V'),
    ('Alessio', 'Rosa', 22, 'RSLALS98M02H567U'),
    ('Francesca', 'Blu', 32, 'BLUFNC87M15H890I'),
    ('Davide', 'Arancio', 27, 'RNCADV89M03H432K'),
    ('Valentina', 'Marrone', 31, 'MRNVLN86M27H654L'),
    ('Roberto', 'Azzurro', 38, 'ZZRRTB80M12H987J'),
    ('Laura', 'Rosa', 26, 'RSALRA92M18H876C');



SELECT (calcola_prezzo_biglietto(
    3,
    'BNCLCU95M10H123X',
    15.5,
    2,
    '2024-05-02',
    TRUE,
    2020,
    'TT123YY',
    'Fiat',
    'Auto'
)).*;

SELECT (calcola_prezzo_biglietto(
    4,
    'VRDANN88M45H789Y',
    11.0,
    2,
    '2024-04-15',
    TRUE,
    2000,
    'AB123XY',
    'Fiat',
    'Auto'
)).*;

SELECT (calcola_prezzo_biglietto(
    6,
    'NREELN60M08H234V',
    11.0,
    1,
    '2024-05-10',
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL
)).*;


SELECT (calcola_prezzo_biglietto(
    5,
    'GLPGSP75M22H456W',
    11.0,
    1,
    '2024-06-07',
    FALSE,
    NULL,
    NULL,
    NULL,
    NULL
)).*;


SELECT (calcola_prezzo_biglietto(
    4,
    'RSLALS98M02H567U',
    11.0,
    2,
    '2024-04-15',
    TRUE,
    2001,
    'BB123YY',
    'Fiat',
    'Auto'
)).*;





