select f.leads, f.nombre, f.creado
from
	(select l.id leads, consultants.name nombre, l.created creado
	from leads l
	inner join consultants on l.seller = consultants.id
	where not exists
		(select sell_tracing.lead
			from sell_tracing
			where l.id = sell_tracing.lead)
	and l.created <  (curdate() -
		INTERVAL (select
			(case
				when weekday(curdate()) = 0 then 6 #lunes -> martes anterior
				when weekday(curdate()) = 1 then 6 #martes -> miércoles anterior
				when weekday(curdate()) = 2 then 6 #miércoles -> jueves anterior
				when weekday(curdate()) = 3 then 6 #jueves -> viernes anterior
				when weekday(curdate()) = 4 then 4 #viernes -> lunes anterior
				else 0
			end)) DAY)
	and l.created > (curdate() - INTERVAL 30 DAY)
	order by l.created desc) f
where weekday(curdate()) != 5 AND weekday(curdate()) != 6; #solo funciona de lunes a viernes
