<!--#include virtual="/config/bootstrap.asp"-->
<%
response.expires = 0
call verifiedLogin()
id = request.QueryString("id")
action = request.Form("action")

actionCreate = false

state_name = request.Form("state_name")
state_initials = request.Form("state_initials")
country_id = request.Form("country_id")

sub redirect(action)
    session("action") = action
	response.redirect("list-state.asp")
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
        msg_v = validadeFields("State",state_name)
        msg_v = validadeFields("Initials",state_initials)
               
        if isempty(msg_v) then
            call updatePositionPlayer(id, state_name, state_initials, country_id)            
            call redirect("edit")
            response.end
        end if

    case "create"
        msg_v = validadeFields("State",state_name)
        msg_v = validadeFields("Initials",state_initials)

        if isempty(msg_v) then        
            call insertState(state_name, state_initials, country_id)
            call redirect("create")
            response.end
        end if

    case "delete"
        if isempty(id) then        
            call removeState(id)
            response.write("ok")
            response.end            
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
            
            Set rs = findState(id)

            if not rs.EOF then
                state_name = rs("state_name")                
                id_country = rs("country_id")
                state_initials = rs("state_initials")
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
                <div class="form-group required">
                    <label class="control-label" for="state_name">State</label>
                    <input type="text" class="form-control" maxlength="50" size="50" id="state_name" name="state_name" value="<%=state_name%>" required>
                </div>
                <div class="form-group required">
                    <label class="control-label" for="state_initials">Initials</label>
                    <input type="text" class="form-control" maxlength="5" size="5"  id="state_initials" name="state_initials" value="<%=state_initials%>" required>
                </div>                
                <div class="form-group">
                    <label class="control-label" for="country">Country</label>
                    <select class="form-control" id="country_id" name="country_id">
                        <%                            
                            Set rs = listCountryActive()
                            do while not rs.EOF                              
                                country_id = rs("country_id")
                                country_name = rs("country_name")
                        %>
                                <option value="<%=country_id%>" <%if id_country = country_id then%> selected="selected" <%end if%>><%=country_name%></option>
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
                <a href="list-state.asp" class="btn btn-secondary">Voltar</a>
            </form>
        </div>
    </body>
</html>

<% 
objConn.close()
Set objConn = Nothing

%>
