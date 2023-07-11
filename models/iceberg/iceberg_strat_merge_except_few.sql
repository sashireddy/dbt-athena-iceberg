{{ config(
  materialized='incremental',
  incremental_strategy='merge',
  partitioned_by=['hour(test_timestamp)'],
  unique_key='test_timestamp',
  table_type='iceberg',
  format='orc',
  merge_exclude_columns = ['test_bool', 'test_array_array_string'],
) }}

SELECT
    ts AS test_timestamp
    , CAST(ts AS DATE) AS test_date
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
FROM {{ ref('iceberg_data_source') }}
{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  WHERE ts > (SELECT max(test_timestamp) FROM {{ this }})
{% endif %}
