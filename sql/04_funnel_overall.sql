WITH c AS (
  SELECT
    COUNT(*) AS s1,
    COUNTIF(s_view) AS s2,
    COUNTIF(s_cart) AS s3,
    COUNTIF(s_checkout) AS s4,
    COUNTIF(s_purchase) AS s5
  FROM `myproject-513713.ga4_funnel.sessions`
),
steps AS (
  SELECT 1 AS n, 'session' AS step, s1 AS sessions FROM c UNION ALL
  SELECT 2, 'view_item', s2 FROM c UNION ALL
  SELECT 3, 'add_to_cart', s3 FROM c UNION ALL
  SELECT 4, 'begin_checkout', s4 FROM c UNION ALL
  SELECT 5, 'purchase', s5 FROM c
)
SELECT
  step,
  sessions,
  ROUND(100 * SAFE_DIVIDE(sessions, LAG(sessions) OVER (ORDER BY n)), 2) AS cr_from_prev_pct,
  ROUND(100 * SAFE_DIVIDE(sessions, FIRST_VALUE(sessions) OVER (ORDER BY n)), 2) AS cr_from_start_pct
FROM steps
ORDER BY n;