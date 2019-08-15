<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()
team_id = request("team_id")
response.Charset="ISO-8859-1"

if not isempty(team_id) then
    sql = "SELECT t_team.*, t_country.country_name, t_coach.coach_name, t_phone_team.phone_id FROM t_team "
    sql = sql & " LEFT JOIN t_country ON t_country.country_id = t_team.country_id "
    sql = sql & " LEFT JOIN t_coach ON t_coach.coach_id = t_team.coach_id "
    sql = sql & " LEFT JOIN t_phone_team ON t_phone_team.team_id = t_team.team_id "
    sql = sql & " WHERE t_team.team_id = " & team_id
    
    Set rs = objConn.Execute(cstr(sql))    
    if not rs.EOF then
        team_name          = rs("team_name")
        team_description   = rs("team_description")
        team_founded_year  = rs("team_founded_year")        
        country_name       = rs("country_name") 
        address_id         = rs("address_id")
        contact_id         = rs("contact_id")
        coach_name         = rs("coach_name")
        phone_id           = rs("phone_id")
        
        if address_id <> "" then
            sql = "SELECT * FROM t_address WHERE address_id = " & address_id
            Set rs = objConn.Execute(cstr(sql))
            if not rs.EOF then
                address_name        = rs("address_name")
                address_city        = rs("address_city")
                address_street      = rs("address_street")
                address_postal_code = rs("address_postal_code")
            end if                
        end if

        if contact_id <> "" then
            sql = "SELECT * FROM t_contact WHERE contact_id = " & contact_id
            Set rs = objConn.Execute(cstr(sql))
            if not rs.EOF then
                contact_email       = rs("contact_email")
                contact_website     = rs("contact_website")                
            end if                
        end if

        if phone_id <> "" then
            sql = "SELECT * FROM t_phone WHERE phone_id = " & phone_id
            Set rs = objConn.Execute(cstr(sql))
            if not rs.EOF then
                phone_ddi        = rs("phone_ddi")
                phone_number        = rs("phone_number")               
                
                phone_number = "(" & Mid(phone_number,1,2) & ")" & VbLf & Mid(phone_number,3,5) & " - " & Mid(phone_number,8, len(phone_number))
            end if               
        end if
        %>

    <div>
        <span class="font-weight-bold">Name: </span><%= team_name%><br/>
        <span class="font-weight-bold">Description: </span><%=team_description%><br/>
        <span class="font-weight-bold">Country: </span><%= country_name%><br/>
        <span class="font-weight-bold">Founded: </span><%=team_founded_year%><br/>
        <span class="font-weight-bold">Coach: </span><%=coach_name%><br/>
    </div>

    <% if address_id <> "" then %>
    <div>
        <span class="font-weight-bold">Address: </span><%=address_name%><br/>
        <span class="font-weight-bold">City: </span><%=address_city%><br/>
        <span class="font-weight-bold">Street: </span><%=address_street%><br/>
        <span class="font-weight-bold">Postal Code: </span><%=address_postal_code %><br/>
    </div>
    <% end if%>

    <% if contact_id <> "" then %>
    <div>
        <span class="font-weight-bold">Mail: </span><%=contact_email%><br/>
        <span class="font-weight-bold">WebSite: </span><%=contact_website%><br/>       
    </div>
    <% end if%>

    <% if phone_id <> "" then %>
    <div>
        <span class="font-weight-bold">Phone: </span><%=phone_ddi%> - <%=phone_number%><br/>        
    </div>
    <% end if%>

<%
    end if 
    set rs = Nothing
end if  
objConn.close()
Set objConn = Nothing
%>