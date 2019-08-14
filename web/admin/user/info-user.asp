<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
response.Charset="ISO-8859-1"
call verifiedLogin()
user_id = request("user_id")

if not isempty(user_id) then
    sql = "SELECT t_user.*, t_type_user.type_user_description, t_country.country_name, t_state.state_name FROM t_user" 
    sql = sql & " LEFT JOIN t_type_user ON t_type_user.type_user_id = t_user.type_user_id "
    sql = sql & " LEFT JOIN t_country ON t_country.country_id = t_user.country_id "
    sql = sql & " LEFT JOIN t_state ON t_state.state_id = t_user.state_id "
    sql = sql & " WHERE user_id = " & user_id
    Set rs = objConn.Execute(sql)           
    
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