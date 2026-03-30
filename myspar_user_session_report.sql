SELECT 
  PARSE_DATE("%Y%m%d", event_date) ed,
  user_id,
  user_pseudo_id,
  event_params[OFFSET((SELECT OFFSET FROM UNNEST(event_params) ep WITH OFFSET WHERE ep.key = "ga_session_id"))].value.int_value session_id


FROM `spar2u-375007.analytics_295101028.events_intraday_*`

WHERE
  _TABLE_SUFFIX BETWEEN "20260101" AND "20260330"
  AND event_name = "session_start"