-- Création de la base de données
CREATE DATABASE IF NOT EXISTS HotelManagement2025;
USE HotelManagement2025;

-- Création des tables
CREATE TABLE IF NOT EXISTS Hotel (
    IdHotel INT PRIMARY KEY,
    Ville VARCHAR(100),
    Pays VARCHAR(100),
    CodePostal INT
);

CREATE TABLE IF NOT EXISTS Client (
    IdClient INT PRIMARY KEY,
    Adresse VARCHAR(255),
    Ville VARCHAR(100),
    CodePostal INT,
    Email VARCHAR(100),
    Telephone VARCHAR(15),
    Nom VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Prestation (
    IdPrestation INT PRIMARY KEY,
    Prix INT,
    Description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS TypeChambre (
    IdTypeChambre INT PRIMARY KEY,
    Nom VARCHAR(50),
    Prix DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS Chambre (
    IdChambre INT PRIMARY KEY,
    Numero INT,
    Etage INT,
    EstOccupe BOOLEAN,
    IdHotel INT,
    IdTypeChambre INT,
    FOREIGN KEY (IdHotel) REFERENCES Hotel(IdHotel),
    FOREIGN KEY (IdTypeChambre) REFERENCES TypeChambre(IdTypeChambre)
);

CREATE TABLE IF NOT EXISTS Reservation (
    IdReservation INT PRIMARY KEY,
    DateDebut DATE,
    DateFin DATE,
    IdClient INT,
    IdChambre INT,
    FOREIGN KEY (IdClient) REFERENCES Client(IdClient),
    FOREIGN KEY (IdChambre) REFERENCES Chambre(IdChambre)
);

CREATE TABLE IF NOT EXISTS Evaluation (
    IdEvaluation INT PRIMARY KEY,
    DateEvaluation DATE,
    Note INT,
    Commentaire TEXT,
    IdClient INT,
    FOREIGN KEY (IdClient) REFERENCES Client(IdClient)
);

-- Insertion des données
INSERT IGNORE INTO Hotel VALUES
(1, 'Paris', 'France', 75001),
(2, 'Lyon', 'France', 69002);

INSERT IGNORE INTO Client VALUES
(1, '12 Rue de Paris', 'Paris', 75001, 'jean.dupont@email.fr', '0612345678', 'Jean Dupont'),
(2, '5 Avenue Victor Hugo', 'Lyon', 69002, 'marie.leroy@email.fr', '0623456789', 'Marie Leroy'),
(3, '8 Boulevard Saint-Michel', 'Marseille', 13005, 'paul.moreau@email.fr', '0634567890', 'Paul Moreau'),
(4, '27 Rue Nationale', 'Lille', 59800, 'lucie.martin@email.fr', '0645678901', 'Lucie Martin'),
(5, '3 Rue des Fleurs', 'Nice', 06000, 'emma.giraud@email.fr', '0656789012', 'Emma Giraud');



INSERT IGNORE INTO Prestation VALUES
(1, 15, 'Petit-déjeuner'),
(2, 30, 'Navette aéroport'),
(3, 0, 'Wi-Fi gratuit'),
(4, 50, 'Spa et bien-être'),
(5, 20, 'Parking sécurisé');

INSERT IGNORE INTO TypeChambre VALUES
(1, 'Simple', 80.00),
(2, 'Double', 120.00);

INSERT IGNORE INTO Chambre VALUES
(1, 201, 2, 0, 1, 1),
(2, 502, 5, 1, 1, 2),
(3, 305, 3, 0, 2, 1),
(4, 410, 4, 0, 2, 2),
(5, 104, 1, 1, 2, 2),
(6, 202, 2, 0, 1, 1),
(7, 307, 3, 1, 1, 2),
(8, 101, 1, 0, 1, 1);

INSERT IGNORE INTO Reservation VALUES
(1, '2025-06-15', '2025-06-18', 1, 1),
(2, '2025-07-01', '2025-07-05', 2, 2),
(3, '2025-08-10', '2025-08-14', 3, 3),
(4, '2025-09-05', '2025-09-07', 4, 4),
(5, '2025-09-20', '2025-09-25', 5, 5),
(7, '2025-11-12', '2025-11-14', 2, 7),
(9, '2026-01-15', '2026-01-18', 4, 4),
(10, '2026-02-01', '2026-02-05', 2, 2);

INSERT IGNORE INTO Evaluation VALUES
(1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1),
(2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2),
(3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 3),
(4, '2025-09-05', 5, 'Service impeccable, je recommande.', 4),
(5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 5);

-- Vérification des données
SELECT * FROM HotelManagement2025.Hotel;
SELECT * FROM HotelManagement2025.Client;
SELECT * FROM HotelManagement2025.Prestation;
SELECT * FROM HotelManagement2025.TypeChambre;
SELECT * FROM HotelManagement2025.Reservation;
SELECT * FROM HotelManagement2025.Evaluation;

-- Requêtes de la Question 3
-- a. Liste des réservations avec nom du client et ville de l'hôtel
SELECT r.IdReservation, c.Nom, h.Ville
FROM HotelManagement2025.Reservation r
JOIN HotelManagement2025.Client c ON r.IdClient = c.IdClient
JOIN HotelManagement2025.Chambre ch ON r.IdChambre = ch.IdChambre
JOIN HotelManagement2025.Hotel h ON ch.IdHotel = h.IdHotel;

-- b. Clients qui habitent à Paris
SELECT Nom, Adresse
FROM HotelManagement2025.Client
WHERE Ville = 'Paris';

-- c. Nombre de réservations par client
SELECT c.Nom, COUNT(r.IdReservation) as NombreReservations
FROM HotelManagement2025.Client c
LEFT JOIN HotelManagement2025.Reservation r ON c.IdClient = r.IdClient
GROUP BY c.IdClient, c.Nom;

-- d. Nombre de chambres par type
SELECT tc.Nom, COUNT(ch.IdChambre) as NombreChambres
FROM HotelManagement2025.TypeChambre tc
LEFT JOIN HotelManagement2025.Chambre ch ON tc.IdTypeChambre = ch.IdTypeChambre
GROUP BY tc.IdTypeChambre, tc.Nom;

-- e. Chambres non réservées pour une période donnée (ex. 2025-07-01 à 2025-07-05)
SELECT ch.IdChambre, ch.Numero, h.Ville
FROM HotelManagement2025.Chambre ch
JOIN HotelManagement2025.Hotel h ON ch.IdHotel = h.IdHotel
WHERE ch.IdChambre NOT IN (
    SELECT r.IdChambre
    FROM HotelManagement2025.Reservation r
    WHERE (r.DateDebut <= '2025-07-05' AND r.DateFin >= '2025-07-01')
);