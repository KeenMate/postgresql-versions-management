/***
*    ██╗--██╗███████╗██╗-----██████╗-███████╗██████╗-███████╗
*    ██║--██║██╔════╝██║-----██╔══██╗██╔════╝██╔══██╗██╔════╝
*    ███████║█████╗--██║-----██████╔╝█████╗--██████╔╝███████╗
*    ██╔══██║██╔══╝--██║-----██╔═══╝-██╔══╝--██╔══██╗╚════██║
*    ██║--██║███████╗███████╗██║-----███████╗██║--██║███████║
*    ╚═╝--╚═╝╚══════╝╚══════╝╚═╝-----╚══════╝╚═╝--╚═╝╚══════╝
*    --------------------------------------------------------
*/

/***
 *     ######  ######## ########  #### ##    ##  ######
 *    ##    ##    ##    ##     ##  ##  ###   ## ##    ##
 *    ##          ##    ##     ##  ##  ####  ## ##
 *     ######     ##    ########   ##  ## ## ## ##   ####
 *          ##    ##    ##   ##    ##  ##  #### ##    ##
 *    ##    ##    ##    ##    ##   ##  ##   ### ##    ##
 *     ######     ##    ##     ## #### ##    ##  ######
 */

create or replace function helpers.is_empty_string(_text text)
	returns bool
	language sql
	immutable
	parallel safe
	cost 2
as
$$
select _text is null or _text = '';
$$;

create or replace function helpers.is_not_empty_string(_text text)
	returns bool
	language sql
	immutable
	parallel safe
	cost 2
as
$$
select not helpers.is_empty_string(_text);
$$;

create or replace function helpers.random_string(len integer default 36) returns text
	cost 1
	volatile
	language sql
as
$$
select upper(substring(md5(random()::text), 0, len + 1));
$$;

create function helpers.get_code(_text text, _separator text default '_')
	returns text
	stable returns null on null input
	parallel safe
	language sql
as
$$
	-- removes accents (diacritic signs) from a given string --
with _unaccented as (select ext.unaccent(_text) as _title),
		 -- lowercases the string
		 _lowercase as (select lower(_title) as _title
										from _unaccented),
		 -- replaces anything that's not a letter, number, hyphen('-'), or underscore('_') with a hyphen('-')
		 _hyphenated as (select regexp_replace(_title, '[^a-z0-9\\-_]+', _separator, 'gi') as _title
										 from _lowercase),
		 -- trims hyphens('-') if they exist on the head or tail of the string
		 _trimmed as (select trim(BOTH _separator FROM _title) as _title
									from _hyphenated)
select _title
from _trimmed;

$$;

create function helpers.get_slug(_text text)
	returns text
	stable returns null on null input
	language sql
as
$$
select helpers.get_code(_text, '-');
$$;


drop function if exists helpers.unaccent_text(_text text);
create function helpers.unaccent_text(_text text, _lower_text bool default true) returns text
	language plpgsql
	immutable
as
$$
begin
	return case when _lower_text then lower(ext.unaccent(_text)) else ext.unaccent(_text) end;
end
$$;

/***
 *          ##  ######   #######  ##    ## ########
 *          ## ##    ## ##     ## ###   ## ##     ##
 *          ## ##       ##     ## ####  ## ##     ##
 *          ##  ######  ##     ## ## ## ## ########
 *    ##    ##       ## ##     ## ##  #### ##     ##
 *    ##    ## ##    ## ##     ## ##   ### ##     ##
 *     ######   ######   #######  ##    ## ########
 */

create function helpers.compare_jsonb_objects(_first jsonb, _second jsonb)
	returns jsonb
	stable
	language sql
as
$$
select json_object_agg(COALESCE(second.key, first.key), second.value)
from jsonb_each_text(_first) first
			 full outer join jsonb_each_text(_second) second on first.key = second.key
where first.value is distinct from second.value;
$$;


/***
 *    ##       ######## ########  ######## ########
 *    ##          ##    ##     ## ##       ##
 *    ##          ##    ##     ## ##       ##
 *    ##          ##    ########  ######   ######
 *    ##          ##    ##   ##   ##       ##
 *    ##          ##    ##    ##  ##       ##
 *    ########    ##    ##     ## ######## ########
 */

create or replace function helpers.ltree_parent(path ext.ltree, levels integer default 1) returns ext.ltree
	language plpgsql
as
$$
begin
	return ext.subpath(path, 0, ext.nlevel(path) - levels);
end
$$;

select *
from stop_version_update('1', _component := 'common_helpers');