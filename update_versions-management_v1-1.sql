/*
 GROUP HEADERS GENERATED BY: https://patorjk.com/software/taag/#p=display&h=0&v=1&c=c&f=ANSI%20Shadow&t=STAGE%20FUNCS

 SUB GROUP HEADERS GENERATED BY: https://patorjk.com/software/taag/#p=display&h=1&v=1&c=c&f=Banner3&t=permissions

 */

select *
from start_version_update('1.1', 'Check version can now throw exception to stop futher processing', _component := 'versions_management');


drop function check_version(_version text, _component text);

create function check_version(_version text, _component text default 'main', _throw_err bool default false)
	returns bool
	language plpgsql
	cost 1
as
$$
declare
	__result bool;
begin

	select exists(select
								from __version
								where component = _component
									and version = _version)
	into __result;
	if _throw_err then
		raise exception 'Version: % of component: % not found', _version, _component;
	else
		return __result;
	end if;
end;
$$;


select *
from stop_version_update('1.1', _component := 'versions_management');
