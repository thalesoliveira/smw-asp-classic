<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()

id = request("id")
action = request("action")

actionCreate = false

name = request.Form("name")
description = request.Form("description")
IdCountry = request.Form("country_id")
dt_born = request.Form("dt_born")


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
        msg_v = validadeFields("Name",name)
        msg_v = validadeFields("Description",description)        
        msg_v = validadeFields("Country",IdCountry)

        if isempty(msg_v) then        
            sql = "UPDATE t_coach SET coach='" & name & "', description='" & description & "', nacionality_id= '" & IdCountry & "',dt_born ='" & dt_born & "'" & " WHERE coach_id = " & id                   
            objConn.Execute(sql)

            call redirect("edit")
            response.end
        end if

    case "create"
        
        msg_v = validadeFields("Name",name)
        msg_v = validadeFields("Description",description)        
        msg_v = validadeFields("Country",IdCountry)
        
        if isempty(msg_v) then        
            sql = "INSERT INTO  t_coach (coach, description, nacionality_id, dt_born) VALUES ('" & name & "','" & description & "'," & IdCountry & ",'" & dt_born & "')"
            objConn.Execute(sql)
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
            Set rs = objConn.Execute(sql)
            if not rs.EOF then                
                name = rs("coach")
                description = rs("description")                
                Idcountry = rs("nacionality_id")                
                dt_born = rs("dt_born")                
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
                <div class="form-group">
                    <label for="state">Name</label>
                    <input type="text" class="form-control" id="name" name="name" value="<%=name%>" required>
                </div>
                
                <div class="form-group">
                    <label for="state">Description</label>
                    <input type="text" class="form-control" id="description" maxlength="20" name="description" value="<%=description%>" required>
                </div>

                <div class="form-group">
                    <label for="country">Country</label>
                    <select class="form-control" id="country_id" name="country_id" required>
                        <option value=""></option>
                        <%
                            sql = "SELECT country_id, country FROM t_country WHERE active = 1"
                            Set rs = objConn.Execute(sql)

                            do while not rs.EOF                              
                                countryId = rs("country_id")
                                country = rs("country")
                        %>
                        <option value="<%=countryId%>" <%if IdCountry = countryId then%> selected="selected" <%end if%>><%=country%></option>
                        <%
                                rs.MoveNext
                            loop
                            set rs = Nothing
                        %>                        
                    </select>
                </div>

                <div class="form-group w-25">
                    <div class="input-group date"  data-provide="datepicker">
                        <input type="text" name="dt_born" class="form-control" value="<% =dt_born%>">
                        <div class="input-group-addon">
                            <i class="fa fa-calendar fa-2x" aria-hidden="true"></i>
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
