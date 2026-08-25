-- Table centrale : chaque point de vigilance détecté sur un azimut donné
CREATE TABLE points (
    id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    azimut         text        NOT NULL
                               CHECK (azimut IN (
                                   'calendrier_temps',
                                   'pilotage_projets',
                                   'carriere_opportunites',
                                   'management_equipe'
                               )),
    urgence        integer     NOT NULL CHECK (urgence BETWEEN 1 AND 5),
    ouvert_le      timestamptz NOT NULL DEFAULT now(),
    resolu_le      timestamptz,
    source         text        NOT NULL,
    libelle        text        NOT NULL,
    donnees_brutes jsonb
);

-- Table de journal : chaque passage de radar (tour de surveillance) avec sa charge calculée
CREATE TABLE tours (
    id               uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    declenche_le     timestamptz NOT NULL DEFAULT now(),
    phase            text        NOT NULL
                                 CHECK (phase IN ('check', 'constat', 'resolution')),
    charge_globale   numeric,
    charge_par_azimut jsonb
);

-- Table de contexte quotidien : poids et signaux permettant de moduler le calcul de charge du jour
CREATE TABLE contexte_journee (
    date          date    PRIMARY KEY,
    poids_journee numeric NOT NULL DEFAULT 1.0,
    poids_periode numeric NOT NULL DEFAULT 1.0,
    signaux       jsonb
);

-- Index pour accélérer les requêtes "points ouverts par azimut"
CREATE INDEX idx_points_azimut    ON points (azimut);
CREATE INDEX idx_points_resolu_le ON points (resolu_le);

-- Activation de Row Level Security sur les trois tables
ALTER TABLE points            ENABLE ROW LEVEL SECURITY;
ALTER TABLE tours             ENABLE ROW LEVEL SECURITY;
ALTER TABLE contexte_journee  ENABLE ROW LEVEL SECURITY;

-- Policy service_role : accès complet, toutes opérations (projet mono-utilisateur)
CREATE POLICY "service_role_all_points"
    ON points
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

CREATE POLICY "service_role_all_tours"
    ON tours
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

CREATE POLICY "service_role_all_contexte_journee"
    ON contexte_journee
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);
