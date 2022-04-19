CREATE DATABASE IF NOT EXISTS projectvideogame;

USE projectvideogame;

CREATE TABLE platforms (
	platform_id INT PRIMARY KEY,
    platform varchar(15),
    company varchar(20)
);

CREATE TABLE developers (
	developer_id INT PRIMARY KEY,
    developer varchar(50)
);
    
create TABLE critics_data (
	id_game INT PRIMARY KEY,
	name varchar(100),
    platform_id int,
    rdate varchar(15),
    score tinyint,
    user_score float,
    developer_id int,
    genre varchar(150),
    players varchar(50),
    critics tinyint,
    users int,
    FOREIGN KEY (platform_id) REFERENCES platforms(platform_id),
    FOREIGN KEY (developer_id) REFERENCES developers(developer_id)
);



SELECT * from platforms;
SELECT * from developers;
SELECT * from critics_data;


-- 1. Top 20 de juegos mejor calificados según la crítica.
SELECT DISTINCT name FROM critics_data ORDER BY score desc LIMIT 20;
SELECT name, ROUND(avg(score),2) AS avg_score FROM critics_data GROUP BY name ORDER BY avg_score desc LIMIT 20;

-- 2. Top 20 de juegos mejor calificados según los usuarios.
SELECT DISTINCT name FROM critics_data ORDER BY user_score desc LIMIT 20;
SELECT name, ROUND(avg(user_score),2) AS avg_user_score FROM critics_data GROUP BY name ORDER BY avg_user_score desc LIMIT 20;


-- 3. Juegos que tienen una calificación de 95 o mayor.
SELECT DISTINCT name FROM critics_data WHERE score >= 95;
SELECT name FROM critics_data WHERE score >= 95 group by name;

show tables;

-- 4. Juegos que tienen una calificación de 9 o mayor (usuarios).
SELECT name FROM critics_data WHERE user_score >= 9 group by name;


-- 5. Top 20 de juegos que tienen mayor cantidad de críticas.
SELECT DISTINCT name FROM critics_data ORDER BY critics desc LIMIT 20;
SELECT name, sum(critics) AS total_critics FROM critics_data GROUP BY name ORDER BY total_critics desc LIMIT 20;

-- 6. Cantidad de juegos dependiendo del género que son.
SELECT genre, count(*) AS numero_juegos_genero from critics_data GROUP BY genre ORDER BY numero_juegos_genero desc;

-- 7. Cantidad de usuarios que criticaron un juego según su género.
SELECT genre, sum(users) AS total_users FROM critics_data GROUP BY genre ORDER BY total_users desc;

-- 8. Calificación (critica) promedio de todos los juegos.
SELECT ROUND(AVG(score),2) AS avg_critics FROM critics_data;

-- 9. Juegos que están arriba del promedio de la calificación de crítica.
SELECT name FROM critics_data WHERE score >= (SELECT ROUND(AVG(score),2) AS promedio_critica FROM critics_data) GROUP BY name;

-- 10. Cantidad de juegos que están arriba del promedio de la calificacion de la critica según su género.
SELECT genre, count(*) AS numero_juegos_genero FROM critics_data WHERE score >= (SELECT ROUND(AVG(score),2) AS promedio_critica FROM critics_data) 
GROUP BY genre ORDER BY numero_juegos_genero desc;

-- 11. Top 20 con el nombre de juego y desarrollador.
SELECT name, developer, ROUND(AVG(score),2) AS avg_score FROM critics_data j
INNER JOIN developers d
ON j.developer_id = d.developer_id
GROUP BY name ORDER BY avg_score desc LIMIT 20;

-- 12. Top 20 de los desarrolladores con más juegos en la lista.
SELECT developer, count(*) AS juegos_developer FROM critics_data j
INNER JOIN developers d
ON j.developer_id = d.developer_id
GROUP BY developer ORDER BY juegos_developer desc LIMIT 20;

-- 13. Cantidad de juegos en la lista según su consola.
SELECT platform, count(*) AS juegos_consola FROM critics_data j
INNER JOIN platforms p
ON j.platform_id = p.platform_id
GROUP BY platform ORDER BY juegos_consola desc;

-- 14. Los 20 desarrolladores con mayor cantidad de criticas por los usuarios.
SELECT developer, sum(users) AS total_criticas FROM critics_data j
INNER JOIN developers d
ON j.developer_id = d.developer_id
GROUP BY developer ORDER BY total_criticas desc LIMIT 20;

-- 15. Numero de criticas de usuarios por consola.
SELECT platform, sum(users) AS total_criticas FROM critics_data j
INNER JOIN platforms p
ON j.platform_id = p.platform_id
GROUP BY platform ORDER BY total_criticas desc;

-- 16. Cantidad de criticas de usuarios por compañía.
SELECT company, sum(users) AS total_criticas FROM critics_data j
INNER JOIN platforms p
ON j.platform_id = p.platform_id
GROUP BY company ORDER BY total_criticas desc;