SELECT 
*, 
event_params[OFFSET(index_id)].value.string_value store_id, 
event_params[OFFSET(index_name)].value.string_value store_name, 
event_params[OFFSET(index_chain)].value.string_value store_chain,
event_params[OFFSET(index_item_list_name)].value.string_value item_list_name,
event_params[OFFSET(index_search_term)].value.string_value search_term,
event_params[OFFSET(index_screen_class)].value.string_value screen_class,
event_params[OFFSET(index_delivery_start_time)].value.string_value delivery_start_time,
event_params[OFFSET(index_delivery_end_time)].value.string_value delivery_end_time,
event_params[OFFSET(index_session_number)].value.int_value session_number,
event_params[OFFSET(index_first_open_time)].value.int_value first_open_time,


FROM(
  SELECT *,
    ( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'store_id'
    ) index_id,
    ( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'store_name'
    ) index_name,
    ( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'store_chain'
    ) index_chain,
  	( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'item_list_name'
    ) index_item_list_name,
    ( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'search_term'
    ) index_search_term,
  	( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'firebase_screen'
    ) index_screen_class,
  	( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'delivery_start_time'
    ) index_delivery_start_time,
  	( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'delivery_end_time'
    ) index_delivery_end_time,
  	( SELECT OFFSET 
      FROM UNNEST(event_params) AS ep WITH OFFSET 
      WHERE ep.key = 'ga_session_number'
    ) index_session_number,
  	( SELECT OFFSET 
      FROM UNNEST(user_properties) AS up WITH OFFSET 
      WHERE up.key = 'first_open_time'
    ) index_first_open_time,
  FROM `analytics_295101028.events_intraday_*`
  
  WHERE _TABLE_SUFFIX BETWEEN @DS_START_DATE AND @DS_END_DATE
)
WHERE stream_id IN ('4319802963', '4319896839', '4447908904')
	AND event_date BETWEEN "20250601" AND "20251231"