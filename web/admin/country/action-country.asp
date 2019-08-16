<!--#include virtual="/config/bootstrap.asp"-->
<%
response.expires = 0
call verifiedLogin()
id = request("id")
action = request("action")
active = request("active")

select case action 
    case "inactive/active"               
        if not isempty(id) then
            active_now = 1
            if active = 1 then active_now = 0
            call updateCountry(id, active_now)
            response.write("ok")
            response.end            
        end if  
    case else
        response.end
end select
objConn.close()
Set objConn = Nothing

%>