do
$$
    -- ensure user role
    begin
        if not exists(select * from pg_roles where rolname = 'km_versions_model') then
            create role km_versions_model with password 'Password3000!!' login;
        end if;
    end;
$$;

SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'km_versions_model'
  AND pid <> pg_backend_pid();

drop database if exists km_versions_model;
create database km_versions_model with owner km_versions_model;
