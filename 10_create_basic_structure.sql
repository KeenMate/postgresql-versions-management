/***
 *    ███████╗██╗    ██╗██╗████████╗ ██████╗██╗  ██╗    ███████╗ ██████╗██╗  ██╗███████╗███╗   ███╗ █████╗
 *    ██╔════╝██║    ██║██║╚══██╔══╝██╔════╝██║  ██║    ██╔════╝██╔════╝██║  ██║██╔════╝████╗ ████║██╔══██╗
 *    ███████╗██║ █╗ ██║██║   ██║   ██║     ███████║    ███████╗██║     ███████║█████╗  ██╔████╔██║███████║
 *    ╚════██║██║███╗██║██║   ██║   ██║     ██╔══██║    ╚════██║██║     ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══██║
 *    ███████║╚███╔███╔╝██║   ██║   ╚██████╗██║  ██║    ███████║╚██████╗██║  ██║███████╗██║ ╚═╝ ██║██║  ██║
 *    ╚══════╝ ╚══╝╚══╝ ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝
 *
 *    TO km_versions_model database
 */

create schema if not exists error;
create schema if not exists const;
create schema if not exists unsecure; -- functions without any permission validation
create schema if not exists helpers;
create schema if not exists ext;
create schema if not exists auth;
create schema if not exists internal;

alter default privileges
    in schema public, auth, const
    grant select, insert, update, delete on tables to km_versions_model;
alter default privileges
    in schema public, helpers, ext, unsecure grant usage, select on sequences to km_versions_model;

alter role km_versions_model set search_path to public, const, ext, helpers, unsecure, auth;
set search_path = public, const, ext, helpers, unsecure, auth;
ALTER DATABASE km_versions_model SET search_path TO public, ext, helpers, unsecure, auth;