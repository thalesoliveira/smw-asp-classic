<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()
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

    case "search"               
        if not isempty(id) then
            sql = "SELECT state_id, state FROM t_state WHERE country_id = " & id            
            Set rs = objConn.Execute(sql)

            if err.number = 0 then
                if not rs.EOF then
                   do while not rs.EOF                              
                        state_id = rs("state_id")
                        state = rs("state")
                        
                        json_a = json_a & "{" & """name""" & ":""" & state & """, " & """id""" & ":""" & state_id & """},"
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
