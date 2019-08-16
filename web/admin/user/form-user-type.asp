<!--#include virtual="/config/bootstrap.asp"-->
<%
response.expires = 0
call verifiedLogin()
id = request("id")
action = request("action")
actionCreate = false

type_user_description = request.Form("type_user_description")
type_user_active = request.Form("type_user_active")

sub redirect(action)
    session("action") = action
	response.redirect("list-user-type.asp")
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
        msg_v = validadeFields("Description", type_user_description)
        msg_v = validadeFields("Active", type_user_active)
    
        if isempty(msg_v) then  
           
           
            call redirect("edit")
            response.end
        end if

    case "create"        
        msg_v = validadeFields("Description", type_user_description)
        msg_v = validadeFields("Active", type_user_active)
                
        if isempty(msg_v) then        
            call insertTypeUser(type_user_description , type_user_active)            
            call redirect("create")
            response.end
        end if

    case "delete"
        if not isempty(id) then
            call removeTypeUser(id)
            response.write("ok")
            response.end
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
            Set rs = findTypeUser(id)            
            if not rs.EOF then
                type_user_description   = rs("type_user_description")    
                type_user_active        = rs("type_user_active")
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
                    <label class="control-label" for="description">DESCRIPTION</label>
                    <input type="text" class="form-control" maxlenght="50" size= "50" id="type_user_description" name="type_user_description" value="<%=type_user_description%>" required>
                </div>                
                <div class="form-group">
                    <label for="active">ACTIVE</label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="type_user_active" value="1" <% if type_user_active = 1 then %>checked<% end if%>>
                        <label class="form-check-label" for="yes">YES</label>                       
                    </div>
                    <div class="form-check">                       
                        <input class="form-check-input" type="radio" name="type_user_active" value="0" <% if type_user_active = 0 then %>checked<% end if%>>
                        <label class="form-check-label" for="no">NO</label>
                    </div>                    
                </div>                
                <% if id then %>
                    <button type="submit" name="action" class="btn btn-primary" value="save">Save</button>                
                <%else%>
                    <button type="submit" name="action" class="btn btn-primary" value="create">Create</button>
                <%end if%>
                <a href="list-user-type.asp" class="btn btn-secondary">Voltar</a>
            </form>
        </div>        
    </body>
</html>
<% 
objConn.close()
Set objConn = Nothing
%>
