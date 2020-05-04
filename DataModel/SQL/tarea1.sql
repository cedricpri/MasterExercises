DROP TABLE IF EXISTS ActorPelicula; --Used to remove the tables in the correct order to avoid a foreign key error when we run the script mutliple times 
DROP TABLE IF EXISTS Pelicula;
DROP TABLE IF EXISTS Pelicula2;
DROP TABLE IF EXISTS Pelicula3;
DROP TABLE IF EXISTS Director;
DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Types;

CREATE TABLE IF NOT EXISTS Director (
    iddirector int NOT NULL PRIMARY KEY CHECK (iddirector > 0), --A nice way to define primary keys is usually to use the autoincrement option but we did not study in class so far
    dni char NOT NULL UNIQUE,
    nombre char NOT NULL,
    apellido1 char NOT NULL,
    apellido2 char,
    fechaNacimiento date NOT NULL,
    fechaRegistro date NOT NULL CHECK (fechaRegistro > fechaNacimiento),
    fechaDeceso data CHECK (fechaDeceso > fechaNacimiento),
    enActivo bool NOT NULL CHECK (enActivo == 0 OR enActivo == 1) --This check is probably not needed as a boolean can only take these valors anyway
);

INSERT INTO Director VALUES (1, "Y3944588X", "Cedric", "Prieels", NULL, "1993-05-26", "2019-11-14", NULL, 1); -- We did not specify any default values/autoincrement so not necessary to write all the fields before the VALUES
INSERT INTO Director VALUES (2, "12345678A", "Woody", "Allen", NULL, "1935-12-01", "2019-11-14", NULL, 0);
INSERT INTO Director VALUES (3, "87654321A", "Christopher", "Nolan", NULL, "1970-07-30", "2019-11-14", NULL, 1);

SELECT * FROM Director; -- Print the table to see it

CREATE TABLE IF NOT EXISTS Pelicula (
    idpelicula int NOT NULL PRIMARY KEY CHECK (idpelicula > 0),
    titulo char NOT NULL UNIQUE,
    fechaEstreno date NOT NULL,
    duracionMin real NOT NULL,
    genero char NOT NULL CHECK (genero IN ('Terror', 'Scifi', 'Aventura')),
    iddirector int NOT NULL,
    FOREIGN KEY(iddirector) REFERENCES Director(iddirector) ON DELETE CASCADE -- The cascade option will allow us to delete both tables without worrying about the foreign keys
);

INSERT INTO Pelicula VALUES (1, "A rainy Day in New York", "2016-01-01", 92.0, "Terror", 2); -- The data is probably not correct but let's assume that is it for this exercise
INSERT INTO Pelicula VALUES (2, "Inception", "2010-01-01", 148.0, "Scifi", 3);
INSERT INTO Pelicula VALUES (3, "Interstellar", "2014-01-01", 169.0, "Scifi", 3);

-- Let's now add a new column to the Pelicula table
ALTER TABLE Pelicula ADD recaudacion int NOT NULL CHECK (recaudacion >= 0) DEFAULT 0;
UPDATE Pelicula SET recaudacion = 2 WHERE idpelicula = 3; -- Let's modify one of the recaudacion fields to see if it works

SELECT * FROM Pelicula; -- Print the modified table with the new column

-- The way we use to implement the type of movie is not ideal. If we want to modify/add/delete one type of movie, we need indeed to redefine completely the database and maybe even need to delete all its data
-- A better way to proceed would be to keep the different possibilities for the types of movies in a separate database and link them with a foreign key. Let's implement this now.

DROP TABLE IF EXISTS Types;
CREATE TABLE IF NOT EXISTS Types ( -- First, let's create a new table gathering the types of movie
    idgenero int NOT NULL PRIMARY KEY CHECK (idgenero > 0),
    genero char NOT NULL UNIQUE
);

INSERT INTO Types VALUES (1, "Terror");
INSERT INTO Types VALUES (2, "Scifi");
INSERT INTO Types VALUES (3, "Aventura");
INSERT INTO Types VALUES (4, "Comedia"); -- Let's add a new type of movie now

SELECT * FROM Types;

-- Unfortunately, SQL lite does not seem to be supporting the alter table to drop/rename a column, and does not allow to add a foreign key either after the table is created, so the best way is to create a new table now
DROP TABLE IF EXISTS Pelicula2;
CREATE TABLE IF NOT EXISTS Pelicula2 (
    idpelicula int NOT NULL PRIMARY KEY CHECK (idpelicula > 0),
    titulo char NOT NULL UNIQUE,
    fechaEstreno date NOT NULL,
    duracionMin real NOT NULL,
    idgenero int NOT NULL, -- This fields has been updated
    iddirector int NOT NULL,
    FOREIGN KEY(iddirector) REFERENCES Director(iddirector) ON DELETE CASCADE, -- The cascade option will allow us to delete both tables without worrying about the foreign keys
    FOREIGN KEY(idgenero) REFERENCES Types(idgenero) ON DELETE CASCADE
);

INSERT INTO Pelicula2 VALUES (1, "A rainy Day in New York", "2016-01-01", 92.0, 1, 2); -- The data is probably not correct but let's assume that is it for this exercise
INSERT INTO Pelicula2 VALUES (2, "Inception", "2010-01-01", 148.0, 2, 3);
INSERT INTO Pelicula2 VALUES (3, "Interstellar", "2014-01-01", 169.0, 2, 3);

SELECT * FROM Pelicula2;

-- We will now moreover add the Actor table, knowing that an actor can participate in several movies and that several movies can feature several actors (N to N relationship)
DROP TABLE IF EXISTS Actor;
CREATE TABLE IF NOT EXISTS Actor (
    idactor int NOT NULL PRIMARY KEY CHECK (idactor > 0),
    dni char NOT NULL UNIQUE,
    nombre char NOT NULL,
    apellido1 char NOT NULL,
    apellido2 char,
    fechaNacimiento date NOT NULL,
    fechaRegistro date NOT NULL CHECK (fechaRegistro > fechaNacimiento),
    fechaDeceso data CHECK (fechaDeceso > fechaNacimiento),
    enActivo bool NOT NULL CHECK (enActivo == 0 OR enActivo == 1)
);

INSERT INTO Actor VALUES (1, "12345678A", "Tom", "Cruise", NULL, "1962-07-03", "2019-11-18", NULL, 1);
INSERT INTO Actor VALUES (2, "87654321A", "Leonardo", "Di Caprio", NULL, "1974-11-11", "2019-11-18", NULL, 1);

SELECT * FROM Actor;

-- A N to N relationship now needs an "in-between" database, to link the actors and the movies. Let's create it now:
DROP TABLE IF EXISTS ActorPelicula;
CREATE TABLE IF NOT EXISTS ActorPelicula (
    idactor int NOT NULL CHECK (idactor > 0),
    idpelicula int NOT NULL CHECK (idpelicula > 0),
    FOREIGN KEY (idactor) REFERENCES Actor(idactor),
    FOREIGN KEY (idpelicula) REFERENCES Pelicula(idpelicula),
    PRIMARY KEY (idactor, idpelicula)
);

-- We still have foreign keys in the previous Pelicula table. Since SQL lite does not allow oto simply remove this constraint, let's build again a new table:

INSERT INTO ActorPelicula(idactor, idpelicula) VALUES (1,1); --First actor with the first movie
INSERT INTO ActorPelicula(idactor, idpelicula) VALUES (2,2); -- Second actor with 3rd movie

SELECT * FROM ActorPelicula;
