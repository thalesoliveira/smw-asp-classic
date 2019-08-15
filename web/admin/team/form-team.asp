<!--#include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
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
        msg_v = validadeFields("Coach",coach_id)
        msg_v = validadeFields("Founded",team_founded_year)

        if isempty(msg_v) then    

            objConn.BeginTrans

            sql = "UPDATE t_team SET team_name='" & team_name & "', team_description='" & team_description & "', country_id = " & id_country & ", coach_id =" & id_coach & ",team_founded_year ='" & team_founded_year & "'" & " WHERE team_id = " & id
            objConn.Execute(sql)


            if address_id then
                sql = "UPDATE t_address SET address_name='" & address_name & "', address_city='" & address_city & "', address_street = '" & address_street & "', address_postal_code ='" & address_postal_code & "' WHERE address_id = " & address_id
                objConn.Execute(sql)
            end if

            if contact_id then
                sql = "UPDATE t_contact SET contact_email='" & contact_email & "', contact_website='" & contact_website & "' WHERE contact_id = " & contact_id
                objConn.Execute(sql)
            end if


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

            sql = "INSERT INTO t_team (team_name, team_description, country_id, coach_id, team_founded_year) VALUES ('" & team_name & "','" & team_description & "'," & id_country & "," & id_coach & ",'" & team_founded_year & "')"
            objConn.Execute(sql)

            Set rs = objConn.Execute("SELECT max(team_id) as id_insert FROM t_team")
            if not rs.EOF then id_insert = rs("id_insert")

            if address_name <> "" or address_city <> "" or address_street <> "" or address_postal_code <> "" then              
               
                sql = "INSERT INTO  t_address (address_name, address_city, address_street, address_postal_code) VALUES ('" & address_name & "','" & address_city & "','" & address_street & "','" & address_postal_code & "')"
                objConn.Execute(sql)

                sql = "SELECT max(address_id) as max_address FROM t_address"
                Set rs = objConn.Execute(sql)
                if rs("max_address") > 0 then                    
                    max_address = rs("max_address")                  
                else
                    max_address = 1
                end if
                
                sql = "UPDATE t_team set address_id = " & max_address & " WHERE team_id = " & id_insert
                objConn.Execute(sql)

            end if

            if contact_email  <> "" or contact_website <> "" then
                sql = "INSERT INTO t_contact (contact_email, contact_website) VALUES ('" & contact_email& "','" & contact_website & "')"
                objConn.Execute(sql)

                sql = "SELECT max(contact_id) as max_contact FROM t_contact"
                Set rs = objConn.Execute(sql)
                if rs("max_contact") > 0 then              
                    max_contact = rs("max_contact")
                else
                    max_contact = 1
                end if

                sql = "UPDATE t_team set contact_id = " & max_contact & " WHERE team_id = " & id_insert
                objConn.Execute(sql)

            end if

            if phone_ddi  <> "" or phone_number <> "" then
                sql = "INSERT INTO t_phone (phone_ddi, phone_number) VALUES ('" & phone_ddi & "','" & phone_number & "')"
                objConn.Execute(sql)
                
                sql = "SELECT max(phone_id) as max_phone FROM t_phone"
                Set rs = objConn.Execute(sql)
                if rs("max_phone") > 0 then
                    max_phone = rs("max_phone")
                else
                    max_phone = 1
                end if

                sql = "INSERT INTO t_phone_team (phone_id, team_id) VALUES (" & max_phone & "," & id_insert & ")"
                objConn.Execute(sql)

            end if

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
            
            sql = "SELECT address_id, contact_id, phone_id FROM t_team LEFT JOIN t_phone_team ON t_phone_team.team_id = t_team.team_id WHERE t_team.team_id= " & id
            Set rs = objConn.Execute(cstr(sql))
            if not rs.EOF then

                address_id  = rs("address_id")
                contact_id  = rs("contact_id")
                phone_id    = rs("phone_id")

                objConn.BeginTrans

                objConn.Execute("DELETE t_team WHERE team_id  = " & id)

                if address_id <> "" then objConn.Execute("DELETE t_address WHERE address_id = " & address_id)
                if contact_id <> "" then objConn.Execute("DELETE t_contact WHERE contact_id = " & contact_id)
                if phone_id <> "" then 
                    objConn.Execute("DELETE t_phone_team WHERE team_id = " & id)
                    objConn.Execute("DELETE t_phone WHERE phone_id = " & phone_id)
                end if

                if Err <> 0 then
                    objConn.RollbackTrans
                    response.write Err.Description
                    response.end
                else
                    objConn.CommitTrans
                end if

            end if            

            response.write("ok")
            response.end            
        end if
    case else
        if ((trim(id) <> "" and not isnull(id)) and isnumeric(id)) then
            actionCreate = true
            sql = "SELECT * FROM t_team tt LEFT JOIN t_phone_team tpt ON tpt.team_id = tt.team_id WHERE tt.team_id = " & id
            Set rs = objConn.Execute(sql)
            if not rs.EOF then                
                team_name           = rs("team_name")
                team_description    = rs("team_description")
                id_country          = rs("country_id")
                id_coach            = rs("coach_id")
                team_founded_year   = rs("team_founded_year")
                address_id          = rs("address_id")
                contact_id          = rs("contact_id")
                phone_id            = rs("phone_id")

                if address_id <> "" then
                    sql = "SELECT * FROM t_address WHERE address_id = " & address_id
                    Set rs = objConn.Execute(cstr(sql))
                    if not rs.EOF then                        
                        address_name        = rs("address_name")
                        address_city        = rs("address_city")
                        address_street      = rs("address_street")
                        address_postal_code = rs("address_postal_code")
                    end if
                end if

                if contact_id <> "" then
                    sql = "SELECT * FROM t_contact WHERE contact_id = " & contact_id
                    Set rs = objConn.Execute(cstr(sql))
                    if not rs.EOF then                        
                        contact_email        = rs("contact_email")
                        contact_website      = rs("contact_website")
                    end if
                end if

                if phone_id <> "" then
                    sql = "SELECT * FROM t_phone WHERE phone_id = " & phone_id
                    Set rs = objConn.Execute(cstr(sql))
                    if not rs.EOF then                        
                        phone_ddi       = rs("phone_ddi")
                        phone_number    = rs("phone_number")
                    end if
                end if
                
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
