# Por cada lead-vendedor obtener el estado de los leads del mes actual
select e2.vendedor,
       e2.icse,
       e2.noPerfila,
       e2.noInteresado,
       e2.duplicado,
       e2.datosIncorrectos,
       e2.seguimiento,
       e2.interesado,
       e2.documentos,
       e2.contrato,
       e2.cerrado,
       sum(e2.icse+ e2.noPerfila + e2.noInteresado + e2.duplicado + e2.datosIncorrectos) fase1,
       sum(e2.seguimiento+ e2.interesado + e2.documentos + e2.contrato + e2.cerrado) fase2,
       e2.totales
from
    (select
        e1.vendedor vendedor,
        #max(case when e1.descripcion = 'Prospecto' then e1.eventos ELSE 0 END) AS prospecto,
        max(case when e1.descripcion = 'ICSE' then e1.eventos ELSE 0 END) AS icse,
        max(case when e1.descripcion = 'No perfila' then e1.eventos ELSE 0 END) AS noPerfila,
        max(case when e1.descripcion = 'No interesado' then e1.eventos ELSE 0 END) AS noInteresado,
        max(case when e1.descripcion = 'Duplicado' then e1.eventos ELSE 0 END) AS duplicado,
        max(case when e1.descripcion = 'Datos incorrectos' then e1.eventos ELSE 0 END) AS datosIncorrectos,
        max(case when e1.descripcion = 'Seguimiento' then e1.eventos ELSE 0 END) AS seguimiento,
        max(case when e1.descripcion = 'Interesado' then e1.eventos ELSE 0 END) AS interesado,
        max(case when e1.descripcion = 'Documentos' then e1.eventos ELSE 0 END) AS documentos,
        max(case when e1.descripcion = 'Contrato' then e1.eventos ELSE 0 END) AS contrato,
        #max(case when e1.descripcion = 'Sin depósito' then e1.eventos ELSE 0 END) AS sinDeposito,
        max(case when e1.descripcion = 'Cerrado' then e1.eventos ELSE 0 END) AS cerrado,
        sum(e1.eventos) totales
    from
        (select
            e0.nombre vendedor,
            e0.leads leads,
            e0.descripcion descripcion,
            count(*) eventos
        from
            (select distinct c.name nombre, st.lead leads, ls.st descripcion
            from sell_tracing st
            inner join consultants c on st.upload_by = c.id
            inner join leads_status ls on st.status = ls.id
            where year(st.created) = year(CURRENT_DATE())
            AND month(st.created) = month(CURRENT_DATE())
            and (ls.st = 'Seguimiento' OR ls.st='Interesado' OR ls.st='Documentos' OR ls.st='Contrato' OR ls.st='Cerrado' OR
			ls.st = 'ICSE' OR ls.st='No perfila' OR ls.st='No interesado' OR ls.st='Duplicado' OR ls.st='Datos incorrectos')
            and st.lead is not null
            and c.role='seller'
            order by c.name) as e0
        group by e0.nombre, e0.descripcion
        order by e0.nombre) as e1
        group by e1.vendedor) as e2
group by e2.vendedor;
