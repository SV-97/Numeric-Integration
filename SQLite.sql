/* echo '.read SQLite.sql' | sqlite3 :memory: */

PRAGMA recursive_triggers = True;

DROP TABLE IF EXISTS params;
DROP TABLE IF EXISTS steps;
DROP TABLE IF EXISTS vars;
DROP TABLE IF EXISTS integral;

CREATE TABLE vars (
    step_size REAL
);

CREATE TABLE params (
    n INTEGER,
    a REAL,
    b REAL
);

/* Would have to recompile sqlite3 with sufficiently big
value for SQLITE_MAX_TRIGGER_DEPTH for this to work
CREATE TABLE steps (
    id INTEGER PRIMARY KEY,
    k INTEGER AUTO_INCREMENT
);

DROP TRIGGER IF EXISTS increment_insert;
CREATE TRIGGER increment_insert
    AFTER INSERT
    ON steps
    WHEN NEW.k < (SELECT n FROM params)
BEGIN
    INSERT INTO steps(k) VALUES (new.k + 1);
END;
*/

/* set parameters */
INSERT INTO params(n, a, b) VALUES (100000, 0, 2*3.14159265359);
INSERT INTO vars(step_size) VALUES ((SELECT (b-a)/n FROM params));

WITH fs(f_xk0, f_sum, f_xk1) AS (
    /* The following line is only here to save a bit on the writing of the taylor series */
    WITH xs_pi(x_0, x_1, x_01) AS (
        WITH xs(x_k0, x_k1) AS (
            WITH RECURSIVE cnt(k) AS (
                SELECT 1
                UNION ALL
                SELECT k+1 FROM cnt
                LIMIT (SELECT n FROM params)
            ), a AS (
                SELECT a FROM params
            ), step_size AS (
                SELECT step_size FROM vars
            ) SELECT 
                ((SELECT * FROM a) + (SELECT * FROM step_size) * k) as x_k0,
                ((SELECT * FROM a) + (SELECT * FROM step_size) * (k-1)) as x_k1 
            FROM cnt
        ) SELECT 
        /* Helper for the function */
            x_k0 - 3.14159265359 as x_0, 
            x_k1 - 3.14159265359 as x_1, 
            (x_k0 + x_k1)/2 - 3.14159265359 as x_01
        FROM xs
    ) SELECT
    /* 
    The function is the taylorseries approximation with 4 terms of sin(x)
    because there's no SIN in sqlite3. This part is also where the function implementation starts.
    */
        (
            - x_0
            + x_0*x_0*x_0 / 6
            - x_0*x_0*x_0*x_0*x_0 / 120
            + x_0*x_0*x_0*x_0*x_0*x_0*x_0 / 5040
        ) as f_xk0,
        (
            - x_01
            + x_01*x_01*x_01 / 6
            - x_01*x_01*x_01*x_01*x_01 / 120
            + x_01*x_01*x_01*x_01*x_01*x_01*x_01 / 5040
        ) as f_sum,
        (
            - x_1
            + x_1*x_1*x_1 / 6
            - x_1*x_1*x_1*x_1*x_1 / 120
            + x_1*x_1*x_1*x_1*x_1*x_1*x_1 / 5040
        ) as f_xk1 
    FROM xs_pi
), step_size AS(
    SELECT step_size FROM vars
) SELECT SUM((SELECT * FROM step_size) / 6 * (f_xk0 + 4 * f_sum + f_xk1)) as Integral FROM fs;
