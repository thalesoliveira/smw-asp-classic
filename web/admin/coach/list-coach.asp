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
		<title>Coach</title>
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
                        <strong class="mr-auto">Coach</strong>
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
            <h3 class="text-center">Coach</h3>            
            <div class="form-group">
                <a href="form-coach.asp" class="btn btn-primary">Create Coach </a>                
            </div>
          
            <div class="table-responsive">     
                <table class="table table-hover table-striped" id="tb-coach" style="width:100%">
                    <thead>
                        <tr>
                            <th scope="col">Name</th>                            
                            <th scope="col">Nacionality</th>
                            <th style="width: 15%" class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    sql = "SELECT coach_id, coach_name, coach_nacionality_id FROM t_coach;"
                    Set rs = objConn.Execute(sql)
                    
                    do while not rs.EOF                        
                        coach_id        = rs("coach_id")
                        coach_name      = rs("coach_name")
                        coach_nacionality_id  = rs("coach_nacionality_id")

                        flag = ""
                        Set rs1 = objConn.Execute("SELECT country_name, country_initials_alfa_2  FROM t_country WHERE country_id = " & coach_nacionality_id)
                        if not rs1.EOF then 
                            country_name        = rs1("country_name")
                            country_initials    = rs1("country_initials_alfa_2")                            
                            flag_initials = LCase(country_initials)
                            if flag_initials <> "" Then
                                flag = "<span class='flag-icon " & "flag-icon-" & flag_initials & "'" & "></span>"
                            end if
                        end if
                        %>
                        <tr>
                            <td><%=coach_name%></td>
                            <td><%=flag & vbcrlf & country_name%></td>
                            <td>
                                <a href="form-coach.asp?id=<%=coach_id%>" class="btn btn-default" alt="Edit" title="Edit"><i class="fas fa-edit"></i></a>                                                       
                                <a href="#" class="btn btn-default" data-id="<%=coach_id%>" data-toggle="modal" data-target="#remove-coach-modal"><i class="fas fa-trash"></i></a>
                                <a href="#" class="btn btn-default info" data-id="<%=coach_id%>" data-toggle="modal" data-target="#info-coach-modal"><i class="fas fa-info-circle"></i></a>
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
        <div class="modal fade" id="remove-coach-modal" tabindex="-1" role="dialog" aria-labelledby="remove-coach-modal" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="dialog">
                <div class="modal-content panel-warning">
                    <div class="modal-header panel-heading">
                        <h5 class="modal-title" id="remove-coach-modal">Remove Coach ?</h5>
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

        <div id="dataModal" class="modal fade">  
            <div class="modal-dialog " role="dialog">
                <div class="modal-content panel-info">
                    <div class="modal-header panel-heading">
                        <h4 class="modal-title">Info Coach</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Fechar">
                            <span aria-hidden="true">&times;</span>
                        </button>                        
                    </div>
                    <div class="modal-body" id="info-coach"></div>  
                    <div class="modal-footer">  
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>  
                    </div>
                </div>
            </div>
        </div>
        
        <script type="text/javascript">
            $(document).ready(function() {
                var id;

                $('#remove-coach-modal').on('show.bs.modal', function (e) {
                    var dataId = $(e.relatedTarget).data('id');  
                    if (typeof dataId !== 'undefined') {
                       id = dataId;
                    }
                });

                $('#btn-confirm-remove').click(function () { 
                    if (typeof id !== 'undefined') {
                        $.ajax({
                            method: "POST",
                            url: "form-coach.asp",
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

                $('#tb-coach').DataTable({
                    "language": {
                        "lengthMenu": "Display _MENU_ records per page",
                        "zeroRecords": "Nothing found - sorry",
                        "info": "Showing page _PAGE_ of _PAGES_",
                        "infoEmpty": "No records available",
                        "infoFiltered": "(filtered from _MAX_ total records)"
                    }
                });

                $(".info").click(function() {
                    var coach_id = $(this).attr("data-id");                    
                    $.ajax({  
                        url:"info-coach.asp",  
                        method:"post",  
                        data:{coach_id:coach_id},  
                        success:function(data) {  
                            $('#info-coach').html(data);  
                            $('#dataModal').modal("show");  
                        }  
                    });  
                }); 

            });
        </script>
    </body>
</html>
<% Session.Contents.Remove("action")%>
