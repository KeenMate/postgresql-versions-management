-- creates version of a 'main' component
select *
from start_version_update('1', 'Initial version');

-- creates version of a 'secondary_main' component
select *
from start_version_update('1', 'Initial version', _component:= 'secondary_main');

-- there are two first versions of two components
select *
from __version;

-- stop main component version
select *
from stop_version_update('1', 'main');

-- first version of a 'main' component should have execution_finished populated with current timestamp
select *
from start_version_update('1', 'Initial version', _component:= 'secondary_main');

-- start second version of main component
select *
from start_version_update('2', 'Second version of main component');

-- start third version of main component with incorrect version number
-- this call should fail
select *
from start_version_update('2', 'Third version of main component');

-- checks if there is the third versions of main component already in the database
-- returns false since the call above failed
select * from check_version('3', 'main');