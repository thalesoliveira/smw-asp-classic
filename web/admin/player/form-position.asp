<!--#include virtual="/config/bootstrap.asp"-->
<%
response.expires = 0
call verifiedLogin()
id = request("id")
action = request("action")
actionCreate = false

position_player_name = request.Form("position_player_name")

sub redirect(action)
    session("action") = action
	response.redirect("list-position.asp")
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
        msg_v = validadeFields("Description", position_player_name)            
        if isempty(msg_v) then
            call updatePositionPlayer(id, position_player_name)
            call redirect("edit")
            response.end
        end if

    case "create"        
        msg_v = validadeFields("Description", position_player_name)                        
        if isempty(msg_v) then        
            call insertPositionPlayer(position_player_name)
            call redirect("create")
            response.end
        end if

    case "delete"
        if not isempty(id) then
            call removePositionPlayer(id)
            response.write("ok")
            response.end
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
            Set rs = findPositionPlayer(id)            
            if not rs.EOF then
                id = rs("position_player_id")
                position_player_name = rs("position_player_name")
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
        <title>Register User Type</title>
    </head>
    <body>
        <!--#include virtual="/web/includes/nav.html"-->
        <div class="container">
            <% if not isempty(msg_v) then %>
            <div class="alert alert-danger" role="alert">
            <%=msg_v%>
            </div>
            <% end if %>
        <h1>Register User Type</h1>
            <form method="POST">
                <input type="hidden" name="id" value="<%=id%>">
                <div class="form-group required">
                    <label class="control-label" for="position_player_name">DESCRIPTION</label>
                    <input type="text" maxlength="50" size="50" class="form-control" id="position_player_name" name="position_player_name" value="<%=position_player_name%>" required>
                </div>               
                
                <% if id then %>
                    <button type="submit" name="action" class="btn btn-primary" value="save">Save</button>                
                <%else%>
                    <button type="submit" name="action" class="btn btn-primary" value="create">Create</button>
                <%end if%>
                <a href="list-position.asp" class="btn btn-secondary">Voltar</a>
            </form>
        </div>        
    </body>
</html>
<% 
objConn.close()
Set objConn = Nothing

%>
