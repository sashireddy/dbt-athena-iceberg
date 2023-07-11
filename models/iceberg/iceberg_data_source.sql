{{ config(
  materialized='table',
  partitioned_by=['hour(ts)'],
  table_type='iceberg',
  table_properties={
    'vacuum_max_snapshot_age_seconds': '86400',
    'optimize_rewrite_delete_file_threshold': '2'
  }
) }}

SELECT
  cast(t.ts AS timestamp(6)) AS ts
  , CAST('2023-04-04' AS DATE) AS test_date
  , 'abc' AS test_string_varchar
  , cast('a' as varchar(1)) as test_fixed_varchar
  , true AS test_bool
  , 123 AS test_int
  , cast(123.45 as real) AS test_float
  , CAST(1234.567 AS DECIMAL(7, 3)) AS test_decimal
  , CAST(34 AS BIGINT) AS test_bigint
  , CAST(123.33 AS DOUBLE) AS test_double
  , ARRAY['a'] AS test_array_string
  , ARRAY[1] AS test_array_int
  , ARRAY[false] AS test_array_bool
  , ARRAY[ARRAY['a']] AS test_array_array_string
  , ARRAY[MAP(ARRAY['a'], ARRAY['b'])] AS test_array_map_string_string
  , MAP(ARRAY['a'], ARRAY['b']) AS test_map_string_string
  , MAP(ARRAY['a'], ARRAY[1]) AS test_map_string_int
  , MAP(ARRAY['a'], ARRAY[true]) AS test_map_string_bool
  , MAP(ARRAY['a'], ARRAY[cast(1234.567 as DECIMAL(7, 3))]) AS test_map_string_decimal
  , MAP(ARRAY['a'], ARRAY[ARRAY['a']]) AS test_map_string_array_string
  , MAP(ARRAY[1], ARRAY['a']) AS test_map_int_string
  , MAP(ARRAY[true], ARRAY['a']) AS test_map_bool_string
FROM
    unnest(
        sequence(
            current_date - INTERVAL '1' DAY,
            cast(REPLACE(cast(current_timestamp as varchar), ' UTC', '') as timestamp(6)),
            INTERVAL '1' MINUTE
        )
    ) AS t(ts)
