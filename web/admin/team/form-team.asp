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
	response.redirect("list-team.asp")
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
        
        response.write(name)
        response.end

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
        <title>Register Team</title>
    </head>
    <body>
        <!--#include virtual="/web/includes/nav.html"-->
        <div class="container">
            <% if not isempty(msg_v) then %>
            <div class="alert alert-danger" role="alert">
            <%=msg_v%>
            </div>
            <% end if %>
        <h1>Register Team</h1>
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

                <div class="form-group w-25">
                    <label for="state">Founded Year</label>
                    <input type="text" class="form-control" id="founded_year" maxlength="4" name="founded_year" value="<%=founded_year%>" required>
                </div>
              
                <div class="form-group">
                    <label for="coach">Coach</label>
                    <select class="form-control" id="coach_id" name="coach_id" required>
                        <option value=""></option>
                        <%
                            sql = "SELECT coach_id, coach FROM t_coach"
                            Set rs = objConn.Execute(sql)

                            do while not rs.EOF        
                                coachId = rs("coach_id")
                                coach = rs("coach")
                        %>
                        <option value="<%=coachId%>" <%if IdCoach = coachId then%> selected="selected" <%end if%>><%=coach%></option>
                        <%
                                rs.MoveNext
                            loop
                            set rs = Nothing
                        %>                        
                    </select>
                </div> 

                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" class="form-control" id="address" maxlength="50" name="address" value="<%=address%>" required>
                </div>
                <div class="form-group">
                    <label for="city">City</label>
                    <input type="text" class="form-control" id="city" maxlength="50" name="city" value="<%=city%>" required>
                </div>
                <div class="form-group">
                    <label for="street">Street</label>
                    <input type="text" class="form-control" id="street" maxlength="50" name="street" value="<%=street%>">
                </div>
                <div class="form-group">
                    <label for="Postal Code">Postal Code</label>
                    <input type="text" class="form-control" id="postal_code" maxlength="50" name="postal_code" value="<%=postal_code%>">
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

                 <div class="form-group">
                    <label for="country">State</label>  
                    <span class="spinner-border spinner-border-sm" role="status" style="display: none;"></span>
                    <select class="form-control" id="state_id" name="state_id" style="display: none;"></select>
                </div>

                <div class="form-group">
                    <label for="mail">Mail</label>
                    <input type="mail" class="form-control" id="mail" maxlength="20" name="mail" value="<%=mail%>">
                </div>

                <div class="form-group w-25">
                    <label for="phone">Phone</label>
                    <input type="text" class="form-control" id="phone" maxlength="20" name="phone" value="<%=phone%>">
                </div>
           
                <% if id then %>
                    <button type="submit" name="action" class="btn btn-primary" value="save">Save</button>                
                <%else%>
                    <button type="submit" name="action" class="btn btn-primary" value="create">Create</button>
                <%end if%>
                <a href="list-team.asp" class="btn btn-secondary">Voltar</a>
            </form>
        </div>

        <script type="text/javascript">
            $(document).ready(function() {

                $("#phone").mask('(00) 00000-0000');

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
