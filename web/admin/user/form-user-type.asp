<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()
id = request("id")
action = request("action")
actionCreate = false

description = request.Form("description")
active = request.Form("active")

sub redirect(action)
    session("action") = action
	response.redirect("user-type.asp")
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
        msg_v = validadeFields("Description", description)
        msg_v = validadeFields("Active", active)
    
        if isempty(msg_v) then  
           sql = "UPDATE t_type_user SET type_description = '" & description & "', active = " & active & " WHERE id = " & id        
            objConn.Execute(sql)
           
            call redirect("edit")
            response.end
        end if

    case "create"
        
        msg_v = validadeFields("Description", description)
        msg_v = validadeFields("Active", active)
                
        if isempty(msg_v) then        
            sql = "INSERT INTO t_type_user (type_description, active) VALUES ('" & description & "'," & active & ")"
            objConn.Execute(sql)
            call redirect("create")
            response.end
        end if

    case "delete"
        if not isempty(id) then
            sql = "DELETE t_type_user WHERE id = " & id
            objConn.Execute(sql)
            response.write("ok")
            response.end            
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then

            actionCreate = true
            sql = "SELECT * FROM t_type_user WHERE id = " & id
            Set rs = objConn.Execute(sql)
            if not rs.EOF then
                description = rs("type_description")               
                active = rs("active")
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
                <div class="form-group">
                    <label for="state">DESCRIPTION</label>
                    <input type="text" class="form-control" id="description" name="description" value="<%=description%>" required>
                </div>
                
                <div class="form-group">
                    <label for="state">ACTIVE</label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="active" value="1" <% if active = 1 then %>checked<% end if%>>
                        <label class="form-check-label" for="yes">YES</label>                       
                    </div>
                    <div class="form-check">                       
                        <input class="form-check-input" type="radio" name="active" value="0" <% if active = 0 then %>checked<% end if%>>
                        <label class="form-check-label" for="no">NO</label>
                    </div>
                    
                </div>
                
                <% if id then %>
                    <button type="submit" name="action" class="btn btn-primary" value="save">Save</button>                
                <%else%>
                    <button type="submit" name="action" class="btn btn-primary" value="create">Create</button>
                <%end if%>
                <a href="user-type.asp" class="btn btn-secondary">Voltar</a>
            </form>
        </div>        
    </body>
</html>
<% 
objConn.close()
Set objConn = Nothing

%>
