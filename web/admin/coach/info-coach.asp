<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
response.Charset="ISO-8859-1"
call verifiedLogin()
coach_id = request("coach_id")

if not isempty(coach_id) then
    sql = "SELECT t_coach.* , t_country.country_name FROM t_coach LEFT JOIN t_country ON t_country.country_id = t_coach.coach_nacionality_id WHERE coach_id = " & coach_id
    Set rs = objConn.Execute(sql)           
    
    if not rs.EOF then
        coach_name          = rs("coach_name")
        coach_description   = rs("coach_description")
        coach_born_date     = rs("coach_born_date")        
        country_name        = rs("country_name") %>
         
    <div>
        <span class="font-weight-bold">Name: </span><%= coach_name%><br/>
        <span class="font-weight-bold">Description: </span><%=coach_description%><br/>
        <span class="font-weight-bold">Nacionality: </span><%= country_name%><br/>
        <span class="font-weight-bold">Date Of Born: </span><%=coach_born_date%>
    </div>

<%
    end if 
    set rs = Nothing
end if  
objConn.close()
Set objConn = Nothing
%>