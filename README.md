# postgresql-versions-management

Database version management, nothing too complicated

## Usage

Typical use would be similar to this.
If there is a version of this component already in the table then an unique violation exception will be thrown.

```sql
select *
from start_version_update('1', 'Initial version', _component := 'languages_translations');
```

