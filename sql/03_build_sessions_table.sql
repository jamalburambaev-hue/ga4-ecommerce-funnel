CREATE OR REPLACE TABLE `myproject-513713.ga4_funnel.sessions` AS 
WITH events AS (
  SELECT 
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
    PARSE_DATE('%Y%m%d', event_date) AS event_dt,
    event_name,
    device.category AS device_category,
    geo.country AS country,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    ecommerce.purchase_revenue_in_usd AS revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
),
raw AS (
  SELECT 
    CONCAT(user_pseudo_id, '-', CAST(ga_session_id AS STRING)) AS session_id,
    user_pseudo_id,
    MIN(event_dt) AS session_date,
    ANY_VALUE(device_category) AS device_category,
    ANY_VALUE(country) AS country,
    ANY_VALUE(source) AS source,
    ANY_VALUE(medium) AS medium,
    LOGICAL_OR(event_name = 'view_item') AS has_view_item,
    LOGICAL_OR(event_name = 'add_to_cart') AS has_add_to_cart,
    LOGICAL_OR(event_name = 'begin_checkout') AS has_begin_checkout,
    LOGICAL_OR(event_name = 'purchase') AS has_purchase,
    SUM(IF(event_name = 'purchase', IFNULL(revenue, 0), 0)) AS revenue_usd
  FROM events
  WHERE ga_session_id IS NOT NULL
  GROUP BY session_id, user_pseudo_id
)
SELECT 
  *,
  has_view_item AS s_view,
  has_view_item AND has_add_to_cart AS s_cart,
  has_view_item AND has_add_to_cart AND has_begin_checkout AS s_checkout,
  has_view_item AND has_add_to_cart AND has_begin_checkout AND has_purchase AS s_purchase
FROM raw;