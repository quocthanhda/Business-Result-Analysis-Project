with RFM_base as (
	select customerid
		, DATEDIFF(day, MAX(saledate), '2019-05-31') AS recency_value
		, count(distinct saledate) as frequency_value
		, round(sum(total), 2) as monetary_value
		
		from distinctorderid
		group by customerid 
		)
		-- select * from RFM_base
	, RFM_score as (
	select * 
		, ntile(5) over (order by recency_value desc) as R_score
		, ntile(5) over (order by frequency_value asc) as F_score
		, ntile(5) over (order by monetary_value asc) as M_score
		from RFM_base
		) 
	-- select * from RFM_score 
	, RFM_final as (
	select *
		, concat(R_score, F_score, M_score) as RFM_overall 
		from RFM_score 
		)
		-- select * from RFM_final 
		select f.*, s.segment 
		from RFM_final f
		join segment s on f.RFM_overall = s.scores