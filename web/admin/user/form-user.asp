<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<%
response.expires = 0
call verifiedLogin()

id = request("id")
action = request("action")

actionCreate = false

first_name = request.Form("first_name")
last_name = request.Form("last_name")
IdCountry = request.Form("country_id")
IdState = request.Form("state_id")
password = request.Form("password")
city = request.Form("city")
mail = request.Form("mail")
userIdType = request.Form("user_type_id")

sub redirect(action)
    session("action") = action
	response.redirect("list-form.asp")
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
        msg_v = validadeFields("First Name",first_name)
        msg_v = validadeFields("Last Name",last_name)       
        msg_v = validadeFields("User Type",userTypeId)
        msg_v = validadeFields("City",city)
        msg_v = validadeFields("Mail",mail)
        msg_v = validadeFields("Country",IdCountry)
        msg_v = validadeFields("State",IdState)
        msg_v = validadeFields("Password",password)

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
        
        msg_v = validadeFields("First Name",first_name)
        msg_v = validadeFields("Last Name",last_name)       
        msg_v = validadeFields("User Type",userTypeId)
        msg_v = validadeFields("City",city)
        msg_v = validadeFields("Mail",mail)
        msg_v = validadeFields("Country",IdCountry)
        msg_v = validadeFields("State",IdState)
        msg_v = validadeFields("Password",password)

        if isempty(msg_v) then        
            sql = "INSERT INTO t_user (first_name, last_name, type_user_id, country_id, state_id, city , mail, password_key) VALUES ('" & first_name & "','" & last_name & "'," & userIdType & "," & IdCountry & "," & IdState & ",'" & city & "','" & mail & "','" & password & "')"
            objConn.Execute(sql)
            call redirect("create")
            response.end
        end if

    case "delete"
        if isempty(id) then        
            sql = "DELETE t_user WHERE id = " & id
            objConn.Execute(sql)
            response.write("ok")
            response.end            
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
            sql = "SELECT * FROM t_user WHERE id = " & id
            Set rs = objConn.Execute(sql)
            if not rs.EOF then                
                first_name = rs("first_name")
                last_name = rs("last_name")
                city = rs("city")
                Idcountry = rs("country_id")
                mail = rs("mail")
                Idstate = rs("state_id")                
                userIdType = rs("type_user_id")
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
                <input type="hidden" name="Idstate" id="Idstate" value="<%=Idstate%>">
                <div class="form-group">
                    <label for="state">Fist Name</label>
                    <input type="text" class="form-control" id="first_name" name="first_name" value="<%=first_name%>" required>
                </div>
                
                <div class="form-group">
                    <label for="state">Last Name</label>
                    <input type="text" class="form-control" id="last_name" maxlength="5" name="last_name" value="<%=last_name%>" required>
                </div>

                <div class="form-group">
                    <label for="state">City</label>
                    <input type="text" class="form-control" id="city" maxlength="30" name="city" value="<%=city%>"  required>
                </div>

                <div class="form-group">
                    <label for="state">Mail</label>
                    <input type="text" class="form-control" id="mail" maxlength="20" name="mail" value="<%=mail%>" required>
                </div>

                <div class="form-group">
                    <label for="country">User Type</label>
                    <select class="form-control" id="user_type_id" name="user_type_id">
                        <%
                            sql = "SELECT * FROM t_type_user WHERE active = 1"
                            Set rs = objConn.Execute(sql)

                            do while not rs.EOF            
                                userTypeId = rs("id")
                                type_description = lcase(rs("type_description"))
                        %>
                            <option value="<%=userTypeId%>" <%if userIdType = userTypeId then%> selected="selected" <%end if%>><%=type_description%></option>
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

                <div class="form-group">
                    <label for="country">State</label>  
                    <span class="spinner-border spinner-border-sm" role="status" style="display: none;"></span>
                    <select class="form-control" id="state_id" name="state_id" style="display: none;"></select>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" maxlength="10" name="password" value="" <% if id <> "" then response.write("required")%> >
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
                                var Idstate = $('#Idstate').val();
                                $("#state_id").val(Idstate);
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
