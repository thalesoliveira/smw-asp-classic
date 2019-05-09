<!--#include virtual="/config/conexao.asp"-->
<%
response.expires = 0
id = request("id")
action = request("action")

select case action 
    case "delete"               
        if not isempty(id) then
            sql = "DELETE t_state WHERE state_id = " & id
            objConn.Execute(sql)            
            if err.number = 0 then
                response.write(sql)
            end if
            response.write(err)
            response.end            
        end if  
    case else
    response.end
end select
objConn.close()
Set objConn = Nothing

%>
