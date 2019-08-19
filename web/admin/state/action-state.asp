<!--#include virtual="/config/bootstrap.asp"-->
<%
response.expires = 0
call verifiedLogin()
id = request("id")
action = request("action")

select case action 
    case "delete"               
        if not isempty(id) then
            call removeState(id)
            if err.number = 0 then
                response.write("ok")
                response.end
            end if
            
            response.write(err)
            response.end 
        end if
    case "search"               
        if not isempty(id) then
            
            SET rs = findStateFromCountry(id)

            if err.number = 0 then
                if not rs.EOF then
                    do while not rs.EOF                              
                        state_id = rs("state_id")
                        state_name = rs("state_name")
                        
                        json_a = json_a & "{" & """name""" & ":""" & state_name & """, " & """id""" & ":""" & state_id & """},"
                        rs.MoveNext
                    loop
                    set rs = Nothing

                    json = "{" & """data""" & ":[" & json_a & "]}"
                    json = Replace(json, "},]}", "}]}")
                    Response.Charset = "ISO-8859-1"
                    Response.ContentType = "application/json"
                    Response.write(json)
                    Response.end
                else
                    Response.ContentType = "application/json"
                    Response.write("{" & """data""" & ":[]}")
                    Response.end
                end if              
            end if            
            set rs = Nothing    

            response.write(err)
            response.end
        end if  

    case else
    response.end
end select
objConn.close()
Set objConn = Nothing
%>
