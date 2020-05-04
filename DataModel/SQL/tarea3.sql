-- Entrega final de SQL. Ejercicio hecho por Cedric Prieels
DROP TABLE IF EXISTS TEMPORADAS; -- To be able to run the full script multiple times if needed

-- Ejercicio 1: Crea una nueva tabla para almacenar las temporadas de las series. La primary key ha de ser el par de campos “idSerie, numTemporada”.
CREATE TABLE IF NOT EXISTS TEMPORADAS (
    idserie INT NOT NULL,
    numTemporada INT NOT NULL,
    fechaEstreno DATE NOT NULL,
    fechaRegistro DATE NOT NULL,
    disponible BIT NOT NULL,
    CONSTRAINT chk_fecha CHECK (fechaEstreno <= fechaRegistro),
    CONSTRAINT chk_disponible CHECK (disponible IN (0, 1)) -- Probably not needed since the bit type is used
    PRIMARY KEY(idserie, numTemporada),
    FOREIGN KEY (idserie) REFERENCES SERIES(idSerie)
);

-- Ejercicio 2: Añadir una nueva columna a la tabla "generos" para almacenar un campo denominado "descripcion" 
ALTER TABLE GENEROS ADD descripcion TEXT; -- This command prevents the code from being run multiple times, and I have found no easy way to work around this in SQL lite. The best way is to (un)comment it when needed.

-- Ejercicio 3: Crea un índice sobre el par de campos “titulo” y “anyoFin” de las series
CREATE INDEX myIndex ON SERIES (titulo, anyoFin); -- This command also prevents the code from being run multiple times, and I have found no easy way to work around this in SQL lite. The best way is to (un)comment it when needed.

-- Ejercicio 4: Mostrar el “idserie”, “titulo”, “titulo original” y “sinopsis” de todas las series, ordenadas por título descendentemente
SELECT se.idserie, se.titulo, se.tituloOriginal, se.sinopsis FROM SERIES se ORDER BY se.titulo DESC;

-- Ejercicio 5: Retornar los datos de los usuarios franceses o noruegos
SELECT us.* FROM USUARIOS us WHERE us.pais = 'Noruega' OR us.pais = 'Francia';

-- Ejercicio 6: Mostrar los datos de los actores junto con los datos de las series en las que actúan 
SELECT ac.*, se.* FROM REPARTO re INNER JOIN SERIES se ON re.idSerie = se.idSerie INNER JOIN ACTORES ac ON re.idActor = ac.idActor;

-- Ejercicio 7: Mostrar los datos de los usuarios que no hayan realizado nunca ninguna valoración
SELECT us.* FROM Usuarios us WHERE us.idUsuario NOT IN(SELECT va.idUsuario FROM Valoraciones va);

-- Ejercicio 8: Mostrar los datos de los usuarios junto con los datos de su profesión, incluyendo las profesiones que no estén asignadas a ningún usuario
SELECT us.*, pr.* FROM PROFESIONES pr LEFT JOIN USUARIOS us ON pr.idProfesion = us.idProfesion;

-- Ejercicio 9: Retornar los datos de las series que estén en idioma español, y cuyo título comience por E o G
SELECT se.* FROM SERIES se INNER JOIN IDIOMAS id ON se.idIdioma = id.idIdioma WHERE (id.idioma == 'Español' AND (se.titulo LIKE 'E%' OR se.titulo LIKE 'G%'));

-- Ejercicio 10: Retornar los “idserie”, “titulo” y “sinopsis” de todas las series junto con la puntuación media, mínima y máxima de sus valoraciones
SELECT se.idserie, se.titulo, se.sinopsis, AVG(va.puntuacion) as avgPuntuacion, MIN(va.puntuacion) as minPuntuacion, MAX(va.puntuacion) as maxPuntuacion FROM SERIES se INNER JOIN VALORACIONES va ON se.idSerie = va.idSerie GROUP BY se.idSerie;

-- Ejercicio 11: Actualiza al valor 'Sin sinopsis' la sinopsis de todas las series cuya sinopsis sea nula y cuyo idioma sea el inglés
UPDATE SERIES SET sinopsis = 'Sin sinopsis' WHERE idSerie IN (SELECT se.idSerie FROM Series se INNER JOIN IDIOMAS id ON se.idIdioma = id.idIdioma WHERE (se.sinopsis IS NULL AND id.idioma = 'Inglés'));
SELECT * FROM Series se INNER JOIN IDIOMAS id ON se.idIdioma = id.idIdioma WHERE (id.idioma = 'Inglés'); -- To display the result after the update

-- Ejercicio 12: Utilizando funciones ventana, muestra los datos de las valoraciones junto al nombre y apellidos (concatenados) de los usuarios que las realizan, y en la misma fila, el valor medio de las puntuaciones realizadas por el usuario
SELECT va.*, us.nombre, us.apellido1 || " " || us.apellido2, AVG(va.puntuacion) OVER (PARTITION BY va.idUsuario) AS avgPuntuacion FROM USUARIOS us INNER JOIN VALORACIONES va ON us.idUsuario = va.idUsuario;