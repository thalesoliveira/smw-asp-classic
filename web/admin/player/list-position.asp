<!--#include virtual="/config/conexao.asp" -->
<!--#include virtual="/web/src/verifiedLogin.asp"-->
<% 
response.expires = 0
call verifiedLogin()
action = session("action")

%>
<!doctype html>
<html lang="pt">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">     
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">        
        <!--#include virtual="/web/includes/header.html"--> 
		<title>Position Player</title>
    </head>
    <body>
        <!--#include virtual="/web/includes/nav.html"-->

        <% if Request.ServerVariables("HTTP_REFERER") <> "" and action <> "" then               
                if(action = "edit") then
                    msg = "User edited successfully!"
                else
                    msg = "User created successfully!"
                end if %>
                <div class="toast" style="position: absolute; top: 10; right: 0;  min-height: 20px;" role="alert" data-delay="700" data-autohide="false">            
                    <div class="toast-header">                        
                        <strong class="mr-auto">Position</strong>
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
            <h3 class="text-center">Position Player</h3>            
            <div class="form-group">
                <a href="form-position.asp" class="btn btn-primary">Create</a>  
            </div>
          
            <div class="table-responsive">     
                <table class="table table-hover table-striped" id="tb-position" style="width:100%">
                    <thead>
                        <tr>
                            <th scope="col">Description</th>                            
                            <th style="width: 12%" class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    sql = "SELECT * FROM t_position_player"
                    Set rs = objConn.Execute(sql)                    
                    
                    do while not rs.EOF
                        name = rs("name")                        
                        id = rs("position_player_id")
                        %>
                        <tr>
                            <td><%=name%></td>                            
                            <td>
                                <a href="form-position.asp?id=<%=id%>" class="btn btn-default" alt="Edit" title="Edit"><i class="fas fa-edit"></i></a>                                
                                <a href="#" class="btn btn-default" data-id="<%=id%>" data-toggle="modal" data-target="#remove-modal"><i class="fas fa-trash"></i></a>                                
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

        <!-- Modal -->
        <div class="modal fade" id="remove-modal" tabindex="-1" role="dialog" aria-labelledby="remove-modal" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="dialog">
                <div class="modal-content panel-warning">
                    <div class="modal-header panel-heading">
                        <h5 class="modal-title" id="remove-modal">Remove Position ?</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Fechar">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>      
                    <div class="modal-footer">        
                        <button type="button" id="btn-confirm-remove" class="btn btn-danger">Remove</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(document).ready(function() {
                var id;

                $('#remove-modal').on('show.bs.modal', function (e) {
                    var dataId = $(e.relatedTarget).data('id');  
                    if (typeof dataId !== 'undefined') {
                       id = dataId;
                    }
                });

                $('#btn-confirm-remove').click(function () { 
                    if (typeof id !== 'undefined') {
                        $.ajax({
                            method: "POST",
                            url: "form-position.asp",
                            data: {id: id, action: "delete" }
                        }).done(function(data) {                             
                           location.reload();                           
                        }).fail(function(textStatus) {
                            alert(textStatus);
                            alert(jqXHR);                        
                        });
                    }
                });
                                
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
