-- Задача 1
select currency_code,
        sum(revenue) as total_revenue,
        count(order_id) as total_orders,
        avg(revenue) as avg_revenue_per_order,
        count(distinct user_id) as total_users
from afisha.purchases
group by currency_code
order by total_revenue desc;


-- Задача 2
-- Настройка параметра synchronize_seqscans важна для проверки
WITH set_config_precode AS (
  SELECT set_config('synchronize_seqscans', 'off', true)
)
-- Напишите ваш запрос ниже
select device_type_canonical,
        sum(revenue) as total_revenue,
        count(order_id) as total_orders,
        avg(revenue) as avg_revenue_per_order,
        round((sum(revenue)::numeric / (select sum(revenue)::numeric from afisha.purchases
                    where currency_code='rub')), 3) as revenue_share
from afisha.purchases
where currency_code='rub'
group by device_type_canonical
order by revenue_share desc;

--Задача 3
select event_type_main,
        sum(revenue) as total_revenue,
        count(order_id) as total_orders,
        avg(revenue) as avg_revenue_per_order,
        count(distinct event_name_code) as total_event_name,
        avg(tickets_count) as avg_tickets,
        sum(revenue) / sum(tickets_count),
        round(sum(revenue)::numeric / (select sum(revenue)::numeric from afisha.purchases where currency_code = 'rub'), 3) as revenue_share
from afisha.purchases left join afisha.events using (event_id)
where currency_code = 'rub'
group by event_type_main
order by total_orders desc;

-- Задача 4
select date_trunc('week', created_dt_msk)::date as week,
        round(sum(revenue)::numeric, 0) as total_revenue,
        count(order_id) as total_orders,
        count(distinct user_id) as total_users,
        round(sum(revenue)::numeric / count(order_id), 0) as revenue_per_order
from afisha.purchases
where currency_code = 'kzt'
group by week
order by week asc;

-- Задача 5
select region_name,
        sum(revenue) as total_revenue,
        count(order_id) as total_orders,
        count(distinct user_id) as total_users,
        sum(tickets_count) as total_tickets,
        sum(revenue)::real / sum(tickets_count) as one_ticket_cost
from afisha.purchases left join
    afisha.events using (event_id) left join
        afisha.city using (city_id) left join
            afisha.regions using (region_id)
where currency_code = 'rub'
group by region_name
order by total_revenue desc
limit 7;
