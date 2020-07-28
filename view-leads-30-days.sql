#busqueda de los ultimos 30 días naturales

select *
from sell_tracing st
inner join leads_status ls on st.status = ls.id
inner join consultants c on st.upload_by = c.id
where st.created > (curdate() -interval 30 day )