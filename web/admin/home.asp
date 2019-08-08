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
        <link rel="stylesheet" type="text/css" href="../node_modules/bootstrap/dist/css/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="../node_modules/bootstrap/dist/css/bootstrap-grid.css">
		<title>Home</title>
    </head>
    <body>
       <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <a class="navbar-brand" href="#"><i class="fab fa-wolf-pack-battalion"></i></a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
                <div class="navbar-nav">
                    <a class="nav-item nav-link" href="#">Home<span class="sr-only">(current)</span></a>
			        <a class="nav-item nav-link" href="/web/admin/country/home.asp">Country<span class="sr-only"></span></a>
                    <a class="nav-item nav-link" href="/web/admin/state/home.asp">State<span class="sr-only"></span></a>
                    <a class="nav-item nav-link" href="/web/admin/user/home.asp">User<span class="sr-only"></span></a>
                    <a class="nav-item nav-link" href="index.asp?action=logout">Logout</a>      
                </div>
            </div>
        </nav>
        <div class="container"> 
            <a href="/web/admin/state/home.asp" class="btn btn-primary btn-lg btn-block" alt="Edit" title="Edit">List Countries</a>
            <a href="/web/admin/state/home.asp" class="btn btn-primary btn-lg btn-block" alt="Edit" title="Edit">List States</a>
            <a href="/web/admin/state/home.asp" class="btn btn-secondary btn-lg btn-block" alt="Edit" title="Edit">List Users</a>
            <a href="/web/admin/state/home.asp" class="btn btn-secondary btn-lg btn-block" alt="Edit" title="Edit">List Type Users</a>
        </div>      
    </body>
</html>

