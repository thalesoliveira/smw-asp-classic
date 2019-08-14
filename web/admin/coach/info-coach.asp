<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()
coach_id = request("coach_id")

if not isempty(coach_id) then
    sql = "SELECT * FROM t_coach WHERE coach_id = " & coach_id
    Set rs = objConn.Execute(sql)           
    
    if not rs.EOF then
        coach_name = rs("coach_name")
        coach_description = rs("coach_description")
        coach_born_date = rs("coach_born_date")
        coach_nacionality_id = rs("coach_nacionality_id")


        if not coach_nacionality_id = "" then
            sql1 = "SELECT country_name FROM t_country WHERE country_id = " & coach_nacionality_id
            Set rs1 = objConn.Execute(sql1)
            if not rs1.EOF then
                country_name    = rs1("country_name")                
            end if
            set rs1 = Nothing
        end if %>
         
    <div class="form-group">
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