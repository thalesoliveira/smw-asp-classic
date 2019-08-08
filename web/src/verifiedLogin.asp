<%
public function verifiedLogin()

if session("user_id") = "" then
    response.redirect("/web/admin/index.asp")
	response.end
end if
end function

%>