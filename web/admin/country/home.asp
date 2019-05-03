
<!doctype html>
<html lang="pt">
    <head>        
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        
        <link rel="stylesheet" type="text/css" href="../../node_modules/bootstrap/dist/css/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="../../node_modules/bootstrap/dist/css/bootstrap-grid.css">
        <link rel="stylesheet" type="text/css" href="../../node_modules/flag-icon-css/css/flag-icon.min.css">
        <link rel="stylesheet" type="text/css" href="../../assets/DataTables/datatables.min.css"/>      
   
        <script type="text/javascript" src="../../node_modules/jquery/dist/jquery.js"></script>
        <script type="text/javascript" src="../../assets/DataTables/datatables.min.js"></script>
        
		<title>Register - Country</title>
    </head>
    <body>
        <div class="container">
        

        <h3>Country</h3>        
            <table class="table table-hover table-striped" id="tb-country" style="width:100%">
                <thead>
                    <tr>
                        <th scope="col">Name</th>
                        <th scope="col">Description</th>
                        <th scope="col">Initials</th>
                    </tr>
                </thead>
                <tbody>
                    <tr> 
                        <td><h4><span class="flag-icon flag-icon-br"></span> Brazil</h4></td>
                        <td>9</td>
                        <td>9</td>
                    </tr>                    
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
            "infoFiltered": "(filtered from _MAX_ total records)"
        }
    } );
            });
        </script>

    </body>
</html>
