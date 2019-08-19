<!--#include virtual="/config/bootstrap.asp"-->
<%
response.expires = 0
call verifiedLogin()
team_id = request("team_id")
response.Charset="ISO-8859-1"

if not isempty(team_id) then
    
    Set rs = findTeamInfo(team_id)
    if not rs.EOF then
        team_name          = rs("team_name")
        team_description   = rs("team_description")
        team_founded_year  = rs("team_founded_year")
        country_name       = rs("country_name")        
        coach_name         = rs("coach_name")
        
        address_name        = rs("address_name")
        address_city        = rs("address_city")
        address_street      = rs("address_street")
        address_postal_code = rs("address_postal_code")

        contact_email       = rs("contact_email")
        contact_website     = rs("contact_website")
        
        phone_ddi           = rs("phone_ddi")
        phone_number        = rs("phone_number")

        if phone_number <> "" then
            phone_number = "(" & Mid(phone_number,1,2) & ")" & VbLf & Mid(phone_number,3,5) & " - " & Mid(phone_number,8, len(phone_number))            
        end if

        %>

    <div>
        <span class="font-weight-bold">Name: </span><%= team_name%><br/>
        <span class="font-weight-bold">Description: </span><%=team_description%><br/>
        <span class="font-weight-bold">Country: </span><%= country_name%><br/>
        <span class="font-weight-bold">Founded: </span><%=team_founded_year%><br/>
        <span class="font-weight-bold">Coach: </span><%=coach_name%><br/>
    </div>    
    <div>
        <span class="font-weight-bold">Address: </span><%=address_name%><br/>
        <span class="font-weight-bold">City: </span><%=address_city%><br/>
        <span class="font-weight-bold">Street: </span><%=address_street%><br/>
        <span class="font-weight-bold">Postal Code: </span><%=address_postal_code %><br/>
    </div>    
    <div>
        <span class="font-weight-bold">Mail: </span><%=contact_email%><br/>
        <span class="font-weight-bold">WebSite: </span><%=contact_website%><br/>       
    </div>        
    <div>
        <span class="font-weight-bold">Phone: </span><%=phone_ddi%> - <%=phone_number%><br/>        
    </div>
    
<%
    end if 
    set rs = Nothing
end if  
objConn.close()
Set objConn = Nothing
%>