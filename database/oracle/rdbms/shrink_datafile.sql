-- Query to get the datafile space details

select df.tablespace_name, df.file_name, round(df.bytes/1024/1024) totalSizeMB, nvl(round(usedBytes/1024/1024), 0) usedMB, nvl(round(freeBytes/1024/1024), 0) freeMB,
    nvl(round(freeBytes/df.bytes * 100), 0) freePerc, df.autoextensible
from dba_data_files df
    left join (
        select file_id, sum(bytes) usedBytes
        from dba_extents
        group by file_id
    ) ext on df.file_id = ext.file_id
    left join (
        select file_id, sum(bytes) freeBytes
        from dba_free_space
        group by file_id
    ) free on df.file_id = free.file_id
order by df.tablespace_name, df.file_name;

--Query to get the block size
select value from v$parameter where name = 'db_block_size';

--Query to get space saving details
select file_name,
       ceil( (nvl(hwm,1)*&&blksize)/1024/1024 ) smallest,
       ceil( blocks*&&blksize/1024/1024) currsize,
       ceil( blocks*&&blksize/1024/1024) -
       ceil( (nvl(hwm,1)*&&blksize)/1024/1024 ) savings
from dba_data_files a,
     ( select file_id, max(block_id+blocks-1) hwm
         from dba_extents
        group by file_id ) b
where a.file_id = b.file_id(+) order by savings desc;

--SQL to shrink the datafiles.
------------------------------
alter database datafile '/u01/app/oracle/oradata/NGECDKR/TS_ECDEV_CDC.dbf' resize 96173M;
