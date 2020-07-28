#busqueda de los ultimos 20 días naturales
#dentro de un plazo de 30 días
#no se consideran sábados y domingos

    select b1.upload_by, b1.leads, b1.user, b1.status, b1.created
    from
        (select st.`lead` leads, st.status, st.user, st.upload_by, st.created
        from sell_tracing st
        where st.created > (curdate() - interval 5 day)
        order by st.`lead`) b1
    group by b1.upload_by, b1.status;



select distinct st.`lead` leads
from sell_tracing st
where st.created > (curdate() - interval 5 day)
order by st.`lead`