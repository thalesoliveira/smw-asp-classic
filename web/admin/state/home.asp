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
		<title>State</title>
    </head>

    <body>
        <!--#include virtual="/web/includes/nav.html"-->
        <div class="container">
            <h3>State</h3>
            <div class="table-responsive">     
                <table class="table table-hover table-striped" id="tb-country" style="width:100%">
                    <thead>
                        <tr>
                            <th scope="col">Name</th>                        
                            <th scope="col">Initials</th>
                            <th scope="col">Country</th>
                            <th scope="col" style="width: 5.66%">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    sql = "SELECT tc.country, tc.initials_alfa_2, ts.state, ts.initials,  ts.state_id FROM t_state ts INNER JOIN t_country tc ON tc.country_id = ts.country_id  ;"
                    Set rs = objConn.Execute(sql)
                    
                    
                    do while not rs.EOF
                        country = rs("country")
                        country_initials = rs("initials_alfa_2")
                
                        state_id =  rs("state_id")
                        state = rs("state")
                        initials = rs("initials")                               
                
                        flag = ""
                        flag_initials = LCase(country_initials)

                        if flag_initials <> "" Then
                            flag = "<span class='flag-icon " & "flag-icon-" & flag_initials & "'" & "></span>"
                        end if %>
                        <tr>
                            <td><%=state%></td>
                            <td><%=initials%></td>
                            <td><%=flag & vbcrlf & country%></td>
                            <td>
                                <a href="form.asp?id=<%=state_id%>" class="btn btn-success" alt="Edit" title="Edit"><i class="fas fa-edit"></i></a>                            
                            </td>
                        </tr>
                    <%
                        rs.MoveNext 
                    loop
                    set rs = Nothing
                    %>
                    </tbody>
                </table>
            </div>
        </div>
          
        <script type="text/javascript">
            $(document).ready(function() {
                $('#tb-country').DataTable({
                    "language": {
                        "lengthMenu": "Display _MENU_ records per page",
                        "zeroRecords": "Nothing found - sorry",
                        "info": "Showing page _PAGE_ of _PAGES_",
                        "infoEmpty": "No records available",
                        "infoFiltered": "(filtered from _MAX_ total records)"
                    }
                });
            });
        </script>
    </body>
</html>
