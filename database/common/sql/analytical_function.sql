DROP TABLE t;

CREATE TABLE t (
    id         NUMBER,
    name       VARCHAR2(100),
    crud_value CHAR(1),
    host_ts    TIMESTAMP
);


insert into t(id, name, crud_value,host_ts ) values(1,'Reji','C',current_timestamp);
insert into t(id, name, crud_value,host_ts ) values(1,'Reji1','U',current_timestamp);
insert into t(id, name, crud_value,host_ts ) values(1,'Reji1','D',current_timestamp);
insert into t(id, name, crud_value,host_ts ) values(1,'Reji2','C',current_timestamp);


SELECT
    *
FROM
    t a
WHERE
        id = 1
    AND crud_value <> 'D'
    AND host_ts = (
        SELECT
            MAX(host_ts)
        FROM
            t b
        WHERE
            a.id = b.id
    );


SELECT
    *
FROM
    (
        SELECT
            id,
            name,
            crud_value,
            host_ts,
            MAX(host_ts)
            OVER(PARTITION BY id) AS max_host
        FROM
            t
    )
WHERE
    max_host = host_ts
ORDER BY
    host_ts DESC;
