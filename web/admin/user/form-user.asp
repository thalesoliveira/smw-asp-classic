<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()

id = request("id")
action = request("action")

actionCreate = false

user_first_name  = request.Form("user_first_name")
user_last_name   = request.Form("user_last_name")
id_country       = request.Form("country_id")
id_state         = request.Form("state_id")
user_password    = request.Form("user_password")
user_login       = request.Form("user_login")
user_id_type     = request.Form("user_type_id")

sub redirect(action)
    session("action") = action
	response.redirect("list-user.asp")
	response.end    
End sub

function validadeFields(field, value)
    dim msg
    if value = "" then
        msg = "Enter a value for the " & field &" field"
    end if

    validadeFields=msg
End function

action = "delete"

dim msg_v
select case action 
    case "save"        
        msg_v = validadeFields("First Name",user_first_name)
        msg_v = validadeFields("Last Name",user_last_name)
        msg_v = validadeFields("User Type",user_type_id)
        msg_v = validadeFields("Mail/Login",user_login)
        msg_v = validadeFields("Country",id_country)
        msg_v = validadeFields("State",id_state)
        msg_v = validadeFields("Password",user_password)

        if isempty(msg_v) then        
            sql = "UPDATE t_user set first_name = '" & first_name & "', last_name = '" & last_name & "', type_user_id = '" & userIdType & "' WHERE id = " & id                   
            objConn.Execute(sql)

            sql = "UPDATE t_user set city = '" & city & "', mail = '" & mail & "', country_id= '" & IdCountry & "', state_id = '" & IdState  & "' WHERE id = " & id    
            objConn.Execute(sql)            

            if password <> "" then
                sql = "UPDATE t_user set password_key  = '" & password & "'" & " WHERE id = " & id	           
                objConn.Execute(sql)
            end if

            call redirect("edit")
            response.end
        end if

    case "create"
        
        msg_v = validadeFields("First Name",user_first_name)
        msg_v = validadeFields("Last Name",user_last_name)
        msg_v = validadeFields("User Type",user_type_id)
        msg_v = validadeFields("Mail/Login",user_login)
        msg_v = validadeFields("Country",id_country)
        msg_v = validadeFields("State",id_state)
        msg_v = validadeFields("Password",user_password)

        if isempty(msg_v) then        
            sql = "INSERT INTO t_user (user_first_name, user_last_name, type_user_id, country_id, state_id, user_login, user_password) VALUES ('" & user_first_name & "','" & user_last_name & "'," & user_id_type & "," & id_country & "," & id_state & ",'" & user_login & "','" & user_password & "')"
           
            objConn.Execute(cstr(sql))
            call redirect("create")
            response.end
        end if

    case "delete"
        if not isempty(id) then

            sql = "DELETE t_user WHERE user_id = " & id

            objConn.Execute(cstr(sql))
            response.write("ok")
            response.end
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
            sql = "SELECT * FROM t_user WHERE user_id = " & id
            Set rs = objConn.Execute(cstr(sql))
            if not rs.EOF then                
                user_first_name = rs("user_first_name")
                user_last_name  = rs("user_last_name")                
                id_country      = rs("country_id")
                user_login      = rs("user_login")
                id_state        = rs("state_id")                
                user_id_type    = rs("type_user_id")
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
        <title>Register User</title>
    </head>
    <body>
        <!--#include virtual="/web/includes/nav.html"-->
        <div class="container">
            <% if not isempty(msg_v) then %>
            <div class="alert alert-danger" role="alert">
            <%=msg_v%>
            </div>
            <% end if %>
        <h1>Register User</h1>
            <form method="POST">
                <input type="hidden" name="id" value="<%=id%>">
                <input type="hidden" name="id_state" id="id_state" value="<%=id_state%>">
                <div class="form-group required">
                    <label class="control-label" for="fist_name">Fist Name</label>
                    <input type="text" class="form-control" id="user_first_name" name="user_first_name" value="<%=user_first_name%>" required>
                </div>                
                <div class="form-group required">
                    <label class="control-label" for="last_name">Last Name</label>
                    <input type="text" class="form-control" id="user_last_name" maxlength="5" name="user_last_name" value="<%=user_last_name%>" required>
                </div>                
                <div class="form-group required">
                    <label class="control-label" for="mailo">Mail/Login</label>
                    <input type="email" class="form-control" id="user_login" maxlength="20" name="user_login" value="<%=user_login%>" required>
                </div>

                <div class="form-group">
                    <label for="country">User Type</label>
                    <select class="form-control" id="user_type_id" name="user_type_id">
                        <%
                            sql = "SELECT * FROM t_type_user WHERE type_user_active = 1"
                            Set rs = objConn.Execute(cstr(sql))

                            do while not rs.EOF
                                type_user_id = rs("type_user_id")
                                type_user_description = lcase(rs("type_user_description"))
                        %>
                            <option value="<%=type_user_id%>" <%if user_id_type = type_user_id then%> selected="selected" <%end if%>><%=type_user_description%></option>
                        <%
                                rs.MoveNext
                            loop
                            set rs = Nothing
                        %>                        
                    </select>
                </div>                
                <div class="form-group">
                    <label for="country">Country</label>
                    <select class="form-control" id="country_id" name="country_id">
                        <option value=""></option>
                        <%
                            sql = "SELECT country_id, country_name FROM t_country WHERE country_active = 1"
                            Set rs = objConn.Execute(cstr(sql))

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
                <div class="form-group">
                    <label for="country">State</label>  
                    <span class="spinner-border spinner-border-sm" role="status" style="display: none;"></span>
                    <select class="form-control" id="state_id" name="state_id" style="display: none;"></select>
                </div>
                <div class="form-group required">
                    <label class="control-label" for="password">Password</label>
                    <input type="password" class="form-control" id="user_password" maxlength="10" name="user_password" value="" <% if id <> "" then response.write("required")%> >
                </div>
                
                <% if id then %>
                    <button type="submit" name="action" class="btn btn-primary" value="save">Save</button>                
                <%else%>
                    <button type="submit" name="action" class="btn btn-primary" value="create">Create</button>
                <%end if%>
                <a href="list-user.asp" class="btn btn-secondary">Voltar</a>
            </form>
        </div>

        <script type="text/javascript">
            $(document).ready(function() {

                var country = $('#country_id').val();              
                if (country != "") {                   
                    load_state();
                }

                $('#country_id').change(function(e) {
                    load_state();
                });

                function load_state(){
                    var id = $('#country_id').val();                    
                    var option = '<option value="0"></option>';
                    $(".spinner-border").show();                    

                    if (typeof id !== 'undefined') {
                        $.ajax({
                            method: "POST",
                            url: "../state/action-state.asp",
                            beforeSend: function( xhr ) {
                                $(".spinner-border").show();
                            },
                            data: {id: id, action: "search" }
                        }).done(function(data) {
                            if (data.data.length > 0 ) {                                                            
                                $.each (data.data, function(i, obj) {
                                    option += '<option value="'+ obj.id + '">'+ obj.name + '</option>';                                    
                                })
                                $('#state_id').html(option).show(); 
                                var id_state = $('#id_state').val();
                                $("#state_id").val(id_state);
                            }                           

                        }).fail(function(textStatus) {
                            console.log(textStatus);
                            console.log(jqXHR);                        
                        });                        
                    }
                    $(".spinner-border").hide();                   
                }                
            });
        </script>
    </body>
</html>

<% 
objConn.close()
Set objConn = Nothing

%>
