<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()
id = request.QueryString("id")
action = request.Form("action")

actionCreate = false

state = request.Form("state")
initials = request.Form("initials")
countryId = request.Form("country_id")

sub redirect(action)
    session("action") = action
	response.redirect("home.asp")
	response.end    
End sub

function validadeFields(field, value)
    dim msg
    if value = "" then
        msg = "Enter a value for the " & field &" field"
    end if

    validadeFields=msg
End function

dim msg_v
select case action 
    case "save"        
        msg_v = validadeFields("State",state)
        msg_v = validadeFields("Initials",initials)
               
        if isempty(msg_v) then        
            sql = "UPDATE t_state set state = '" & state & "', initials = '" & initials & "', country_id = '" & countryId & "' WHERE state_id = " & id	           
            objConn.Execute(sql)
            call redirect("edit")
            response.end
        end if

    case "create"
        msg_v = validadeFields("State",state)
        msg_v = validadeFields("Initials",initials)

        if isempty(msg_v) then        
            sql = "INSERT INTO t_state (state, initials, country_id) VALUES ('" & state & "','" & initials & "'," & countryId & ")"
            objConn.Execute(sql)
            call redirect("create")
            response.end
        end if

    case "delete"
        if isempty(id) then        
            sql = "DELETE t_state WHERE state_id = " & id
            objConn.Execute(sql)
            response.write("ok")
            response.end            
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
            sql = "SELECT * FROM t_state WHERE state_id = " & id
            Set rs = objConn.Execute(sql)

            if not rs.EOF then
                state = rs("state")
                initials = rs("initials")
                Idcountry = rs("country_id")
            end if
            set rs = Nothing    
        end if
end select
%>

<!doctype html>
<html lang="pt">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!--#include virtual="/web/includes/header.html"-->
        <title>Register State</title>
    </head>
    <body>
        <!--#include virtual="/web/includes/nav.html"-->
        <div class="container">
            <% if not isempty(msg_v) then %>
            <div class="alert alert-danger" role="alert">
            <%=msg_v%>
            </div>
            <% end if %>
        <h1>Register State</h1>
            <form method="POST">
                <input type="hidden" name="id" value="<%=id%>">
                <div class="form-group">
                    <label for="state">State</label>
                    <input type="text" class="form-control" id="state" name="state" value="<%=state%>" required>
                </div>
                <div class="form-group">
                    <label for="state">Initials</label>
                    <input type="text" class="form-control" id="initials" maxlength="5" name="initials" value="<%=initials%>" required>
                </div>                
                <div class="form-group">
                    <label for="country">Country</label>
                    <select class="form-control" id="country_id" name="country_id">
                        <%
                            sql = "SELECT country_id, country FROM t_country WHERE active = 1"
                            Set rs = objConn.Execute(sql)

                            do while not rs.EOF                              
                                countryId = rs("country_id")
                                country = rs("country")
                        %>
                        <option value="<%=countryId%>" <%if Idcountry = countryId then%> selected="selected" <%end if%>><%=country%></option>
                        <%
                                rs.MoveNext
                            loop
                            set rs = Nothing
                        %>                        
                    </select>
                </div>
                
                <% if id then %>
                    <button type="submit" name="action" class="btn btn-primary" value="save">Save</button>                
                <%else%>
                    <button type="submit" name="action" class="btn btn-primary" value="create">Create</button>
                <%end if%>
                <a href="home.asp" class="btn btn-secondary">Voltar</a>
            </form>
        </div>
    </body>
</html>

<% 
objConn.close()
Set objConn = Nothing

%>
