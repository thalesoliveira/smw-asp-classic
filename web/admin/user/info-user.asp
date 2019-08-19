<!--#include virtual="/config/bootstrap.asp"-->
<%
response.expires = 0
response.Charset="ISO-8859-1"
call verifiedLogin()
user_id = request("user_id")

if not isempty(user_id) then
    Set rs = findUserInfo(user_id) 
    
    if not rs.EOF then
        user_first_name = rs("user_first_name")
        user_last_name  = rs("user_last_name")
        user_login      = rs("user_login")
        user_login      = rs("user_login")

        type_user_description   = rs("type_user_description")
        country_name            = rs("country_name")
        state_name              = rs("state_name")
    %>
         
    <div>
        <span class="font-weight-bold">Fist Name: </span><%=user_first_name%><br/>
        <span class="font-weight-bold">Last Name: </span><%=user_last_name%><br/>
        <span class="font-weight-bold">Mail/Login: </span><%=user_login%><br/>
        <span class="font-weight-bold">User Type: </span><%=type_user_description%><br/>
        <span class="font-weight-bold">Country: </span><%=country_name%><br/>
        <span class="font-weight-bold">State: </span><%=state_name%>
    </div>

<%
    end if 
    set rs = Nothing
end if  
objConn.close()
Set objConn = Nothing
%>