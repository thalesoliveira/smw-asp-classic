<!-- #include virtual="/config/conexao.asp"-->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<% 
response.expires = 0 
call verifiedLogin()
%>
<!doctype html>
<html lang="pt">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!--#include virtual="/web/includes/header.html"-->
		<title>Country</title>
    </head>
    <body>
        <!--#include virtual="/web/includes/nav.html"-->
        <div class="container">
        <h3>Country</h3>        
            <table class="table table-hover table-striped" id="tb-country" style="width:100%">
                <thead>
                    <tr>
                        <th scope="col">Name</th>                        
                        <th scope="col">Initials</th>
                        <th scope="col">Active</th>
                    </tr>
                </thead>
                <tbody>
                <%
                sql = "SELECT country_id, country_name, country_initials_alfa_2, country_active FROM t_country;"
                Set rs = objConn.Execute(cstr(sql))
                do while not rs.EOF

                country_id = rs("country_id")
                country_name = rs("country_name")
                country_initials = rs("country_initials_alfa_2")                
                country_active = "Yes"
                badge = "badge-primary"

                if rs("country_active") <> 1 Then 
                    country_active = "No"
                    badge = "badge-danger"
                end if
                
                flag = ""
                flag_initials = LCase(country_initials)

                if flag_initials <> "" Then
                    flag = "<span class='flag-icon " & "flag-icon-" & flag_initials & "'" & "></span>"
                end if
                %>
                    <tr> 
                        <td><%=flag & vbcrlf & country_name %></td>
                        <td><%=country_initials%></td>
                        <td><a href="#" data-id="<%=country_id%>" id="btn-active" class="badge badge-pill <%=badge%>"><%=country_active%></a></td>                         
                    </tr>
                <%
                    rs.MoveNext 
                loop
                set rs = Nothing
                %>
                </tbody>
            </table>
        </div>          
        <script type="text/javascript">
            $(document).ready(function() {
                $(".badge").click(function() { 
                    var id = $(this).attr("data-id");

                    if (typeof id !== 'undefined') {
                        $.ajax({
                            method: "POST",
                            url: "inactive-country.asp",
                            data: {id: id, action: "inactive" }
                        }).done(function(data) {
                           location.reload();
                        }).fail(function(textStatus) {
                            alert(textStatus);
                            alert(jqXHR);
                        });
                    }
                });

                $('#tb-country').DataTable({
                    stateSave: true,
                    "language": {
                    "lengthMenu": "Display _MENU_ records per page",
                    "zeroRecords": "Nothing found - sorry",
                    "info": "Showing page _PAGE_ of _PAGES_",
                    "infoEmpty": "No records available",
                    "infoFiltered": "(filtered from _MAX_ total records)"}
                });
            });
        </script>
    </body>
</html>
