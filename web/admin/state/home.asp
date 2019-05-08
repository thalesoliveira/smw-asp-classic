<!--#include virtual="/config/conexao.asp" -->
<% 
response.expires = 0
action = session("action")
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

        <% if Request.ServerVariables("HTTP_REFERER") <> "" and action <> "" then               
                if(action = "edit") then
                    msg = "State edited successfully!"
                else
                    msg = "State created successfully!"
                end if %>
                <div class="toast" style="position: absolute; top: 10; right: 0;  min-height: 20px;" role="alert" data-delay="700" data-autohide="false">            
                    <div class="toast-header">                        
                        <strong class="mr-auto">States</strong>
                        <button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">
                            <span aria-hidden="true">x</span>
                        </button>
                    </div>
                <div class="toast-body">
                <i class="fas fa-check-square"></i>
                <%=msg%>
            </div>
        </div>                
        <% end if%>

        <div class="container">        
            <h3 class="text-center">States</h3>            
            <div class="form-group">
                <a href="form.asp" class="btn btn-info">Create</a>  
            </div>
          
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
                    sql = "SELECT tc.country, tc.initials_alfa_2, ts.state, ts.initials,  ts.state_id FROM t_state ts" &_
                           " INNER JOIN t_country tc ON tc.country_id = ts.country_id  ;"
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

                $('.toast').toast('show');

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
<% Session.Contents.Remove("action")%>
