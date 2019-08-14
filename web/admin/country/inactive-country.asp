<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()
id = request("id")
action = request("action")

select case action 
    case "inactive"               
        if not isempty(id) then

            sql = "SELECT country_active FROM t_country WHERE country_id = " & id
            Set rs = objConn.Execute(sql)

            active_default = 1
            if not rs.EOF then
                active = rs("country_active")

                active_up = 1
                if active = 1 then active_up = 0

            end if
            set rs = Nothing

            sql = "UPDATE t_country set country_active = " & active_up & " WHERE country_id = " & id
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