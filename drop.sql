SELECT 'DROP INDEX ' + name + ' ON ' + object_name(object_id)
FROM sys.indexes
WHERE is_primary_key = 0 AND is_unique_constraint = 0
AND OBJECTPROPERTY(object_id, 'IsMSShipped') = 0     -- exclude system-level tables
AND name IS NOT NULL