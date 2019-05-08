<!-- #include virtual="/config/conexao.asp" -->
<% 
response.expires = 0 
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
                sql = "SELECT country, initials_alfa_2, active FROM t_country;"
                Set rs = objConn.Execute(sql)
                do while not rs.EOF

                country = rs("country")
                initials = rs("initials_alfa_2")                
                active = "Yes" 
                if rs("active") <> 1 Then 
                    active = "Yes"
                end if
                
                flag = ""
                flag_initials = LCase(initials)

                if flag_initials <> "" Then
                    flag = "<span class='flag-icon " & "flag-icon-" & flag_initials & "'" & "></span>"
                end if
                %>
                    <tr> 
                        <td><%=flag & vbcrlf & country%></td>
                        <td><%=initials%></td>
                        <td><%=active%></td>
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
                $('#tb-country').DataTable( {
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
