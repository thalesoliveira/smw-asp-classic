<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()

id = request("id")
action = request("action")

actionCreate = false

coach_name              = request.Form("coach_name")
coach_description       = request.Form("coach_description")
id_country              = request.Form("country_id")
coach_born_date         = request.Form("coach_born_date")


sub redirect(action)
    session("action") = action
	response.redirect("list-coach.asp")
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
        msg_v = validadeFields("Name",coach_name)
        msg_v = validadeFields("Description",coach_description)        
        msg_v = validadeFields("Country",id_country)

        if isempty(msg_v) then        
            sql = "UPDATE t_coach SET coach_name='" & coach_name & "', coach_description='" & coach_description & "', coach_nacionality_id= '" & id_country & "',coach_born_date ='" & coach_born_date & "'" & " WHERE coach_id = " & id                   
            objConn.Execute(cstr(sql))

            call redirect("edit")
            response.end
        end if

    case "create"
        
        msg_v = validadeFields("Name",coach_name)
        msg_v = validadeFields("Description",coach_description)        
        msg_v = validadeFields("Country",id_country)
        
        if isempty(msg_v) then        
            sql = "INSERT INTO  t_coach (coach_name, coach_description, coach_nacionality_id, coach_born_date) VALUES ('" & coach_name & "','" & coach_description & "'," & id_country & ",'" & coach_born_date & "')"
            objConn.Execute(cstr(sql))
            call redirect("create")
            response.end
        end if

    case "delete"
    
        if not isempty(id) then        
            sql = "DELETE t_coach WHERE coach_id  = " & id
            objConn.Execute(sql)
            response.write("ok")
            response.end            
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
            sql = "SELECT * FROM t_coach WHERE coach_id = " & id
            Set rs = objConn.Execute(cstr(sql))
            if not rs.EOF then                
                coach_name          = rs("coach_name")
                coach_description   = rs("coach_description")                
                id_country          = rs("coach_nacionality_id")                
                coach_born_date     = rs("coach_born_date")
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
        <title>Register Coach</title>
    </head>
    <body>
        <!--#include virtual="/web/includes/nav.html"-->
        <div class="container">
            <% if not isempty(msg_v) then %>
            <div class="alert alert-danger" role="alert">
            <%=msg_v%>
            </div>
            <% end if %>
        <h1>Register Coach</h1>
            <form method="POST">
                <input type="hidden" name="id" value="<%=id%>">
                <input type="hidden" name="Idstate" id="Idstate" value="<%=Idstate%>">
                <div class="form-group required">
                    <label class="control-label" for="coach_name">Name</label>
                    <input type="text" class="form-control" id="coach_name" name="coach_name" value="<%=coach_name%>" required>
                </div>

                <div class="form-group">
                    <label for="coach_description">Description</label>
                    <textarea class="form-control" id="coach_description" name="coach_description" rows="3"><%=coach_description%></textarea>
                </div>                
                
                <div class="form-group required">
                    <label class="control-label" for="country">Nacionality</label>
                    <select class="form-control" id="country_id" name="country_id" required>
                        <option value=""></option>
                        <%
                            sql = "SELECT country_id, country_name FROM t_country WHERE country_active = 1"
                            Set rs = objConn.Execute(cstr(sql))

                            do while not rs.EOF
                                country_id      = rs("country_id")
                                country_name    = rs("country_name")
                        %>
                        <option value="<%=country_id%>" <%if id_country = country_id then%> selected="selected" <%end if%>><%=country_name%></option>
                        <%
                                rs.MoveNext
                            loop
                            set rs = Nothing
                        %>
                    </select>
                </div>

                <div class="form-group w-25">
                    <label for="country">Date Of Born</label>
                    <div class="input-group date"  data-provide="datepicker">
                        <input type="text" id="coach_born_date" name="coach_born_date" class="form-control" value="<% =coach_born_date%>">
                        <div class="input-group-addon">
                            <i class="fa fa-calendar-alt fa-2x" aria-hidden="true"></i>
                        </div>
                    </div>
                </div>    
           
                <% if id then %>
                    <button type="submit" name="action" class="btn btn-primary" value="save">Save</button>                
                <%else%>
                    <button type="submit" name="action" class="btn btn-primary" value="create">Create</button>
                <%end if%>
                <a href="list-coach.asp" class="btn btn-secondary">Voltar</a>
            </form>
        </div>

        <script type="text/javascript">
            $(document).ready(function() {
                $.fn.datepicker.defaults.language = 'pt-BR';
                $('.datepicker').datepicker({});
            });
        </script>
    </body>
</html>

<% 
objConn.close()
Set objConn = Nothing

%>
