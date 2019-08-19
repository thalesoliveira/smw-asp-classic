<!--#include virtual="/config/bootstrap.asp"-->
<%
response.expires = 0
call verifiedLogin()

id = request("id")
action = request("action")

actionCreate = false

team_name           = request.Form("team_name")
team_description    = request.Form("team_description")
id_country          = request.Form("country_id")
id_coach            = request.Form("coach_id")
team_founded_year   = request.Form("team_founded_year")

address_id          = request.Form("address_id")
address_name        = request.Form("address_name")
address_city        = request.Form("address_city")
address_street      = request.Form("address_street")
address_postal_code = request.Form("address_postal_code")

contact_id      = request.Form("contact_id")
contact_email   = request.Form("contact_email")
contact_website = request.Form("contact_website")

phone_id        = request.Form("phone_id")
phone_ddi       = request.Form("phone_ddi")
phone_number    = request.Form("phone_number")

dim reg_exp
set reg_exp = New RegExp
reg_exp.Global = True
reg_exp.Pattern = "[^\d]"
phone_number = reg_exp.Replace(phone_number, "")

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
        msg_v = validadeFields("Name",team_name)
        msg_v = validadeFields("Description",team_description)        
        msg_v = validadeFields("Country",country_id)
        msg_v = validadeFields("Coach",id_coach)
        msg_v = validadeFields("Founded",team_founded_year)

        if isempty(msg_v) then    

            objConn.BeginTrans

            call updateTeam(id, team_name, team_description, id_country, country_id, id_coach, team_founded_year, address_id, address_name, address_city, address_street,address_postal_code, contact_id, contact_email, contact_website, phone_ddi, phone_number)

            if Err <> 0 then
                objConn.RollbackTrans
                response.write Err.Description
                response.end
            else
                 objConn.CommitTrans
            end if

            call redirect("edit")
            response.end
        end if

    case "create"
        
        msg_v = validadeFields("Name",team_name)
        msg_v = validadeFields("Description",team_description)        
        msg_v = validadeFields("Country",country_id)
        msg_v = validadeFields("Coach",coach_id)
        msg_v = validadeFields("Founded",team_founded_year)
        
        if isempty(msg_v) then
            
            objConn.BeginTrans

            call insertTeam(team_name, team_description, country_id, coach_id, team_founded_year, address_name, address_city, address_street, address_postal_code, contact_email, contact_website, phone_ddi, phone_number)

            if Err <> 0 then
                objConn.RollbackTrans
                response.write Err.Description
                response.end
            else
                 objConn.CommitTrans
            end if
            
            call redirect("create")
            response.end
        end if

    case "delete"    
        if not isempty(id) then            

            objConn.BeginTrans

            call removeTeam(id)
            
            if Err <> 0 then
                objConn.RollbackTrans
                response.write Err.Description
                response.end
            else
                objConn.CommitTrans
            end if                       

            response.write("ok")
            response.end            
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
           
            Set rs = findTeamInfo(id)
            
            if not rs.EOF then                
                team_name           = rs("team_name")
                team_description    = rs("team_description")
                id_country          = rs("country_id")
                id_coach            = rs("coach_id")
                team_founded_year   = rs("team_founded_year")
                address_id          = rs("address_id")
                contact_id          = rs("contact_id")
                phone_id            = rs("phone_id")

                address_name        = rs("address_name")
                address_city        = rs("address_city")
                address_street      = rs("address_street")
                address_postal_code = rs("address_postal_code")                
                
                contact_email        = rs("contact_email")
                contact_website      = rs("contact_website")
                                        
                phone_ddi       = rs("phone_ddi")
                phone_number    = rs("phone_number")                
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
                <input type="hidden" name="address_id" value="<%=address_id%>">
                <input type="hidden" name="contact_id" value="<%=contact_id%>">
                <input type="hidden" name="phone_id" value="<%=phone_id%>">

                <div class="form-group required">
                    <label class="control-label" for="team_name">Name</label>
                    <input type="text" class="form-control" id="team_name" name="team_name" value="<%=team_name%>" required>
                </div>

                <div class="form-group">
                    <label class="control-label" for="team_description">Description</label>
                    <textarea class="form-control" id="team_description" name="team_description" rows="3"><%=team_description%></textarea>
                </div>   
           
                <div class="form-group required w-25">
                    <label class="control-label" for="team_founded_year">Founded Year</label>
                    <input type="text" class="form-control" id="team_founded_year" maxlength="4" name="team_founded_year" value="<%=team_founded_year%>" required>
                </div>
              
                <div class="form-group required">
                    <label class="control-label" for="coach">Coach</label>
                    <select  class="form-control" id="coach_id" name="coach_id" required>
                        <option value=""></option>
                        <%
                            sql = "SELECT coach_id, coach_name FROM t_coach"
                            Set rs = objConn.Execute(cstr(sql))

                            do while not rs.EOF        
                                coach_id    = rs("coach_id")
                                coach_name  = rs("coach_name")
                        %>
                        <option value="<%=coach_id%>" <%if id_coach = coach_id then%> selected="selected" <%end if%>><%=coach_name%></option>
                        <%
                                rs.MoveNext
                            loop
                            set rs = Nothing
                        %>                        
                    </select>
                </div> 

                <div class="form-group required">
                    <label class="control-label" for="address_name">Address</label>
                    <input type="text" class="form-control" id="address_name" maxlength="50" name="address_name" value="<%=address_name%>" required>
                </div>
                <div class="form-group">
                    <label class="control-label" for="address_street">Street</label>
                    <input type="text" class="form-control" id="address_street" maxlength="50" name="address_street" value="<%=address_street%>">
                </div>
                <div class="form-group required">
                    <div class="row">
                        <div class="col-md-10">
                            <label class="control-label" for="address_city">City</label>
                            <input type="text" class="form-control" id="address_city" maxlength="50" name="address_city" value="<%=address_city%>" required>
                        </div>
                        <div class="col-md-2">
                            <label for="address_postal_code">Postal Code</label>
                            <input type="text" class="form-control" id="address_postal_code" maxlength="20" name="address_postal_code" value="<%=address_postal_code%>">
                        </div>
                    </div>
                </div>
                <div class="form-group required">
                    <label class="control-label" for="country">Country</label>
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
                
                <div class="form-group">
                    <div class="row">
                        <div class="col">
                            <label class="control-label" for="contact_email">Mail</label>
                            <input type="mail" class="form-control" id="contact_email" maxlength="40" name="contact_email" value="<%=contact_email%>">
                        </div>

                        <div class="col">
                            <label for="contact_website">WebSite</label>
                            <input type="text" class="form-control" id="contact_website" maxlength="40" name="contact_website" value="<%=contact_website%>">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-1">
                            <label class="control-label" for="phone_ddi">DDI</label>
                            <input type="text" class="form-control" id="phone_ddi" maxlength="2" name="phone_ddi" value="<%=phone_ddi%>">
                        </div>

                        <div class="col-md-2">
                            <label class="control-label" for="phone_number">Phone</label>
                            <input type="text" class="form-control" id="phone_number" maxlength="15" name="phone_number" value="<%=phone_number%>">
                        </div>
                    </div>
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

                $("#phone_number").mask('(00) 00000-0000');

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
