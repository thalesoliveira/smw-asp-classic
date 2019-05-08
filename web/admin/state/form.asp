<!--# include virtual="/config/conexao.asp"-->
<%
response.expires = 0
%>

<!doctype html>
<html lang="pt">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!--#include virtual="/web/includes/header.html"-->
        <title>Register State</title>
    </head>
    <body>
    <!--#include virtual="/web/includes/nav.html"-->
        <div class="container">
            <form>
                <div class="form-group">
                    <label for="state">State</label>
                    <input type="text" class="form-control" id="state" name="state">
                </div>
                <div class="form-group">
                    <label for="state">Initials</label>
                    <input type="text" class="form-control" id="initials" name="initials">
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="active" id="active" value="No">
                    <label class="form-check-label" for="active-no">No</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="active" id="active" value="Yes">
                    <label class="form-check-label" for="active-yes">Yes</label>
                </div>
                <div class="form-group">
                    <label for="country">Country</label>
                    <select class="form-control" id="country">
                        <option></option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Save</button>
            </form>
        </div>
    </body>
</html>
