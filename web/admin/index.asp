<!-- #include virtual="/config/conexao.asp" -->
<%
response.expires = 0
action = trim(lcase(request("action")))

Dim rs, login, message

If session("user_id") = "" Then
    Select case action
        case "login"

            user_login = trim(replace(request("email"),"'","''"))
            user_password = trim(replace(request("password"),"'","''"))

            If user_login = "" Then
                message = "email is required! <br/>"
            End If
            If user_password = "" Then
                message = message & "password is required! <br/>"
            End If

            If message = "" Then
                sql = "SELECT * FROM t_user WHERE user_login ='" & user_login & "'"
                Set rs = objConn.Execute(sql)
            
                If rs.EOF Then
                    login = false
                    message = message & "email not found! <br/>"
                Else
                    login = true
                End If

                If login Then
                    sql = "SELECT user_id FROM t_user WHERE user_login ='" & user_login & "' AND user_password = '" & user_password & "'"
                    Set rs = objConn.Execute(sql)    
                    
                    If rs.EOF Then
                        message = " user not found! <br/>"
                    Else
                        session("user_id") = rs("user_id")
                        response.redirect("home.asp")
                        response.end
                    End If
                End If

            End If
    End select
Else

if not session("user_id") = "" and action = "logout" then
    Session.Abandon()    
    response.redirect("index.asp")
    response.end
end if

Response.redirect("home.asp")
response.end
End If

%>
<!doctype html>
<html lang="pt">
    <head>
        <!-- Required meta tags -->        
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">		
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="../node_modules/bootstrap/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../node_modules/bootstrap/dist/css/bootstrap-grid.min.css">

        <link rel="stylesheet" href="../assets/style.css">

        <script src="../node_modules/jquery/dist/jquery.min.js"></script>

		<title>Login</title>
    </head>
    <body>
        <div class="container">
            <div class="row">             
			    <div class="col-md-6 mx-auto">
                    <% 
                    If Not message = "" Then
                        response.write ("<div class='alert alert-danger message' role='alert'>" & message & "</div>") 
                    End if 
                    %>
				    <div class="dv-form form">
					     <div class="logo mb-3">                          
						    <div class="col-md-12 text-center">
							    <h1 class="text-white">Login</h1>
						    </div>
					    </div>                       
                        <form action="" method="post" name="login">
                            
                            <div class="form-group">
                                <label for="email" class="text-white">Email address</label>
                                <input type="email" name="email" class="form-control" id="email" aria-describedby="emailHelp" placeholder="Enter email" required>
                           </div>
                           <div class="form-group">
                                <label for="password" class="text-white">Password</label>
                                <input type="password" name="password" id="password"  class="form-control" aria-describedby="emailHelp" placeholder="Enter Password" required>
                           </div>
                           <div class="form-group">
                                <p class="text-center text-white">By signing up you accept our <a href="#">Terms Of Use</a></p>
                           </div>
                           <div class="col-md-12 text-center ">
                                <button type="submit" class=" btn btn-block btn-border btn-primary btn-color text-upper" name="action" value="login">Login</button>
                           </div>                           
                        </form>
			        </div>
		        </div>
            </div>
        </div>    
    </body>
</html>