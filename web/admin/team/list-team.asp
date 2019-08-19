<!--#include virtual="/config/bootstrap.asp" -->
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
		<title>Team</title>
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
                        <strong class="mr-auto">Team</strong>
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
            <h3 class="text-center">Team</h3>      
            <div class="form-group">
                <a href="form-team.asp" class="btn btn-primary">Create Team</a>
            </div>
          
            <div class="table-responsive">     
                <table class="table table-hover table-striped" id="tb-team" style="width:100%">
                    <thead>
                        <tr>
                            <th scope="col">Name</th>
                            <th scope="col">Country</th>                            
                            <th style="width: 15%" class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    
                    Set rs = listTeam()
                    
                    do while not rs.EOF
                        team_id         = rs("team_id")
                        team_name       = rs("team_name")                        
                        country_id      = rs("country_id")
                        country_name    = rs("country_name")
                        country_initials = rs("country_initials_alfa_2")                  

                        flag = ""
                        flag_initials = LCase(country_initials)
                        if flag_initials <> "" Then flag = "<span class='flag-icon " & "flag-icon-" & flag_initials & "'" & "></span>"
                        %>
                        <tr>
                            <td><%=team_name%></td>
                            <td><%=flag & vbcrlf & country_name%></td>                                                   
                            <td>
                                <a href="form-team.asp?id=<%=team_id%>" class="btn btn-default" alt="Edit" title="Edit"><i class="fas fa-edit"></i></a>                                                       
                                <a href="#" class="btn btn-default" data-id="<%=team_id%>" data-toggle="modal" data-target="#remove-team-modal"><i class="fas fa-trash"></i></a>
                                <a href="#" class="btn btn-default info" data-id="<%=team_id%>" data-toggle="modal" data-target="#info-team-modal"><i class="fas fa-info-circle"></i></a>
                            </td>
                        </tr>
                    <%
                        rs.MoveNext 
                    loop

                    objConn.close            
                    set rs = Nothing            
                    set objConn = Nothing                   
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="remove-team-modal" tabindex="-1" role="dialog" aria-labelledby="remove-team-modal" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="dialog">
                <div class="modal-content panel-warning">
                    <div class="modal-header panel-heading">
                        <h5 class="modal-title" id="remove-team-modal">Remove Team ?</h5>
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
                        <h4 class="modal-title">Info Team</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Fechar">
                            <span aria-hidden="true">&times;</span>
                        </button>                        
                    </div>
                    <div class="modal-body" id="info-team"></div>  
                    <div class="modal-footer">  
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>  
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(document).ready(function() {
                var id;

                $('#remove-team-modal').on('show.bs.modal', function (e) {
                    var dataId = $(e.relatedTarget).data('id');  
                    if (typeof dataId !== 'undefined') {
                       id = dataId;
                    }
                });

                $('#btn-confirm-remove').click(function () { 
                    if (typeof id !== 'undefined') {
                        $.ajax({
                            method: "POST",
                            url: "form-team.asp",
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

                loadDataTable("#tb-team");

                $(".info").click(function() {
                    var team_id = $(this).attr("data-id");                    
                    $.ajax({  
                        url:"info-team.asp",  
                        method:"post",  
                        data:{team_id:team_id},  
                        success:function(data) {  
                            $('#info-team').html(data);  
                            $('#dataModal').modal("show");  
                        }  
                    });  
                }); 


            });
        </script>
    </body>
</html>
<% Session.Contents.Remove("action")%>
